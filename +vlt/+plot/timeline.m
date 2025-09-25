function timeline(command_rows, options)
% vlt.plot.timeline - Create a timeline plot with specified events
%
% vlt.plot.timeline(COMMAND_ROWS, ...)
%
% Creates a timeline plot. The user specifies the contents with an array of
% vlt.plot.timelineRow objects.
%
% This function also accepts the following optional arguments as name/value pairs:
%   'rowHeight'         : The height of each row in the plot. Default is 1.
%   'Heading1FontSize'  : Font size for 'Heading1' text. Default is 14.
%   'Heading2FontSize'  : Font size for 'Heading2' text. Default is 12.
%   'Heading3FontSize'  : Font size for 'Heading3' text. Default is 10.
%
% Example:
%   % Create an array of timelineRow objects
%   commands(1) = vlt.plot.timelineRow(...
%       'Row', 1, 'Type', "Heading1", 'String', "Experiment Timeline", 'T0', 5, 'T1', 5);
%   commands(2) = vlt.plot.timelineRow(...
%       'Row', 2, 'Type', "Bar", 'T0', 2, 'T1', 6, 'Color', [0.5 0.5 1], 'BarHeight', 0.8);
%   commands(3) = vlt.plot.timelineRow(...
%       'Row', 2, 'Type', "Marker", 'T0', 4, 'T1', 4, 'Symbol', "o", 'Color', [1 0 0]);
%   commands(4) = vlt.plot.timelineRow(...
%       'Row', 3, 'Type', "Bar", 'T0', 6, 'T1', 10, 'Color', [0.5 1 0.5], 'BarHeight', 0.6);
%   commands(5) = vlt.plot.timelineRow(...
%       'Row', 3, 'Type', "Marker", 'T0', 8, 'T1', 8, 'Symbol', "s", 'Color', [0 0 1]);
%   commands(6) = vlt.plot.timelineRow(...
%       'Row', 4, 'Type', "OnsetTriangle", 'T0', 1, 'T1', 3, 'Color', [1 0.5 0.5]);
%   commands(7) = vlt.plot.timelineRow(...
%       'Row', 4, 'Type', "OffsetTriangle", 'T0', 9, 'T1', 10, 'Color', [0.5 0.5 1]);
%
%   figure;
%   vlt.plot.timeline(commands, 'rowHeight', 1.5, 'Heading1FontSize', 16);
%

arguments
    command_rows (1,:) vlt.plot.timelineRow
    options.rowHeight (1,1) double = 1
    options.Heading1FontSize (1,1) double = 14
    options.Heading2FontSize (1,1) double = 12
    options.Heading3FontSize (1,1) double = 10
end

% Get the number of rows from the command objects
max_row = 0;
for i = 1:length(command_rows)
    if command_rows(i).Row > max_row
        max_row = command_rows(i).Row;
    end
end

% Set up the plot
figure;
ax = gca;
hold(ax, 'on');
ylim([0.5 max_row * options.rowHeight + 0.5]);
set(ax, 'YTick', (options.rowHeight/2):options.rowHeight:((max_row-1)*options.rowHeight + options.rowHeight/2) );
set(ax, 'YTickLabel', 1:max_row);
ax.YDir = 'reverse';

% Loop through commands and plot
for i = 1:length(command_rows)
    cmd = command_rows(i);
    row_center = (cmd.Row - 1) * options.rowHeight + options.rowHeight/2;

    switch cmd.Type
        case {"Heading1", "Heading2", "Heading3"}
            fontSize = options.([char(cmd.Type) 'FontSize']);
            text(cmd.T0, row_center, cmd.String, 'FontSize', fontSize, ...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', cmd.Color);
        case "Marker"
            plot(cmd.T0, row_center, cmd.Symbol, 'Color', cmd.Color, 'MarkerFaceColor', cmd.Color);
        case "Bar"
            y_start = row_center - cmd.BarHeight * options.rowHeight / 2;
            h = cmd.BarHeight * options.rowHeight;
            rectangle('Position', [cmd.T0, y_start, cmd.T1 - cmd.T0, h], ...
                      'FaceColor', cmd.Color, 'EdgeColor', 'none');
        case "OnsetTriangle"
            y_top = row_center - cmd.BarHeight * options.rowHeight / 2;
            y_bottom = row_center + cmd.BarHeight * options.rowHeight / 2;
            patch([cmd.T0 cmd.T1 cmd.T1], [y_bottom, y_bottom, y_top], cmd.Color, 'EdgeColor', 'none');
        case "OffsetTriangle"
            y_top = row_center - cmd.BarHeight * options.rowHeight / 2;
            y_bottom = row_center + cmd.BarHeight * options.rowHeight / 2;
            patch([cmd.T0 cmd.T0 cmd.T1], [y_top, y_bottom, y_bottom], cmd.Color, 'EdgeColor', 'none');
    end
end

end