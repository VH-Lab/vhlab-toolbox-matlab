classdef testTimeline < matlab.unittest.TestCase
    % testTimeline - Unit tests for the vlt.plot.timeline and related functions.
    %

    methods (Test)

        function testTimelineSmokeTest(testCase)
            commands(1) = vlt.plot.timelineRow('Row',1,'Type',"RowLabel",'String',"My first row");
            commands(2) = vlt.plot.timelineRow('Row',1,'Type',"Bar",'T0',2,'T1',4);
            f = figure('Visible','off');
            vlt.plot.timeline(commands);
            testCase.verifyNotEmpty(findobj(groot, 'Type', 'figure'), 'A figure should be created.');
            ax = gca;
            testCase.verifyEmpty(ax.YTick, 'Y-ticks should be empty by default.');
            close(f);
        end

        function testPlotObjectProperties(testCase)
            rowHeight = 2;
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "Bar", 'T0', 2, 'T1', 5, 'BarHeight', 0.8);
            commands(2) = vlt.plot.timelineRow('Row', 2, 'Type', "OnsetTriangle", 'T0', 7, 'T1', 9, 'BarHeight', 0.6);
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'rowHeight', rowHeight, 'timeStartVerticalBar', false);
            ax = gca;
            barObj = findobj(ax, 'Type', 'Rectangle');
            triangleObj = findobj(ax, 'Type', 'Patch');
            expectedBarPosition = [2, 0.2, 3, 1.6];
            testCase.verifyEqual(barObj.Position, expectedBarPosition, 'AbsTol', 1e-6, 'Bar position is incorrect.');
            expectedTriangleVertices = [7, 3.4; 9, 3.4; 9, 2.2];
            testCase.verifyEqual(triangleObj.Vertices, expectedTriangleVertices, 'AbsTol', 1e-6, 'Triangle vertices are incorrect.');
            close(f);
        end

        function testEmptyTimeline(testCase)
            f = figure('Visible','off');
            vlt.plot.timeline(vlt.plot.timelineRow.empty(1,0));
            testCase.verifyNotEmpty(findobj(groot, 'Type', 'figure'), 'Figure should be created for empty timeline.');
            close(f);
        end

        function testVerticalBars(testCase)
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "verticalDashedBar", 'T0', 3, 'LineWidth', 2);
            commands(2) = vlt.plot.timelineRow('Row', 2, 'Type', "verticalSolidBar", 'T0', 5, 'Color', [1 0 0]);
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'timeStartVerticalBar', false);
            ax = gca;
            dashedBar = findobj(ax, 'Type', 'Line', 'LineStyle', '--');
            testCase.verifyNotEmpty(dashedBar, 'Dashed bar should be created.');
            solidBar = findobj(ax, 'Type', 'Line', 'LineStyle', '-');
            testCase.verifyNotEmpty(solidBar, 'Solid bar should be created.');
            close(f);
        end

        function testMarkerLabelsAndColors(testCase)
            rowHeight = 3;
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "Marker", 'T0', 5, 'String', "Above", 'VerticalAlignment', 'above');
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'timeStartVerticalBar', false, 'rowHeight', rowHeight);
            ax = gca;

            aboveLabel = findobj(ax, 'Type', 'Text', 'String', 'Above');
            markerObj = findobj(ax, 'Type', 'Line');

            font_size_in_points = get(ax,'FontSize');
            expected_offset = font_size_in_points / 72 * rowHeight;

            testCase.verifyEqual(aboveLabel.Position(2), markerObj.YData - expected_offset, 'AbsTol', 1e-6, 'Text "above" has incorrect offset.');
            close(f);
        end

        function testTimelineFromJSON(testCase)
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
            testCase.verifyEqual(ax.Color, [0.8 1 0.8], 'AbsTol', 1e-6, 'Background color from JSON is incorrect.');
            close(f);
        end

        function testTimelineFromJSON_CellArray(testCase)
            jsonStr = ['{', ...
                '"timelineRows": [', ...
                '  {"Row": 1, "Type": "Bar", "T0": 2, "T1": 8, "BarHeight": 0.5},', ...
                '  {"Row": 2, "Type": "Marker", "T0": 5, "Symbol": "s" }', ...
                ']', ...
            '}'];
            f = figure('Visible','off');
            testCase.verifyWarningFree(@() vlt.plot.timelineFromJSON(jsonStr));
            ax = gca;
            testCase.verifyNotEmpty(findobj(ax, 'Type', 'Rectangle'), 'Bar should be created from cell array JSON.');
            testCase.verifyNotEmpty(findobj(ax, 'Type', 'Line', 'Marker', 's'), 'Marker should be created from cell array JSON.');
            close(f);
        end

        function testHeadingWithMarker(testCase)
            rowHeight = 4;
            fontSize = 12; % default Heading2 size
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "Heading2", 'T0', 10, 'String', "Event Above", 'Symbol', 's', 'VerticalAlignment', 'above');
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'timeStartVerticalBar', false, 'rowHeight', rowHeight);
            ax = gca;
            marker = findobj(ax, 'Type', 'Line', 'Marker', 's');
            textObj = findobj(ax, 'Type', 'Text', 'String', 'Event Above');

            expected_offset = fontSize / 72 * rowHeight;
            testCase.verifyEqual(textObj.Position(2), marker.YData - expected_offset, 'AbsTol', 1e-6, 'Heading text "above" has incorrect offset.');
            close(f);
        end

        function testRowLabelFontAndAlignment(testCase)
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "RowLabel", 'String', "Left", 'HorizontalAlignment', 'left');
            commands(2) = vlt.plot.timelineRow('Row', 2, 'Type', "RowLabel", 'String', "Right", 'HorizontalAlignment', 'right');
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'timePre', 0, 'timeStart', 2, 'timeEnd', 10);
            ax = gca;

            leftLabel = findobj(ax, 'Type', 'Text', 'String', 'Left');
            testCase.verifyEqual(leftLabel.Position(1), 0, 'AbsTol', 1e-6, 'Left-aligned RowLabel has incorrect X position.');

            rightLabel = findobj(ax, 'Type', 'Text', 'String', 'Right');
            testCase.verifyEqual(rightLabel.Position(1), 2, 'AbsTol', 1e-6, 'Right-aligned RowLabel has incorrect X position.');

            close(f);
        end

    end
end