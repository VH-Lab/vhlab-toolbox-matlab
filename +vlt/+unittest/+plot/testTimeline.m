classdef testTimeline < matlab.unittest.TestCase
    % testTimeline - Unit tests for the vlt.plot.timeline and related functions.
    %

    methods (Test)

        function testTimelineSmokeTest(testCase)
            % A smoke test that runs the example from the documentation.
            commands(1) = vlt.plot.timelineRow('Row',1,'Type',"RowLabel",'String',"My first row");
            commands(2) = vlt.plot.timelineRow('Row',1,'Type',"Bar",'T0',2,'T1',4);
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'timePre', 0, 'timeStart', 0, 'timeEnd', 10);
            testCase.verifyNotEmpty(findobj(groot, 'Type', 'figure'), 'A figure should be created.');
            close(f);
        end

        function testPlotObjectProperties(testCase)
            % A more detailed test to verify the properties of plotted objects.
            rowHeight = 2;
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "Bar", 'T0', 2, 'T1', 5, 'BarHeight', 0.8);
            commands(2) = vlt.plot.timelineRow('Row', 2, 'Type', "OnsetTriangle", 'T0', 7, 'T1', 9, 'BarHeight', 0.6);
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'rowHeight', rowHeight, 'timeStartVerticalBar', false);
            ax = gca;
            barObj = findobj(ax, 'Type', 'Rectangle');
            triangleObj = findobj(ax, 'Type', 'Patch');

            bar_row_center = (1 - 1) * rowHeight + rowHeight/2;
            bar_y_start = bar_row_center - 0.8 * rowHeight / 2;
            bar_h = 0.8 * rowHeight;
            expectedBarPosition = [2, bar_y_start, 3, bar_h];
            testCase.verifyEqual(barObj.Position, expectedBarPosition, 'AbsTol', 1e-6, 'Bar position is incorrect.');

            tri_row_center = (2 - 1) * rowHeight + rowHeight/2;
            tri_y_top = tri_row_center - 0.6 * rowHeight / 2;
            tri_y_bottom = tri_row_center + 0.6 * rowHeight / 2;
            expectedTriangleVertices = [7, tri_y_bottom; 9, tri_y_bottom; 9, tri_y_top];
            testCase.verifyEqual(triangleObj.Vertices, expectedTriangleVertices, 'AbsTol', 1e-6, 'Triangle vertices are incorrect.');
            close(f);
        end

        function testEmptyTimeline(testCase)
            % Test that calling with an empty command array doesn't error.
            f = figure('Visible','off');
            vlt.plot.timeline(vlt.plot.timelineRow.empty(), 'timelineBackgroundColor', [1 1 1]);
            ax = gca;
            testCase.verifyEqual(ax.Color, [1 1 1], 'AbsTol', 1e-6, 'Background color should be set even for empty timeline.');
            close(f);
        end

        function testVerticalBars(testCase)
            % Test the verticalDashedBar and verticalSolidBar types.
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "verticalDashedBar", 'T0', 3, 'LineWidth', 2);
            commands(2) = vlt.plot.timelineRow('Row', 2, 'Type', "verticalSolidBar", 'T0', 5, 'Color', [1 0 0]);
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'timeStartVerticalBar', false);
            ax = gca;

            dashedBar = findobj(ax, 'Type', 'Line', 'LineStyle', '--');
            testCase.verifyNotEmpty(dashedBar, 'Dashed bar should be created.');
            testCase.verifyEqual(dashedBar.XData, [3 3], 'AbsTol', 1e-6, 'Dashed bar XData is incorrect.');
            testCase.verifyEqual(dashedBar.LineWidth, 2, 'AbsTol', 1e-6, 'Dashed bar LineWidth is incorrect.');

            solidBar = findobj(ax, 'Type', 'Line', 'LineStyle', '-');
            testCase.verifyNotEmpty(solidBar, 'Solid bar should be created.');
            testCase.verifyEqual(solidBar.XData, [5 5], 'AbsTol', 1e-6, 'Solid bar XData is incorrect.');
            testCase.verifyEqual(solidBar.Color, [1 0 0], 'AbsTol', 1e-6, 'Solid bar Color is incorrect.');
            testCase.verifyEqual(solidBar.LineWidth, 0.76, 'AbsTol', 1e-6, 'Solid bar LineWidth should be the default.');
            close(f);
        end

        function testMarkerLabelsAndColors(testCase)
            % Test that labels for markers are drawn correctly and colors are applied.
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "Marker", 'T0', 5, 'String', "Top Label", 'VerticalAlignment', 'top', 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [0 1 0]);
            commands(2) = vlt.plot.timelineRow('Row', 2, 'Type', "Marker", 'T0', 5, 'String', "Bottom Label", 'VerticalAlignment', 'bottom');
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'timeStartVerticalBar', false);
            ax = gca;

            topLabel = findobj(ax, 'Type', 'Text', 'String', 'Top Label');
            testCase.verifyNotEmpty(topLabel, 'Top label should be created.');
            testCase.verifyEqual(topLabel.VerticalAlignment, 'bottom', 'Top label VA is incorrect.');

            bottomLabel = findobj(ax, 'Type', 'Text', 'String', 'Bottom Label');
            testCase.verifyNotEmpty(bottomLabel, 'Bottom label should be created.');
            testCase.verifyEqual(bottomLabel.VerticalAlignment, 'top', 'Bottom label VA is incorrect.');

            % Verify marker colors
            markerObjs = findobj(ax, 'Type', 'Line');
            % findobj returns in reverse order of creation
            testCase.verifyEqual(markerObjs(2).MarkerFaceColor, [1 0 0], 'Custom marker face color is incorrect.');
            testCase.verifyEqual(markerObjs(2).MarkerEdgeColor, [0 1 0], 'Custom marker edge color is incorrect.');
            testCase.verifyEqual(markerObjs(1).MarkerFaceColor, [1 1 1], 'Default marker face color is incorrect.');
            testCase.verifyEqual(markerObjs(1).MarkerEdgeColor, [0 0 0], 'Default marker edge color is incorrect.');

            close(f);
        end

        function testTimelineFromJSON(testCase)
            % Test the creation of a timeline from a JSON string.
            f = figure('Visible','off');
            ax_handle = axes(f);
            jsonStr = ['{', ...
                '"timelineParameters": [', ...
                '  {"Name": "timelineBackgroundColor", "Value": [0.8, 1, 0.8]},', ...
                '  {"Name": "axes", "Value": ', num2str(ax_handle.Number), '}', ...
                '],', ...
                '"timelineRows": [', ...
                '  {"Row": 1, "Type": "Bar", "T0": 2, "T1": 8}', ...
                ']', ...
            '}'];
            vlt.plot.timelineFromJSON(jsonStr);

            testCase.verifyEqual(ax_handle.Color, [0.8 1 0.8], 'AbsTol', 1e-6, 'Background color from JSON is incorrect.');
            testCase.verifyNotEmpty(findobj(ax_handle, 'Type', 'Rectangle'), 'Bar should be plotted in the specified axes.');
            close(f);
        end

    end
end