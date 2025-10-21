classdef testTimeline < matlab.unittest.TestCase
    % testTimeline - Unit tests for the vlt.plot.timeline and related functions.
    %

    properties
        Figures
    end

    methods (TestClassSetup)
        function initializeFigureList(testCase)
            testCase.Figures = [];
        end
    end

    methods (TestClassTeardown)
        function closeFigures(testCase)
            for i = 1:numel(testCase.Figures)
                if ishandle(testCase.Figures(i))
                    close(testCase.Figures(i));
                end
            end
        end
    end

    methods (Test)

        function testTimelineSmokeTest(testCase)
            commands(1) = vlt.plot.timelineRow('Row',1,'Type',"RowLabel",'String',"My first row");
            commands(2) = vlt.plot.timelineRow('Row',1,'Type',"Bar",'T0',2,'T1',4);
            vlt.plot.timeline(commands);
            f = gcf;
            set(f, 'Visible', 'off');
            testCase.Figures(end+1) = f;
            testCase.verifyNotEmpty(findobj(groot, 'Type', 'figure'), 'A figure should be created.');
            ax = gca;
            testCase.verifyEmpty(ax.YTick, 'Y-ticks should be empty by default.');
        end

        function testPlotObjectProperties(testCase)
            rowHeight = 2;
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "Bar", 'T0', 2, 'T1', 5, 'BarHeight', 0.8);
            commands(2) = vlt.plot.timelineRow('Row', 2, 'Type', "OnsetTriangle", 'T0', 7, 'T1', 9, 'BarHeight', 0.6);
            vlt.plot.timeline(commands, 'rowHeight', rowHeight, 'timeStartVerticalBar', false);
            f = gcf;
            set(f, 'Visible', 'off');
            testCase.Figures(end+1) = f;
            ax = gca;
            barObj = findobj(ax, 'Type', 'Rectangle');
            triangleObj = findobj(ax, 'Type', 'Patch');

            expectedBarPosition = [2, 0.2, 3, 1.6];
            testCase.verifyEqual(barObj.Position, expectedBarPosition, 'AbsTol', 1e-6, 'Bar position is incorrect.');

            row_center_2 = (2-1)*rowHeight + rowHeight/2;
            y_top = row_center_2 - (0.6 * rowHeight / 2);
            y_bottom = row_center_2 + (0.6 * rowHeight / 2);
            expectedTriangleVertices = [7, y_bottom; 9, y_bottom; 9, y_top];
            testCase.verifyEqual(triangleObj.Vertices, expectedTriangleVertices, 'AbsTol', 1e-6, 'Triangle vertices are incorrect.');
        end

        function testEmptyTimeline(testCase)
            vlt.plot.timeline(vlt.plot.timelineRow.empty(1,0));
            f = gcf;
            set(f, 'Visible', 'off');
            testCase.Figures(end+1) = f;
            testCase.verifyNotEmpty(findobj(groot, 'Type', 'figure'), 'Figure should be created for empty timeline.');
        end

        function testVerticalBars(testCase)
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "verticalDashedBar", 'T0', 3);
            vlt.plot.timeline(commands, 'timeStartVerticalBar', false);
            f = gcf;
            set(f, 'Visible', 'off');
            testCase.Figures(end+1) = f;
            ax = gca;
            dashedBar = findobj(ax, 'Type', 'Line', 'LineStyle', '--');
            testCase.verifyNotEmpty(dashedBar, 'Dashed bar should be created.');
        end

        function testMarkerLabels(testCase)
            rowHeight = 3;
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "Marker", 'T0', 5, 'String', "Above", 'VerticalAlignment', 'above', 'Symbol', 'o');
            vlt.plot.timeline(commands, 'timeStartVerticalBar', false, 'rowHeight', rowHeight);
            f = gcf;
            set(f, 'Visible', 'off');
            testCase.Figures(end+1) = f;
            ax = gca;

            aboveLabel = findobj(ax, 'Type', 'Text', 'String', 'Above');
            markerObj = findobj(ax, 'Type', 'Line');

            h3_font_size = 10; % Default Heading3FontSize
            expected_offset = (h3_font_size / 72) * rowHeight;
            row_center = (1-1)*rowHeight + rowHeight/2;

            testCase.verifyEqual(aboveLabel.Position(2), row_center - expected_offset, 'AbsTol', 1e-6, 'Text "above" has incorrect offset.');
        end

        function testTextOnlyMarker(testCase)
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "Marker", 'T0', 5, 'String', "Text Only");
            vlt.plot.timeline(commands, 'timeStartVerticalBar', false);
            f = gcf;
            set(f, 'Visible', 'off');
            testCase.Figures(end+1) = f;
            ax = gca;

            textObj = findobj(ax, 'Type', 'Text', 'String', 'Text Only');
            testCase.verifyNotEmpty(textObj, 'Text for text-only marker should be created.');

            markerObj = findobj(ax, 'Type', 'Line');
            testCase.verifyEmpty(markerObj, 'No line object should be created for a text-only marker.');
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
            vlt.plot.timelineFromJSON(jsonStr);
            f = gcf;
            set(f, 'Visible', 'off');
            testCase.Figures(end+1) = f;
            ax = gca;
            testCase.verifyEqual(ax.Color, [0.8 1 0.8], 'AbsTol', 1e-6, 'Background color from JSON is incorrect.');
        end

        function testTimelineFromJSON_CellArray(testCase)
            jsonStr = ['{', ...
                '"timelineRows": [', ...
                '  {"Row": 1, "Type": "Bar", "T0": 2, "T1": 8, "BarHeight": 0.5},', ...
                '  {"Row": 2, "Type": "Marker", "T0": 5, "Symbol": "s" }', ...
                ']', ...
            '}'];
            testCase.verifyWarningFree(@() vlt.plot.timelineFromJSON(jsonStr));
            f = gcf;
            set(f, 'Visible', 'off');
            testCase.Figures(end+1) = f;
            ax = gca;
            testCase.verifyNotEmpty(findobj(ax, 'Type', 'Rectangle'), 'Bar should be created from cell array JSON.');
            testCase.verifyNotEmpty(findobj(ax, 'Type', 'Line', 'Marker', 's'), 'Marker should be created from cell array JSON.');
        end

        function testHeadingWithMarker(testCase)
            rowHeight = 4;
            fontSize = 12; % default Heading2 size
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "Heading2", 'T0', 10, 'String', "Event Above", 'Symbol', 's', 'VerticalAlignment', 'above');
            vlt.plot.timeline(commands, 'timeStartVerticalBar', false, 'rowHeight', rowHeight);
            f = gcf;
            set(f, 'Visible', 'off');
            testCase.Figures(end+1) = f;
            ax = gca;
            marker = findobj(ax, 'Type', 'Line', 'Marker', 's');
            textObj = findobj(ax, 'Type', 'Text', 'String', 'Event Above');

            expected_offset = (fontSize / 72) * rowHeight;
            row_center = (1-1)*rowHeight + rowHeight/2;

            testCase.verifyEqual(textObj.Position(2), row_center - expected_offset, 'AbsTol', 1e-6, 'Heading text "above" has incorrect offset.');
        end

        function testRowLabelFontAndAlignment(testCase)
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "RowLabel", 'String', "Left", 'HorizontalAlignment', 'left');
            commands(2) = vlt.plot.timelineRow('Row', 2, 'Type', "RowLabel", 'String', "Right", 'HorizontalAlignment', 'right');
            vlt.plot.timeline(commands, 'timePre', 0, 'timeStart', 2, 'timeEnd', 10);
            f = gcf;
            set(f, 'Visible', 'off');
            testCase.Figures(end+1) = f;
            ax = gca;

            leftLabel = findobj(ax, 'Type', 'Text', 'String', 'Left');
            testCase.verifyEqual(leftLabel.Position(1), 0, 'AbsTol', 1e-6, 'Left-aligned RowLabel has incorrect X position.');

            rightLabel = findobj(ax, 'Type', 'Text', 'String', 'Right');
            testCase.verifyEqual(rightLabel.Position(1), 2, 'AbsTol', 1e-6, 'Right-aligned RowLabel has incorrect X position.');

        end

        function testXAxisCustomization(testCase)
            commands(1) = vlt.plot.timelineRow('Row', 1, 'Type', "Bar", 'T0', 5, 'T1', 15);
            vlt.plot.timeline(commands, 'timePre', -10, 'timeStart', 0, 'XLabel', 'Time (s)');
            f = gcf;
            set(f, 'Visible', 'off');
            testCase.Figures(end+1) = f;
            ax = gca;

            testCase.verifyEqual(ax.XLabel.String, 'Time (s)', 'XLabel was not set correctly.');
            testCase.verifyGreaterThanOrEqual(min(ax.XTick), 0, 'XTicks before timeStart were not removed.');

        end

    end
end