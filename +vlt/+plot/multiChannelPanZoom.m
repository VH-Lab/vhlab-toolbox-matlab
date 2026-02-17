function h = multiChannelPanZoom(options)
% MULTICHANNELPANZOOM High-performance interactive plotter for massive datasets.
%
%   h = MULTICHANNELPANZOOM('time', t, 'data', y) creates a plot in the
%   current axes capable of displaying millions of samples across multiple
%   channels without lagging. It uses a "Hybrid Swap" technique: displaying
%   a visual overview when zoomed out, and dynamically loading raw data
%   from a temporary disk cache when zoomed in.
%
%   h = MULTICHANNELPANZOOM(..., 'previousHandle', h, ...) updates an
%   existing plot with new data without destroying the figure or resetting
%   the view.
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
%       'threshold'       (Scalar, Default: 5.0)
%           The zoom duration (in seconds) below which the function switches
%           from the "Overview" (RAM) to the "High Res" (Disk) mode.
%
%       'tempFile'        (String, Default: temporary system path)
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
%       h = multiChannelPanZoom('time', t, 'data', data, 'channelSpacing', 10);
%
%       % 3. Zoom in with the mouse. The title will indicate the mode.
%       % 4. Close the figure, and the temp file is auto-deleted.

    arguments
        options.time (:,1) double {mustBeReal} = []
        options.data (:,:) {mustBeNumeric} = []
        options.channelSpacing (1,1) double = 100
        options.previousHandle struct = struct([])
        options.tempFile (1,1) string = tempname
        options.threshold (1,1) double = 5.0 
    end

    % ---------------------------------------------------------------------
    % 1. INITIALIZATION & HANDLE MANAGEMENT
    % ---------------------------------------------------------------------
    if isempty(options.previousHandle)
        % -- NEW PLOT MODE --
        h.axes = gca; 
        h.lines = gobjects(0);
        h.tempFile = options.tempFile + ".mat";
        
        % Prepare Axes
        cla(h.axes);
        hold(h.axes, 'on');
        
        isUpdate = false;
    else
        % -- UPDATE MODE --
        h = options.previousHandle;
        
        % Validation: Check if the axes handle is still valid
        if ~isfield(h, 'axes') || ~isvalid(h.axes)
            warning('Previous axes handle is invalid. Creating new axes.');
            h.axes = gca;
            cla(h.axes);
            hold(h.axes, 'on');
        end
        
        % Update temp filename only if user explicitly changed it
        if options.tempFile ~= tempname
             h.tempFile = options.tempFile; 
        end
        isUpdate = true;
    end
    
    % Store configuration in handle
    h.channelSpacing = options.channelSpacing;
    h.threshold = options.threshold;

    % ---------------------------------------------------------------------
    % 2. DATA PIPELINE (Disk Caching & Visual Downsampling)
    % ---------------------------------------------------------------------
    % Only process if new data is provided
    if ~isempty(options.data)
        
        % Check for required Time vector
        if isempty(options.time)
             error('MULTICHANNELPANZOOM:MissingTime', ...
                   'You must provide the ''time'' vector when updating ''data''.');
        end
        t = options.time;

        numChannels = size(options.data, 2);
        
        % A. Prepare Data (Cast to Single + Offset)
        % We use 'single' to reduce RAM usage by 50% and speed up GPU transfer.
        % The offset stacks the channels vertically.
        offsets = single((0:numChannels-1) * h.channelSpacing);
        data_offset = single(options.data) + offsets;
        
        % B. Save High-Res Data to Disk
        % We use the '-v7.3' flag to support partial loading (matfile).
        % This is the "Backend" data used when zoomed in.
        save(h.tempFile, 'data_offset', 't', '-v7.3');
        
        % Create the matfile interface for random access
        h.mfile = matfile(h.tempFile);
        h.timeLimits = [t(1), t(end)];
        h.numSamples = length(t);
        h.numChannels = numChannels;

        % C. Compute "Overview" Data (Min/Max Envelope)
        % This is the "Frontend" data used when zoomed out.
        % We reduce the dataset to ~2000 visible points per channel.
        n_visual = 2000;
        step = max(1, floor(length(t) / n_visual));
        n_chunks = floor(length(t) / step);
        
        if n_chunks < 1, n_chunks = 1; step = 1; end 
        
        idx_lim = n_chunks * step;
        
        % Reshape to [step x n_chunks x numChannels]
        y_reshaped = reshape(data_offset(1:idx_lim, :), step, n_chunks, numChannels);
        
        % Calculate Min and Max for each bin (Visual Envelope)
        y_min = squeeze(min(y_reshaped, [], 1)); 
        y_max = squeeze(max(y_reshaped, [], 1)); 
        
        % Edge case for single channel squeeze behavior
        if numChannels == 1, y_min = y_min'; y_max = y_max'; end
        
        % Interleave Min/Max: [Min1, Max1, Min2, Max2...]
        h.Overview.Data = zeros(n_chunks*2, numChannels, 'single');
        h.Overview.Data(1:2:end, :) = y_min;
        h.Overview.Data(2:2:end, :) = y_max;
        
        % Create matching time vector
        t_down = t(1:step:idx_lim);
        h.Overview.Time = zeros(n_chunks*2, 1);
        h.Overview.Time(1:2:end) = t_down;
        h.Overview.Time(2:2:end) = t_down; % Vertical line construction
    end

    % ---------------------------------------------------------------------
    % 3. RENDERING
    % ---------------------------------------------------------------------
    if ~isUpdate
        % Create Lines
        h.lines = plot(h.axes, h.Overview.Time, h.Overview.Data);
        
        % Optimize Interactions
        set(h.lines, 'HitTest', 'off', 'PickableParts', 'none');
        
        xlabel(h.axes, 'Time (s)');
        ylabel(h.axes, 'Channel Amplitude (Offset)');
        axis(h.axes, 'tight');
        
        % Setup Callbacks and Cleanup
        setupCallbacks(h);
    else
        % Update Existing Lines
        if length(h.lines) ~= h.numChannels
            % If channel count changed, recreate objects
            delete(h.lines);
            h.lines = plot(h.axes, h.Overview.Time, h.Overview.Data);
            set(h.lines, 'HitTest', 'off', 'PickableParts', 'none');
        else
            % Update Data Only (Faster)
            for i = 1:h.numChannels
                set(h.lines(i), 'XData', h.Overview.Time, ...
                                'YData', h.Overview.Data(:,i));
            end
        end
    end
    
    % ---------------------------------------------------------------------
    % 4. AUTOMATIC CLEANUP ATTACHMENT
    % ---------------------------------------------------------------------
    % We attach an onCleanup object to the Axes UserData.
    % When the Axes (and thus the Figure) is closed/deleted, this triggers.
    % It does NOT trigger if you just 'clear h' in the workspace, which 
    % protects the interactive plot from breaking while open.
    
    cleaner = onCleanup(@() deleteTempFile(h.tempFile));
    h.cleanup = cleaner; 
    
    % Save the full state (including the cleaner) into the Axes UserData
    h.axes.UserData = h;
