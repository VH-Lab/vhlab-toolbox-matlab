classdef testTimeline < matlab.unittest.TestCase
    % testTimeline - Unit tests for the vlt.plot.timeline function.
    %

    methods (Test)

        function testTimelineSmokeTest(testCase)
            % A smoke test that runs the example from the documentation.
            commands(1) = vlt.plot.timelineRow('Row',1,'Type',"RowLabel",'String',"My first row");
            commands(2) = vlt.plot.timelineRow('Row',1,'Type',"Bar",'T0',2,'T1',4);
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'timePre', 0, 'timeStart', 0, 'timeEnd', 10);
            testCase.verifyNotEmpty(findobj(groot, 'Type', 'figure'));
            close(f);
        end

        function testPlotObjectProperties(testCase)
            % A more detailed test to verify the properties of plotted objects.
            rowHeight = 2;
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "Bar", 'T0', 2, 'T1', 5, 'BarHeight', 0.8);
            commands(2) = vlt.plot.timelineRow('Row', 2, 'Type', "OnsetTriangle", 'T0', 7, 'T1', 9, 'BarHeight', 0.6);
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'rowHeight', rowHeight);
            ax = gca;
            barObj = findobj(ax, 'Type', 'Rectangle');
            triangleObj = findobj(ax, 'Type', 'Patch');

            bar_row_center = (1 - 1) * rowHeight + rowHeight/2;
            bar_y_start = bar_row_center - 0.8 * rowHeight / 2;
            bar_h = 0.8 * rowHeight;
            expectedBarPosition = [2, bar_y_start, 3, bar_h];
            testCase.verifyEqual(barObj.Position, expectedBarPosition, 'AbsTol', 1e-6);

            tri_row_center = (2 - 1) * rowHeight + rowHeight/2;
            tri_y_top = tri_row_center - 0.6 * rowHeight / 2;
            tri_y_bottom = tri_row_center + 0.6 * rowHeight / 2;
            expectedTriangleVertices = [7, tri_y_bottom; 9, tri_y_bottom; 9, tri_y_top];
            testCase.verifyEqual(triangleObj.Vertices, expectedTriangleVertices, 'AbsTol', 1e-6);
            close(f);
        end

        function testNewFeatures(testCase)
            % Test the RowLabel, time boundaries, and vertical bar features.
            timePre = -2;
            timeEnd = 12;
            timeStart = 0;
            labelString = "Test Label";

            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "RowLabel", 'String', labelString);
            commands(2) = vlt.plot.timelineRow('Row', 1, 'Type', "Bar", 'T0', 3, 'T1', 8);

            f = figure('Visible','off');
            vlt.plot.timeline(commands, ...
                'timePre', timePre, 'timeEnd', timeEnd, 'timeStart', timeStart, ...
                'timeStartVerticalBar', true, 'timeStartVerticalBarColor', [1 0 1]);
            ax = gca;

            % Verify X-axis limits
            testCase.verifyEqual(ax.XLim, [timePre timeEnd], 'AbsTol', 1e-6);

            % Verify RowLabel text object
            textObj = findobj(ax, 'Type', 'Text', 'String', labelString);
            testCase.verifyNotEmpty(textObj, 'RowLabel text object should be created.');
            testCase.verifyEqual(textObj.Position(1), timePre, 'AbsTol', 1e-6, 'RowLabel should be at timePre.');
            testCase.verifyEqual(textObj.HorizontalAlignment, 'right', 'RowLabel should be right-aligned.');

            % Verify vertical start bar
            startBar = findobj(ax, 'Type', 'Line');
            % Filter out any lines that are not the vertical bar
            isStartBar = arrayfun(@(h) isequal(h.XData, [timeStart timeStart]), startBar);
            startBar = startBar(isStartBar);

            testCase.verifyNotEmpty(startBar, 'Vertical start bar should be created.');
            testCase.verifyEqual(startBar.Color, [1 0 1], 'Start bar should have the specified color.');

            close(f);
        end

    end
end