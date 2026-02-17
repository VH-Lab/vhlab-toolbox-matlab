classdef test_multiChannelPanZoom < matlab.unittest.TestCase
    
    properties
        Figure
        Axes
        TempFile
    end
    
    methods (TestMethodSetup)
        function createFigure(testCase)
            testCase.Figure = figure('Visible', 'off');
            testCase.Axes = axes(testCase.Figure);
            testCase.TempFile = [tempname '.mat'];
        end
    end
    
    methods (TestMethodTeardown)
        function closeFigure(testCase)
            if isvalid(testCase.Figure), close(testCase.Figure); end
            if isfile(testCase.TempFile), delete(testCase.TempFile); end
        end
    end
    
    methods (Test)
        
        function testThreeTierLogic(testCase)
            % This test verifies the 3-Stage Zoom Pyramid
            
            % Setup: 300 seconds of data
            % T1 (Overview): > 60s window
            % T2 (Mid-Tier): 2s - 60s window
            % T3 (Raw Disk): < 2s window
            
            Fs = 1000;
            t = (0:1/Fs:300)'; 
            data = sin(2*pi*t); % 300k points
            
            h = vlt.plot.multiChannelPanZoom(...
                'time', t, ...
                'data', data, ...
                'midThreshold', 60.0, ...
                'threshold', 2.0, ...
                'tempFile', testCase.TempFile);
            
            % --- TEST 1: MACRO VIEW (Tier 1) ---
            % Zoom out to full 300s
            xlim(testCase.Axes, [0 300]);
            drawnow; 
            
            % Check point count. Tier 1 target is ~2000 points.
            n_points = length(h.lines(1).XData);
            testCase.verifyLessThan(n_points, 5000, 'Macro View should use Tier 1 (Small RAM)');
            
            
            % --- TEST 2: MID VIEW (Tier 2) ---
            % Zoom to 30s window (Between 2s and 60s)
            xlim(testCase.Axes, [100 130]);
            drawnow;
            
            n_points = length(h.lines(1).XData);
            
            % Tier 2 target is ~50,000 points. 
            % It should be MUCH larger than Tier 1.
            testCase.verifyGreaterThan(n_points, 10000, 'Mid View should use Tier 2 (Large RAM)');
            
            % CRITICAL CHECK: Tier 2 loads the WHOLE 50k vector for the full 300s, 
            % whereas Tier 3 loads only the sliced 30s.
            % The XData for Tier 2 should span 0..300s.
            x_range = h.lines(1).XData(end) - h.lines(1).XData(1);
            testCase.verifyGreaterThan(x_range, 299, 'Tier 2 should have data for the FULL duration in RAM');
            
            
            % --- TEST 3: MICRO VIEW (Tier 3) ---
            % Zoom to 0.5s window (< 2s)
            xlim(testCase.Axes, [150 150.5]);
            drawnow;
            
            % This should trigger disk load.
            % Data should only exist for the visible window (plus/minus margins).
            x_range = h.lines(1).XData(end) - h.lines(1).XData(1);
            
            testCase.verifyLessThan(x_range, 2.0, 'Tier 3 (Disk) should only load the specific slice requested');
        end
        
        function testCleanup(testCase)
             % This test previously failed. It should now pass.
             
             t = (0:1:10)'; data = rand(length(t), 1);
             f = figure('Visible', 'off');
             
             % Create plot
             h = vlt.plot.multiChannelPanZoom('time', t, 'data', data, 'tempFile', testCase.TempFile);
             
             % File should exist
             testCase.verifyTrue(isfile(testCase.TempFile));
             
             % Close figure. 
             % NOTE: 'h' still exists in this workspace, but the file should be deleted anyway
             close(f);
             drawnow;
             
             testCase.verifyFalse(isfile(testCase.TempFile), 'File should be deleted even if handle h exists');
        end
    end
end