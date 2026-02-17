function h = multiChannelPanZoom(options)
% MULTICHANNELPANZOOM High-performance 3-Stage Pyramid Plotter for Massive Data.
%
%   h = MULTICHANNELPANZOOM('time', t, 'data', y) creates a specialized
%   plot in the current axes (gca) designed to handle millions of samples
%   across multiple channels without UI lag or visual aliasing.
%
%   THE 3-TIER ARCHITECTURE:
%   To solve the trade-off between speed and detail, this function automatically
%   switches between three data sources based on the current Zoom Level:
%
%     1. Tier 1 (Overview):  Ultra-lightweight (~2,000 pts). Instant panning
%                            of the entire dataset. (RAM Cached)
%     2. Tier 2 (Mid-Res):   Medium resolution (~50,000 pts). Sharp visualization
%                            of 10-60 second windows without disk lag. (RAM Cached)
%     3. Tier 3 (Raw Disk):  Full resolution. Dynamically loaded from disk only
%                            when zoomed in to the sample level. (Disk Buffered)
%
%   INPUT ARGUMENTS (Name-Value Pairs):
%
%       'time'            (Numeric Vector)
%           The time vector corresponding to the data rows. Must be strictly
%           increasing. Required when providing new 'data'.
%
%       'data'            (Numeric Matrix)
%           An NxM matrix where N is samples and M is channels.
%           Data is automatically cast to 'single' precision for performance.
%
%       'channelSpacing'  (Scalar, Default: 100)
%           The vertical Y-axis offset added to each subsequent channel to
%           create a "stacked" strip-chart appearance.
%           Channel k is plotted at: data(:,k) + (k-1)*channelSpacing.
%
%       'previousHandle'  (Structure, Optional)
%           The structure returned by a previous call to this function.
%           Use this to update the data on an existing plot efficiently.
%
%       'threshold'       (Scalar, Default: 2.0 seconds)
%           Zoom duration below which the plot switches to RAW DISK mode.
%           Set this to a small value (e.g., 2-5s) to avoid disk lag.
%
%       'midThreshold'    (Scalar, Default: 60.0 seconds)
%           Zoom duration below which the plot switches to MID-RES RAM mode.
%           This bridges the gap between the rough overview and the raw data.
%
%       'tempFile'        (String, Default: system temp name)
%           The path where the raw data binary cache will be stored.
%           NOTE: This file is automatically deleted when the Figure is closed.
%
%   OUTPUT:
%       h (Structure)
%           Contains handles to the graphics objects, file paths, and state
%           data. Store this to pass back into 'previousHandle' later.
%
%   EXAMPLE:
%       % 1. Generate 32 channels of data (6 million points)
%       Fs = 20000;
%       t = (0:1/Fs:300)';
%       data = randn(length(t), 32);
%
%       % 2. Plot with interactive zoom
%       h = vlt.plot.multiChannelPanZoom('time', t, 'data', data, ...
%                                        'midThreshold', 30, ...
%                                        'threshold', 2);
%
%       % 3. Zoom/Pan is now handled automatically.
%       % 4. Close figure to auto-delete temporary cache.

    arguments
        options.time (:,1) double {mustBeReal} = []
        options.data (:,:) {mustBeNumeric} = []
        options.channelSpacing (1,1) double = 100
        options.previousHandle struct = struct([])
        options.tempFile (1,1) string = tempname
        
        % ZOOM THRESHOLDS
        options.midThreshold (1,1) double = 60.0 % Tier 1 -> Tier 2 (RAM)
        options.threshold (1,1) double = 2.0     % Tier 2 -> Tier 3 (Disk)
    end

    % ---------------------------------------------------------------------
    % 1. INITIALIZATION & STATE MANAGEMENT
    % ---------------------------------------------------------------------
    if isempty(options.previousHandle)
        % -- NEW PLOT --
        h.axes = gca; 
        h.lines = gobjects(0);
        
        % Robust File Extension Check
        if endsWith(options.tempFile, ".mat", 'IgnoreCase', true)
            h.tempFile = options.tempFile;
        else
            h.tempFile = options.tempFile + ".mat";
        end
        
        % Prepare Axes
        cla(h.axes);
        hold(h.axes, 'on');
        isUpdate = false;
    else
        % -- UPDATE EXISTING --
        h = options.previousHandle;
        
        % Validate Axes Validity
        if ~isfield(h, 'axes') || ~isvalid(h.axes)
            warning('Previous axes handle is invalid. Creating new axes.');
            h.axes = gca; cla(h.axes); hold(h.axes, 'on');
        end
        
        % Update filename if changed by user
        if options.tempFile ~= tempname
            if endsWith(options.tempFile, ".mat", 'IgnoreCase', true)
                h.tempFile = options.tempFile;
            else
                h.tempFile = options.tempFile + ".mat";
            end
        end
        isUpdate = true;
    end
    
    % Store configuration
    h.channelSpacing = options.channelSpacing;
    h.thresholdRaw = options.threshold;       
    h.thresholdMid = options.midThreshold;    

    % ---------------------------------------------------------------------
    % 2. DATA PIPELINE CONSTRUCTION (3-TIER SYSTEM)
    % ---------------------------------------------------------------------
    if ~isempty(options.data)
        % Validate Time
        if isempty(options.time)
             error('MULTICHANNELPANZOOM:MissingTime', ...
                   'You must provide the ''time'' vector when updating ''data''.');
        end
        t = options.time;
        numChannels = size(options.data, 2);
        
        % A. Prepare Data (Offset + Cast to Single)
        offsets = single((0:numChannels-1) * h.channelSpacing);
        data_offset = single(options.data) + offsets;
        
        % B. TIER 3 (Raw Data): Save to Disk
        % We use the '-v7.3' flag to support partial loading (matfile).
        save(h.tempFile, 'data_offset', 't', '-v7.3');
        h.mfile = matfile(h.tempFile);
        h.timeLimits = [t(1), t(end)];
        h.numSamples = length(t);
        h.numChannels = numChannels;

        % C. TIER 1 (Overview RAM): ~2,000 points
        % Ultra-fast for full-file viewing.
        h.Tier1 = createDownsampledStruct(t, data_offset, 2000);
        
        % D. TIER 2 (Mid-Res RAM): ~50,000 points
        % High quality for intermediate zooms (10s-60s range).
        h.Tier2 = createDownsampledStruct(t, data_offset, 50000);
        
        % Track current state
        h.currentTier = 1; 
    end

    % ---------------------------------------------------------------------
    % 3. RENDERING
    % ---------------------------------------------------------------------
    if ~isUpdate
        % Start with Tier 1
        h.lines = plot(h.axes, h.Tier1.Time, h.Tier1.Data);
        
        % OPTIMIZATION: Disable HitTest (Critical for performance)
        set(h.lines, 'HitTest', 'off', 'PickableParts', 'none');
        
        xlabel(h.axes, 'Time (s)');
        ylabel(h.axes, 'Channel (Offset)');
        axis(h.axes, 'tight');
        
        setupCallbacks(h);
    else
        % Update Existing Objects
        if length(h.lines) ~= h.numChannels
            delete(h.lines);
            h.lines = plot(h.axes, h.Tier1.Time, h.Tier1.Data);
            set(h.lines, 'HitTest', 'off', 'PickableParts', 'none');
        else
            % Update Data Pointers Only (Fast)
            for i = 1:h.numChannels
                set(h.lines(i), 'XData', h.Tier1.Time, ...
                                'YData', h.Tier1.Data(:,i));
            end
        end
    end
    
    % ---------------------------------------------------------------------
    % 4. AUTOMATIC CLEANUP (Robust Implementation)
    % ---------------------------------------------------------------------
    % We attach the onCleanup object to the Axes' Application Data.
    % This decouples the file deletion from the 'h' variable in the workspace.
    % The file is deleted only when the Axes/Figure is destroyed.
    
    current_cleaner_file = getappdata(h.axes, 'MultiChannelCleanupFile');
    
    % Only create a new cleaner if the file has changed or doesn't exist
    if isempty(current_cleaner_file) || ~strcmp(current_cleaner_file, h.tempFile)
        cleaner = onCleanup(@() deleteTempFile(h.tempFile));
        setappdata(h.axes, 'MultiChannelCleanup', cleaner);
        setappdata(h.axes, 'MultiChannelCleanupFile', h.tempFile);
    end
    
    % Save the full state (handle) into the Axes UserData for callbacks
    h.axes.UserData = h;
