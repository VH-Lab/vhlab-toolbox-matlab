classdef testTimeline < matlab.unittest.TestCase
    % testTimeline - Unit tests for the vlt.plot.timeline function.
    %

    methods (Test)

        function testTimelineSmokeTest(testCase)
            % A smoke test that runs the example from the documentation.
            % This verifies that the function executes without throwing an error.

            % Create an array of timelineRow objects
            commands(1) = vlt.plot.timelineRow(...
                'Row', 1, 'Type', "Heading1", 'String', "Experiment Timeline", 'T0', 5, 'T1', 5);
            commands(2) = vlt.plot.timelineRow(...
                'Row', 2, 'Type', "Bar", 'T0', 2, 'T1', 6, 'Color', [0.5 0.5 1], 'BarHeight', 0.8);
            commands(3) = vlt.plot.timelineRow(...
                'Row', 2, 'Type', "Marker", 'T0', 4, 'T1', 4, 'Symbol', "o", 'Color', [1 0 0]);
            commands(4) = vlt.plot.timelineRow(...
                'Row', 3, 'Type', "Bar", 'T0', 6, 'T1', 10, 'Color', [0.5 1 0.5], 'BarHeight', 0.6);
            commands(5) = vlt.plot.timelineRow(...
                'Row', 3, 'Type', "Marker", 'T0', 8, 'T1', 8, 'Symbol', "s", 'Color', [0 0 1]);
            commands(6) = vlt.plot.timelineRow(...
                'Row', 4, 'Type', "OnsetTriangle", 'T0', 1, 'T1', 3, 'Color', [1 0.5 0.5]);
            commands(7) = vlt.plot.timelineRow(...
                'Row', 4, 'Type', "OffsetTriangle", 'T0', 9, 'T1', 10, 'Color', [0.5 0.5 1]);

            % Call the function and verify that a figure is created
            f = figure('Visible','off'); % Create an invisible figure
            vlt.plot.timeline(commands, 'rowHeight', 1.5, 'Heading1FontSize', 16);

            testCase.verifyNotEmpty(findobj(groot, 'Type', 'figure'), ...
                'A figure should be created by the timeline function.');

            close(f); % Close the figure
        end

        function testPlotObjectProperties(testCase)
            % A more detailed test to verify the properties of plotted objects.
            % This confirms that bars and triangles are drawn with the correct
            % coordinates and dimensions.

            rowHeight = 2;

            % Create a simple set of commands for verification
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "Bar", 'T0', 2, 'T1', 5, 'BarHeight', 0.8);
            commands(2) = vlt.plot.timelineRow('Row', 2, 'Type', "OnsetTriangle", 'T0', 7, 'T1', 9, 'BarHeight', 0.6);

            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'rowHeight', rowHeight);
            ax = gca;

            % Find the plotted objects
            barObj = findobj(ax, 'Type', 'Rectangle');
            triangleObj = findobj(ax, 'Type', 'Patch');

            % --- Verification for the bar ---
            bar_row_center = (1 - 1) * rowHeight + rowHeight/2;
            bar_y_start = bar_row_center - 0.8 * rowHeight / 2;
            bar_h = 0.8 * rowHeight;
            expectedBarPosition = [2, bar_y_start, 3, bar_h];
            testCase.verifyEqual(barObj.Position, expectedBarPosition, 'AbsTol', 1e-6);

            % --- Verification for the triangle ---
            tri_row_center = (2 - 1) * rowHeight + rowHeight/2;
            tri_y_top = tri_row_center - 0.6 * rowHeight / 2;
            tri_y_bottom = tri_row_center + 0.6 * rowHeight / 2;
            expectedTriangleVertices = [7, tri_y_bottom; 9, tri_y_bottom; 9, tri_y_top];
            testCase.verifyEqual(triangleObj.Vertices, expectedTriangleVertices, 'AbsTol', 1e-6);

            close(f);
        end

    end
end