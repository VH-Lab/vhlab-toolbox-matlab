classdef test_multiChannelPanZoom < matlab.unittest.TestCase
    
    properties
        Figure
        Axes
        TempFile
    end
    
    methods (TestMethodSetup)
        function createFigure(testCase)
            % Create a fresh figure for each test
            testCase.Figure = figure('Visible', 'off');
            testCase.Axes = axes(testCase.Figure);
            testCase.TempFile = [tempname '.mat'];
        end
    end
    
    methods (TestMethodTeardown)
        function closeFigure(testCase)
            % Close figure (triggers cleanup)
            if isvalid(testCase.Figure)
                close(testCase.Figure);
            end
            
            % Ensure temp file is gone (double check)
            if isfile(testCase.TempFile)
                delete(testCase.TempFile);
            end
        end
    end
    
    methods (Test)
        
        function testBasicPlotting(testCase)
            % Test 1: Does it run without error?
            t = (0:0.1:10)';
            data = rand(length(t), 2);
            
            h = vlt.plot.multiChannelPanZoom(...
                'time', t, ...
                'data', data, ...
                'tempFile', testCase.TempFile);
            
            % Verify handles
            testCase.verifyTrue(isfield(h, 'lines'), 'Handle struct missing lines');
            testCase.verifyEqual(length(h.lines), 2, 'Should have created 2 lines');
            testCase.verifyTrue(isfile(testCase.TempFile), 'Temp file was not created');
        end
        
        function testDataValues(testCase)
            % Test 2: Verify the Overview data (min/max) matches input range
            t = (0:0.1:100)';
            % Create known data: Ch1=0..1, Ch2=10..11
            data = [rand(length(t),1), rand(length(t),1) + 10]; 
            
            h = vlt.plot.multiChannelPanZoom(...
                'time', t, ...
                'data', data, ...
                'channelSpacing', 0, ... % No offset for easier checking
                'tempFile', testCase.TempFile);
            
            % Check Overview Data limits
            y_data = h.Overview.Data;
            
            % Channel 1 should be within [0, 1]
            testCase.verifyGreaterThanOrEqual(min(y_data(:,1)), 0);
            testCase.verifyLessThanOrEqual(max(y_data(:,1)), 1);
            
            % Channel 2 should be within [10, 11]
            testCase.verifyGreaterThanOrEqual(min(y_data(:,2)), 10);
            testCase.verifyLessThanOrEqual(max(y_data(:,2)), 11);
        end
        
        function testZoomSwitchLogic(testCase)
            % Test 3: Verify switching between RAM (Overview) and Disk (Detail)
            
            % Setup: 100 seconds of data, Threshold = 5s
            % High sample rate to ensure Detail view has MORE points than Overview
            Fs = 1000;
            t = (0:1/Fs:100)'; 
            data = sin(2*pi*t); % 100k points
            
            h = vlt.plot.multiChannelPanZoom(...
                'time', t, ...
                'data', data, ...
                'threshold', 5.0, ...
                'tempFile', testCase.TempFile);
            
            % CASE A: Zoomed OUT (Range = 100s) -> Should have FEW points (Overview)
            % Overview is targeted at ~2000 points (x2 for min/max = 4000)
            xlim(testCase.Axes, [0 100]);
            drawnow; % Process callbacks
            
            % Check number of points in line object
            n_points_out = length(h.lines(1).XData);
            testCase.verifyLessThan(n_points_out, 5000, 'Zoomed OUT should use downsampled data');
            
            % CASE B: Zoomed IN (Range = 0.5s) 
            % 0.5s * 1000 Hz = 500 points.
            % Wait, if Overview is 4000 points, 500 is smaller.
            % We need to zoom in to a chunk that has MORE points than the Overview 
            % to prove we switched, OR check the values.
            
            % Let's use a VERY high sample rate for the test to be clear
            Fs = 20000; % 20kHz
            t = (0:1/Fs:10)'; % 10s -> 200k points
            data = rand(length(t), 1);
            
            % Update existing plot
            h = vlt.plot.multiChannelPanZoom(...
                'previousHandle', h, ... 
                'time', t, ...
                'data', data, ...
                'threshold', 2.0, ...
                'tempFile', testCase.TempFile);
            
            % Zoom to 1.0s window -> 20,000 points
            % Overview is fixed at ~4000 points.
            xlim(testCase.Axes, [4 5]);
            drawnow; 
            
            % Get the current data from the plot
            current_x = h.lines(1).XData;
            
            testCase.verifyGreaterThan(length(current_x), 10000, 'Zoomed IN should load raw high-res data (>10k points)');
        end
        
        function testCleanup(testCase)
            % Test 4: Does closing the figure delete the file?
            
            t = (0:1:10)';
            data = rand(length(t), 1);
            temp_file = [tempname '.mat']; % Use specific name
            
            % Create in a SEPARATE figure so we can close it safely
            f = figure('Visible', 'off');
            h = vlt.plot.multiChannelPanZoom(...
                'time', t, ...
                'data', data, ...
                'tempFile', temp_file);
            
            % Assert file exists
            testCase.verifyTrue(isfile(temp_file), 'File should exist');
            
            % Close figure
            close(f);
            drawnow; % Allow callbacks to fire
            
            % Assert file is gone
            testCase.verifyFalse(isfile(temp_file), 'File should be deleted after figure close');
        end
        
    end
end
