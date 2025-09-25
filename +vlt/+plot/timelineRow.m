classdef timelineRow
    % vlt.plot.timelineRow - A class to define a single event for a timeline plot.
    %
    %   This class is used to create event objects that are passed to the
    %   vlt.plot.timeline function. Each object defines a single graphical element
    %   to be plotted on the timeline.
    %
    %   Construction:
    %   OBJ = vlt.plot.timelineRow('NAME1', VALUE1, 'NAME2', VALUE2, ...)
    %
    %   See also: vlt.plot.timeline, vlt.plot.timelineFromJSON
    %
    %   Properties:
    %   Row (1,1) {mustBeNumeric, mustBePositive} = 1
    %       - The row number on which the event will be plotted. Can be non-integer.
    %   Type (1,1) string = "Marker"
    %       - The type of event to plot. Valid options are:
    %         "Heading1", "Heading2", "Heading3": Text elements.
    %         "Marker": A marker symbol, which can also have a text label.
    %         "Bar": A horizontal bar spanning from T0 to T1.
    %         "OnsetTriangle", "OffsetTriangle": Triangles indicating a ramp-up or ramp-down.
    %         "RowLabel": A label for the entire row, typically placed at the beginning.
    %         "verticalDashedBar", "verticalSolidBar": Vertical lines spanning the plot height.
    %   String (1,1) string = ""
    %       - The text string to display for 'Heading', 'Marker', or 'RowLabel' types.
    %   Color (1,3) = [0 0 0]
    %       - The color for the event (text color, bar fill color, etc.).
    %   Symbol (1,1) string = ""
    %       - The marker symbol to use (e.g., 'o', 's', 'x'). A marker is only plotted if
    %         this is not empty.
    %   BarHeight (1,1) = 0.8
    %       - For 'Bar' type, the height of the bar as a fraction of the rowHeight.
    %   T0 (1,1) {mustBeNumeric} = 0
    %       - The start time of the event. For instantaneous events, this is the time of the event.
    %   T1 (1,1) {mustBeNumeric} = 0
    %       - The end time of the event. For instantaneous events, this should be equal to T0.
    %   HorizontalAlignment (1,1) string = "center"
    %       - Horizontal alignment for text elements ('left', 'center', 'right').
    %   VerticalAlignment (1,1) string = "middle"
    %       - Vertical alignment for text. For markers with text, can also be 'above' or 'below'
    %         to position the text relative to the marker.
    %   LineWidth (1,1) = 0.76
    %       - Line width for vertical bars.
    %   MarkerFaceColor (1,3) = [1 1 1]
    %       - The fill color for markers.
    %   MarkerEdgeColor (1,3) = [0 0 0]
    %       - The edge color for markers.
    %   MarkerSize (1,1) = 6
    %       - The size of the marker.

    properties
        Row (1,1) {mustBeNumeric, mustBePositive} = 1
        Type (1,1) string {mustBeMember(Type,["Heading1","Heading2","Heading3","Marker","Bar","OnsetTriangle","OffsetTriangle","RowLabel","verticalDashedBar","verticalSolidBar"])} = "Marker"
        String (1,1) string = ""
        Color (1,3) {mustBeNumeric, mustBeNonnegative, mustBeLessThanOrEqual(Color, 1)} = [0 0 0]
        Symbol (1,1) string = ""
        BarHeight (1,1) {mustBeNumeric, mustBePositive, mustBeLessThanOrEqual(BarHeight, 1)} = 0.8
        T0 (1,1) {mustBeNumeric} = 0
        T1 (1,1) {mustBeNumeric} = 0
        HorizontalAlignment (1,1) string {mustBeMember(HorizontalAlignment,["left","center","right"])} = "center"
        VerticalAlignment (1,1) string {mustBeMember(VerticalAlignment,["top","cap","middle","baseline","bottom","above","below"])} = "middle"
        LineWidth (1,1) {mustBeNumeric, mustBePositive} = 0.76
        MarkerFaceColor (1,3) {mustBeNumeric, mustBeNonnegative, mustBeLessThanOrEqual(MarkerFaceColor, 1)} = [1 1 1]
        MarkerEdgeColor (1,3) {mustBeNumeric, mustBeNonnegative, mustBeLessThanOrEqual(MarkerEdgeColor, 1)} = [0 0 0]
        MarkerSize (1,1) {mustBeNumeric, mustBePositive} = 6
    end

    methods
        function obj = timelineRow(options)
            % TIMELINEROW - Constructor for the timelineRow class
            %
            arguments
                options.Row
                options.Type
                options.String
                options.Color
                options.Symbol
                options.BarHeight
                options.T0
                options.T1
                options.HorizontalAlignment
                options.VerticalAlignment
                options.LineWidth
                options.MarkerFaceColor
                options.MarkerEdgeColor
                options.MarkerSize
            end

            passedOptions = fieldnames(options);
            for i = 1:numel(passedOptions)
                propName = passedOptions{i};
                obj.(propName) = options.(propName);
            end

            if ismember(obj.Type, ["Marker", "Heading1", "Heading2", "Heading3", "verticalDashedBar", "verticalSolidBar"])
                t0_passed = ismember('T0', passedOptions);
                t1_passed = ismember('T1', passedOptions);
                if t0_passed && ~t1_passed
                    obj.T1 = obj.T0;
                elseif ~t0_passed && t1_passed
                    obj.T0 = obj.T1;
                elseif t0_passed && t1_passed && obj.T0 ~= obj.T1
                    warning('For Type %s, T0 and T1 should be the same. Setting T1 to T0.', obj.Type);
                    obj.T1 = obj.T0;
                end
            end
        end
    end
end