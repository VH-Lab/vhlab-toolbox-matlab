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
            % Test the RowLabel, time boundaries, and background color features.
            bgColor = [1 1 0.8]; % A light yellow
            f = figure('Visible','off');
            vlt.plot.timeline([], 'timelineBackgroundColor', bgColor);
            ax = gca;
            testCase.verifyEqual(ax.Color, bgColor, 'AbsTol', 1e-6, ...
                'Axes background color should be set by the parameter.');
            close(f);
        end

        function testVerticalBars(testCase)
            % Test the verticalDashedBar and verticalSolidBar types.
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "verticalDashedBar", 'T0', 3, 'LineWidth', 2);
            commands(2) = vlt.plot.timelineRow('Row', 2, 'Type', "verticalSolidBar", 'T0', 5, 'Color', [1 0 0]);

            f = figure('Visible','off');
            vlt.plot.timeline(commands);
            ax = gca;

            % Verify dashed bar
            dashedBar = findobj(ax, 'Type', 'Line', 'LineStyle', '--');
            testCase.verifyNotEmpty(dashedBar, 'Dashed bar should be created.');
            testCase.verifyEqual(dashedBar.XData, [3 3], 'AbsTol', 1e-6);
            testCase.verifyEqual(dashedBar.LineWidth, 2, 'AbsTol', 1e-6);

            % Verify solid bar
            solidBar = findobj(ax, 'Type', 'Line', 'LineStyle', '-');
            testCase.verifyNotEmpty(solidBar, 'Solid bar should be created.');
            testCase.verifyEqual(solidBar.XData, [5 5], 'AbsTol', 1e-6);
            testCase.verifyEqual(solidBar.Color, [1 0 0], 'AbsTol', 1e-6);
            testCase.verifyEqual(solidBar.LineWidth, 0.76, 'AbsTol', 1e-6); % Default value

            close(f);
        end
        function testTimelineFromJSON(testCase)
            % Test the creation of a timeline from a JSON string.
            jsonStr = ['{', ...
                '"timelineParameters": [', ...
                '  {"Name": "timelineBackgroundColor", "Value": [0.8, 1, 0.8]}', ...
                '],', ...
                '"timelineRows": [', ...
                '  {"Row": 1, "Type": "Bar", "T0": 2, "T1": 8}', ...
                ']', ...
            '}'];

            f = figure('Visible','off');
            vlt.plot.timelineFromJSON(jsonStr);
            ax = gca;

            % Verify background color from JSON
            expectedColor = [0.8 1 0.8];
            testCase.verifyEqual(ax.Color, expectedColor, 'AbsTol', 1e-6, ...
                'Axes background color should be set from JSON.');

            close(f);
        end

    end
end