end

% -------------------------------------------------------------------------
% HELPER: Tier Generator (Min/Max Algorithm)
% -------------------------------------------------------------------------
function S = createDownsampledStruct(t, data, targetPoints)
    % Creates a Min/Max visual envelope of the data
    n_samples = length(t);
    step = max(1, floor(n_samples / targetPoints));
    n_chunks = floor(n_samples / step);
    
    if n_chunks < 1, n_chunks = 1; step = 1; end
    
    idx_lim = n_chunks * step;
    numChannels = size(data, 2);
    
    % Reshape for vectorized min/max
    y_reshaped = reshape(data(1:idx_lim, :), step, n_chunks, numChannels);
    y_min = squeeze(min(y_reshaped, [], 1));
    y_max = squeeze(max(y_reshaped, [], 1));
    
    % Handle single channel squeeze edge case
    if numChannels == 1, y_min = y_min'; y_max = y_max'; end
    
    % Interleave Min/Max: [Min, Max, Min, Max...]
    S.Data = zeros(n_chunks*2, numChannels, 'single');
    S.Data(1:2:end, :) = y_min;
    S.Data(2:2:end, :) = y_max;
    
    % Interleave Time
    t_down = t(1:step:idx_lim);
    S.Time = zeros(n_chunks*2, 1);
    S.Time(1:2:end) = t_down;
    S.Time(2:2:end) = t_down;
