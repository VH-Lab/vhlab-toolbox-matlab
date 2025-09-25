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
            close(f);
        end

        function testNonIntegerRows(testCase)
            commands(1) = vlt.plot.timelineRow('Row', 1.5, 'Type', "Bar", 'T0', 2, 'T1', 4);
            commands(2) = vlt.plot.timelineRow('Row', 3, 'Type', "Marker", 'T0', 6);
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'timeStartVerticalBar', false);
            ax = gca;
            expectedLabels = {'1.5'; '3'};
            testCase.verifyEqual(ax.YTickLabel, expectedLabels, 'Y-tick labels for non-integer rows are incorrect.');
            rowHeight = 1; % default
            expectedTicks = [(1.5-1)*rowHeight + rowHeight/2, (3-1)*rowHeight + rowHeight/2];
            testCase.verifyEqual(ax.YTick, expectedTicks, 'AbsTol', 1e-6, 'Y-tick positions for non-integer rows are incorrect.');
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
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "Marker", 'T0', 5, 'String', "Above", 'VerticalAlignment', 'above', 'MarkerSize', 12);
            commands(2) = vlt.plot.timelineRow('Row', 2, 'Type', "Marker", 'T0', 5, 'String', "Below", 'VerticalAlignment', 'below');
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'timeStartVerticalBar', false);
            ax = gca;

            aboveLabel = findobj(ax, 'Type', 'Text', 'String', 'Above');
            testCase.verifyEqual(aboveLabel.VerticalAlignment, 'middle', 'VA for "above" text should be middle.');

            belowLabel = findobj(ax, 'Type', 'Text', 'String', 'Below');
            testCase.verifyEqual(belowLabel.VerticalAlignment, 'middle', 'VA for "below" text should be middle.');

            markerObjs = findobj(ax, 'Type', 'Line');
            testCase.verifyGreaterThan(belowLabel.Position(2), markerObjs(1).YData, 'Text "below" should be at a higher Y value (plot is reversed).');
            testCase.verifyLessThan(aboveLabel.Position(2), markerObjs(2).YData, 'Text "above" should be at a lower Y value (plot is reversed).');
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
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "Heading2", 'T0', 10, 'String', "Event Above", 'Symbol', 's', 'VerticalAlignment', 'above');
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'timeStartVerticalBar', false);
            ax = gca;
            marker = findobj(ax, 'Type', 'Line', 'Marker', 's');
            testCase.verifyNotEmpty(marker, 'Marker for heading should be created.');
            textObj = findobj(ax, 'Type', 'Text', 'String', 'Event Above');
            testCase.verifyNotEmpty(textObj, 'Text for heading should be created.');
            testCase.verifyEqual(textObj.VerticalAlignment, 'middle', 'Text VA should be middle for relative positioning.');
            testCase.verifyLessThan(textObj.Position(2), marker.YData, 'Text should be above the marker.');
            close(f);
        end

        function testRowLabelFontAndAlignment(testCase)
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "RowLabel", 'String', "Big Left Label", 'HorizontalAlignment', 'left');
            f = figure('Visible','off');
            vlt.plot.timeline(commands, 'Heading1FontSize', 22);
            ax = gca;
            labelObj = findobj(ax, 'Type', 'Text', 'String', 'Big Left Label');
            testCase.verifyNotEmpty(labelObj, 'RowLabel object should be created.');
            testCase.verifyEqual(labelObj.FontSize, 22, 'RowLabel should use Heading1FontSize.');
            testCase.verifyEqual(labelObj.HorizontalAlignment, 'left', 'RowLabel should use its own alignment.');
            close(f);
        end

    end
end