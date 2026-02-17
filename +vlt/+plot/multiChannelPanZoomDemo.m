function multiChannelPanZoomDemo
% MULTICHANNELPANZOOMDEMO Demonstrates the high-performance plotting tool.
%
%   This demo generates 32 channels of high-frequency data (20kHz) over
%   300 seconds (approx 6 million points per channel).
%   It then plots them using the Hybrid Swap technique.
%
%   Key Features to Test:
%   1. Zoom out fully: You see the "Overview" (Min/Max envelope).
%   2. Zoom in (< 5 sec): The plot snaps to high-resolution raw data.
%   3. Pan around: The data loads dynamically from disk.
%   4. Close the figure: The temporary cache file is automatically deleted.

    %% 1. Configuration
    numChannels = 32;
    Fs = 20000;         % 20 kHz sampling rate
    duration = 300;     % 300 seconds
    channelSpacing = 5; % Vertical distance between channels
    
    fprintf('Generating %.1f million points of data... ', ...
            (numChannels * Fs * duration) / 1e6);
    
    %% 2. Generate Synthetic Data (Sinusoids + Noise)
    t = (0:1/Fs:duration)';
    data = zeros(length(t), numChannels, 'single');
    
    % create meaningful signals
    for ch = 1:numChannels
        % Base frequency changes per channel (10Hz to 60Hz)
        freq = 10 + (ch * 1.5); 
        
        % Add a slow drift
        drift = sin(2*pi*0.01*t);
        
        % Add high frequency noise (to test aliasing/downsampling)
        noise = 0.2 * randn(size(t), 'single');
        
        % Combine: Signal + Drift + Noise
        data(:, ch) = sin(2*pi*freq*t) + drift + noise;
    end
    fprintf('Done.\n');
    
    %% 3. Create the Plot
    fprintf('Plotting...\n');
    
    % Create a new figure
    figure('Name', 'Multi-Channel Zoom Demo', 'NumberTitle', 'off');
    
    % Call the plotter function
    % We set the threshold to 2.0 seconds to make the "snap" obvious
    h = vlt.plot.multiChannelPanZoom('time', t, ...
                            'data', data, ...
                            'channelSpacing', channelSpacing, ...
                            'threshold', 2.0);
                        
    title('Zoom in to < 2.0s to see raw data (Check Command Window for status)');
    
    %% 4. Simulate an Update (Optional)
    % This part demonstrates how to update the plot without closing the window.
    % We will pause, then add a "stimulus artifact" to the data and re-plot.
    
    fprintf('Paused. Press any key to simulate a data update...\n');
    pause;
    
    fprintf('Updating data with artifacts...\n');
    
    % Add a large spike at t=150s to all channels
    idx_spike = 150 * Fs;
    data(idx_spike:idx_spike+500, :) = 10; % Huge spike
    
    % Update the existing plot using the previous handle 'h'
    h = vlt.plot.multiChannelPanZoom('previousHandle', h, ...
                            'time', t, ...
                            'data', data);
                        
    title('Data Updated! Look at t=150s for the artifact.');
    fprintf('Demo Complete. Try zooming in/out.\n');

end
