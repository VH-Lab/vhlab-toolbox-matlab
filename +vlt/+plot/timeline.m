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
%   'timePre'           : The time to start the x-axis for labels. Default is calculated from data.
%   'timeStart'         : The time for the "start" of events. Default is calculated from data.
%   'timeEnd'           : The time to end the x-axis. Default is calculated from data.
%   'timeStartVerticalBar': Draw a vertical bar at timeStart. Default is true.
%   'timeStartVerticalBarLineWidth': Line width of the start bar. Default is 1.
%   'timeStartVerticalBarColor': Color of the start bar. Default is black.
%
% Example:
%   commands(1) = vlt.plot.timelineRow('Row',1,'Type',"RowLabel",'String',"My first row");
%   commands(2) = vlt.plot.timelineRow('Row',1,'Type',"Bar",'T0',2,'T1',4);
%   figure;
%   vlt.plot.timeline(commands, 'timePre', 0, 'timeStart', 0, 'timeEnd', 10);
%

arguments
    command_rows (1,:) vlt.plot.timelineRow
    options.rowHeight (1,1) double = 1
    options.Heading1FontSize (1,1) double = 14
    options.Heading2FontSize (1,1) double = 12
    options.Heading3FontSize (1,1) double = 10
    options.timePre (1,1) double = NaN
    options.timeStart (1,1) double = NaN
    options.timeEnd (1,1) double = NaN
    options.timeStartVerticalBar (1,1) logical = true
    options.timeStartVerticalBarLineWidth (1,1) double = 1
    options.timeStartVerticalBarColor (1,3) double = [0 0 0]
    options.timelineBackgroundColor (1,3) double = [0.9 0.9 0.9]
end

% Auto-calculate time boundaries if not provided
all_times = [];
for i=1:length(command_rows)
    if ~strcmp(command_rows(i).Type,"RowLabel")
        all_times(end+1) = command_rows(i).T0;
        all_times(end+1) = command_rows(i).T1;
    end
end

if isnan(options.timePre)
    options.timePre = min(all_times);
end
if isnan(options.timeStart)
    options.timeStart = min(all_times);
end
if isnan(options.timeEnd)
    options.timeEnd = max(all_times);
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
set(ax, 'Color', options.timelineBackgroundColor);
hold(ax, 'on');
ylim([0.5 max_row * options.rowHeight + 0.5]);
set(ax, 'YTick', (options.rowHeight/2):options.rowHeight:((max_row-1)*options.rowHeight + options.rowHeight/2) );
set(ax, 'YTickLabel', 1:max_row);
ax.YDir = 'reverse';
xlim([options.timePre options.timeEnd]);

% Draw vertical start bar
if options.timeStartVerticalBar
    plot([options.timeStart options.timeStart], ylim, '-', ...
        'Color', options.timeStartVerticalBarColor, ...
        'LineWidth', options.timeStartVerticalBarLineWidth);
end

% Loop through commands and plot
for i = 1:length(command_rows)
    cmd = command_rows(i);
    row_center = (cmd.Row - 1) * options.rowHeight + options.rowHeight/2;

    switch cmd.Type
        case "RowLabel"
            label_pos = options.timePre + (options.timeStart - options.timePre) / 2;
            text(label_pos, row_center, cmd.String, 'FontSize', options.Heading3FontSize, ...
                'HorizontalAlignment', 'center', 'VerticalAlignment', cmd.VerticalAlignment, 'Color', cmd.Color);
        case {"Heading1", "Heading2", "Heading3"}
            fontSize = options.([char(cmd.Type) 'FontSize']);
            text(cmd.T0, row_center, cmd.String, 'FontSize', fontSize, ...
                'HorizontalAlignment', cmd.HorizontalAlignment, 'VerticalAlignment', cmd.VerticalAlignment, 'Color', cmd.Color);
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
        case "verticalDashedBar"
            y_top = row_center - 0.5 * options.rowHeight;
            y_bottom = row_center + 0.5 * options.rowHeight;
            plot([cmd.T0 cmd.T0], [y_top y_bottom], '--', 'Color', cmd.Color, 'LineWidth', cmd.LineWidth);
        case "verticalSolidBar"
            y_top = row_center - 0.5 * options.rowHeight;
            y_bottom = row_center + 0.5 * options.rowHeight;
            plot([cmd.T0 cmd.T0], [y_top y_bottom], '-', 'Color', cmd.Color, 'LineWidth', cmd.LineWidth);
    end
end

end