end

% -------------------------------------------------------------------------
% HELPER: Callbacks & State Machine
% -------------------------------------------------------------------------
function setupCallbacks(h)
    % Attach listener to the XLim property.
    if ~isfield(h, 'listener') || ~isvalid(h.listener)
        h.listener = addlistener(h.axes, 'XLim', 'PostSet', @zoomHandler);
    end
end

function zoomHandler(~, eventData)
    % Retrieve Handle from Axes UserData
    ax = eventData.AffectedObject;
    if isempty(ax.UserData), return; end
    h = ax.UserData;
    
    if ~isfield(h, 'mfile'), return; end
    
    % 1. Determine Zoom Level
    xlims = ax.XLim;
    view_width = xlims(2) - xlims(1);
    
    % 2. 3-Way Decision Tree
    
    if view_width < h.thresholdRaw
        % >>> TIER 3: RAW DISK <<<
        loadFromDisk(h, xlims);
        
    elseif view_width < h.thresholdMid
        % >>> TIER 2: MID RES RAM <<<
        % Check if update is needed (simple length check)
        if length(h.lines(1).XData) ~= length(h.Tier2.Time)
             updateRAM(h, h.Tier2);
             % Optional debug: title(ax, 'Mid Res (RAM)'); 
        end
        
    else
        % >>> TIER 1: OVERVIEW RAM <<<
        if length(h.lines(1).XData) ~= length(h.Tier1.Time)
             updateRAM(h, h.Tier1);
             % Optional debug: title(ax, 'Overview (RAM)');
        end
    end
end

function updateRAM(h, TierStruct)
    % Fast update using cached RAM data
    for i = 1:length(h.lines)
        set(h.lines(i), 'XData', TierStruct.Time, 'YData', TierStruct.Data(:,i));
    end
end

function loadFromDisk(h, xlims)
    % Calculate file indices based on time (Linear Interpolation)
    t_start = h.timeLimits(1);
    t_end   = h.timeLimits(2);
    
    frac_start = (xlims(1) - t_start) / (t_end - t_start);
    frac_end   = (xlims(2) - t_start) / (t_end - t_start);
    
    idx_start = max(1, floor(frac_start * h.numSamples));
    idx_end   = min(h.numSamples, ceil(frac_end * h.numSamples));
    
    % Only load if valid
    if idx_end > idx_start
        try
            % Partial Load from MAT-file
            t_chunk = h.mfile.t(idx_start:idx_end, 1);
            y_chunk = h.mfile.data_offset(idx_start:idx_end, :);
            
            % Update Plot
            if length(h.lines) == size(y_chunk, 2)
                 for i = 1:length(h.lines)
                     set(h.lines(i), 'XData', t_chunk, 'YData', y_chunk(:,i));
                 end
            end
        catch
             % Fail silently on file access error
        end
    end
end

% -------------------------------------------------------------------------
% HELPER: File Cleanup
% -------------------------------------------------------------------------
function deleteTempFile(filename)
    if exist(filename, 'file')
        try
            delete(filename);
            % fprintf('Temp file cleaned up: %s\n', filename);
        catch
            warning('MULTICHANNELPANZOOM:CleanupFail', ...
                    'Could not delete temporary file: %s', filename);
        end
    end
end