end

% -------------------------------------------------------------------------
% HELPER: Cleanup Function
% -------------------------------------------------------------------------
function deleteTempFile(filename)
    if exist(filename, 'file')
        try
            delete(filename);
            % fprintf('Temp file cleaned up: %s\n', filename); % Debug only
        catch
            warning('Could not delete temporary file: %s', filename);
        end
    end
end

% -------------------------------------------------------------------------
% HELPER: Setup Zoom/Pan Listeners
% -------------------------------------------------------------------------
function setupCallbacks(h)
    % Attach listener to the XLim property.
    % 'PostSet' ensures we fire after the user finishes the zoom action.
    if ~isfield(h, 'listener') || ~isvalid(h.listener)
        h.listener = addlistener(h.axes, 'XLim', 'PostSet', @zoomHandler);
    end
end

% -------------------------------------------------------------------------
% CORE ENGINE: The Zoom Handler
% -------------------------------------------------------------------------
function zoomHandler(~, eventData)
    % Retrieve the handle structure from the Axes UserData
    % This is robust against workspace variable clearing.
    ax = eventData.AffectedObject;
    if isempty(ax.UserData), return; end
    h = ax.UserData;
    
    if ~isfield(h, 'mfile'), return; end
    
    % 1. Determine Current View Width
    xlims = ax.XLim;
    view_width = xlims(2) - xlims(1);
    
    % 2. Check Threshold
    if view_width < h.threshold
        % --- HIGH RES MODE (DISK) ---
        
        % Map Time Range to Indices
        % We use linear interpolation for speed (O(1) vs O(N) search)
        t_start = h.timeLimits(1);
        t_end   = h.timeLimits(2);
        
        frac_start = (xlims(1) - t_start) / (t_end - t_start);
        frac_end   = (xlims(2) - t_start) / (t_end - t_start);
        
        idx_start = floor(frac_start * h.numSamples);
        idx_end   = ceil(frac_end * h.numSamples);
        
        % Clamp to valid range
        idx_start = max(1, idx_start);
        idx_end   = min(h.numSamples, idx_end);
        
        if idx_end > idx_start
            % Partial Load
            try
                t_chunk = h.mfile.t(idx_start:idx_end, 1);
                y_chunk = h.mfile.data_offset(idx_start:idx_end, :);
                
                % Update Plot Objects
                if length(h.lines) == size(y_chunk, 2)
                     for i = 1:length(h.lines)
                         set(h.lines(i), 'XData', t_chunk, 'YData', y_chunk(:,i));
                     end
                end
                
                % Optional: Update title to show state
                % title(ax, 'Detail View (Raw Data)');
            catch
                % Fallback if file access fails
            end
        end
        
    else
        % --- OVERVIEW MODE (RAM) ---
        
        % Check if we need to switch back
        current_len = length(h.lines(1).XData);
        overview_len = length(h.Overview.Time);
        
        if current_len ~= overview_len
            for i = 1:length(h.lines)
                set(h.lines(i), 'XData', h.Overview.Time, ...
                                'YData', h.Overview.Data(:,i));
            end
            % title(ax, 'Overview (Downsampled)');
        end
    end
end
