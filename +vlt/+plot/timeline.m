function timeline(command_rows, options)
% vlt.plot.timeline - Create a timeline plot with specified events
%
% vlt.plot.timeline(COMMAND_ROWS, ...)
%
% Creates a timeline plot. The user specifies the contents with an array of
% vlt.plot.timelineRow objects.
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
    options.axes = []
end

% Set up axes
if isempty(options.axes)
    figure;
    ax = gca;
else
    ax = options.axes;
end
set(ax, 'Color', options.timelineBackgroundColor);
hold(ax, 'on');

% Get the number of rows and set up Y axis
if ~isempty(command_rows)
    unique_rows = unique([command_rows.Row]);
    row_centers = (unique_rows - 1) * options.rowHeight + options.rowHeight/2;

    min_y = min(row_centers) - options.rowHeight/2;
    max_y = max(row_centers) + options.rowHeight/2;

    ylim(ax, [min_y max_y]);
    set(ax, 'YTick', row_centers);
    set(ax, 'YTickLabel', arrayfun(@num2str, unique_rows, 'UniformOutput', false));
    set(ax, 'TickLength', [0 0]);
    ax.YDir = 'reverse';
end

% Auto-calculate time boundaries if not provided
all_times = [];
if ~isempty(command_rows)
    is_event = ~strcmp({command_rows.Type},"RowLabel");
    if any(is_event)
        all_times = [ [command_rows(is_event).T0] [command_rows(is_event).T1] ];
    end
end

if isempty(all_times)
    all_times = [0 1]; % default if no events
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

if options.timeEnd <= options.timePre
    options.timeEnd = options.timePre + 1; % Ensure there is a valid interval
end

xlim(ax, [options.timePre options.timeEnd]);

% Draw vertical start bar
if options.timeStartVerticalBar
    plot(ax, [options.timeStart options.timeStart], ylim(ax), '-', ...
        'Color', options.timeStartVerticalBarColor, ...
        'LineWidth', options.timeStartVerticalBarLineWidth);
end

% Loop through commands and plot
for i = 1:length(command_rows)
    cmd = command_rows(i);
    row_center = (cmd.Row - 1) * options.rowHeight + options.rowHeight/2;

    switch cmd.Type
        case "RowLabel"
            if strcmp(cmd.HorizontalAlignment, 'left')
                label_pos = options.timePre;
            elseif strcmp(cmd.HorizontalAlignment, 'right')
                label_pos = options.timeStart;
            else % center
                label_pos = options.timePre + (options.timeStart - options.timePre) / 2;
            end
            text(ax, label_pos, row_center, cmd.String, 'FontSize', options.Heading1FontSize, ...
                'HorizontalAlignment', cmd.HorizontalAlignment, 'VerticalAlignment', cmd.VerticalAlignment, 'Color', cmd.Color);

        case {"Heading1", "Heading2", "Heading3"}
            fontSize = options.([char(cmd.Type) 'FontSize']);
            y_pos = row_center;
            text_va = cmd.VerticalAlignment;

            if ~isempty(cmd.Symbol) && strlength(cmd.Symbol) > 0
                plot(ax, cmd.T0, row_center, cmd.Symbol, 'MarkerEdgeColor', cmd.MarkerEdgeColor, 'MarkerFaceColor', cmd.MarkerFaceColor, 'MarkerSize', cmd.MarkerSize);

                if ismember(cmd.VerticalAlignment, ["above", "below"])
                    font_height_in_data_units = fontSize / 72 * options.rowHeight;
                    y_offset = 0.5 * font_height_in_data_units;
                    if strcmp(cmd.VerticalAlignment, 'above')
                        y_pos = row_center - y_offset;
                    else % 'below'
                        y_pos = row_center + y_offset;
                    end
                    text_va = 'middle';
                end
            end
            text(ax, cmd.T0, y_pos, cmd.String, 'FontSize', fontSize, ...
                'HorizontalAlignment', cmd.HorizontalAlignment, 'VerticalAlignment', text_va, 'Color', cmd.Color);

        case "Marker"
            plot(ax, cmd.T0, row_center, cmd.Symbol, 'MarkerEdgeColor', cmd.MarkerEdgeColor, 'MarkerFaceColor', cmd.MarkerFaceColor, 'MarkerSize', cmd.MarkerSize);
            if ~isempty(cmd.String) && strlength(cmd.String) > 0
                y_pos = row_center;
                text_va = cmd.VerticalAlignment;
                if ismember(cmd.VerticalAlignment, ["above", "below"])
                    font_size_in_points = get(ax,'FontSize');
                    font_height_in_data_units = font_size_in_points / 72 * options.rowHeight;
                    y_offset = 0.5 * font_height_in_data_units;
                    if strcmp(cmd.VerticalAlignment, 'above')
                        y_pos = row_center - y_offset;
                    else % 'below'
                        y_pos = row_center + y_offset;
                    end
                    text_va = 'middle';
                end
                text(ax, cmd.T0, y_pos, cmd.String, ...
                    'HorizontalAlignment', cmd.HorizontalAlignment, ...
                    'VerticalAlignment', text_va, 'Color', cmd.Color);
            end

        case "Bar"
            y_start = row_center - cmd.BarHeight * options.rowHeight / 2;
            h = cmd.BarHeight * options.rowHeight;
            rectangle(ax, 'Position', [cmd.T0, y_start, cmd.T1 - cmd.T0, h], ...
                      'FaceColor', cmd.Color, 'EdgeColor', 'none');
        case "OnsetTriangle"
            y_top = row_center - cmd.BarHeight * options.rowHeight / 2;
            y_bottom = row_center + cmd.BarHeight * options.rowHeight / 2;
            patch(ax, [cmd.T0 cmd.T1 cmd.T1], [y_bottom, y_bottom, y_top], cmd.Color, 'EdgeColor', 'none');
        case "OffsetTriangle"
            y_top = row_center - cmd.BarHeight * options.rowHeight / 2;
            y_bottom = row_center + cmd.BarHeight * options.rowHeight / 2;
            patch(ax, [cmd.T0 cmd.T0 cmd.T1], [y_top, y_bottom, y_bottom], cmd.Color, 'EdgeColor', 'none');
        case "verticalDashedBar"
            y_top = row_center - 0.5 * options.rowHeight;
            y_bottom = row_center + 0.5 * options.rowHeight;
            plot(ax, [cmd.T0 cmd.T0], [y_top y_bottom], '--', 'Color', cmd.Color, 'LineWidth', cmd.LineWidth);
        case "verticalSolidBar"
            y_top = row_center - 0.5 * options.rowHeight;
            y_bottom = row_center + 0.5 * options.rowHeight;
            plot(ax, [cmd.T0 cmd.T0], [y_top y_bottom], '-', 'Color', cmd.Color, 'LineWidth', cmd.LineWidth);
    end
end

end