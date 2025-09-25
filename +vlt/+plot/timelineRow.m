classdef timelineRow
    % vlt.plot.timelineRow - A class to represent a single row in a timeline plot.
    %
    % This class defines the properties for a single event in the timeline,
    % including validation for each property.
    %

    properties
        Row (1,1) {mustBeInteger, mustBePositive} = 1
        Type (1,1) string {mustBeMember(Type,["Heading1","Heading2","Heading3","Marker","Bar","OnsetTriangle","OffsetTriangle","RowLabel","verticalDashedBar","verticalSolidBar"])} = "Marker"
        String (1,1) string = ""
        Color (1,3) {mustBeNumeric, mustBeNonnegative, mustBeLessThanOrEqual(Color, 1)} = [0 0 0]
        Symbol (1,1) string = "o"
        BarHeight (1,1) {mustBeNumeric, mustBePositive, mustBeLessThanOrEqual(BarHeight, 1)} = 0.8
        T0 (1,1) {mustBeNumeric} = 0
        T1 (1,1) {mustBeNumeric} = 0
        HorizontalAlignment (1,1) string {mustBeMember(HorizontalAlignment,["left","center","right"])} = "center"
        VerticalAlignment (1,1) string {mustBeMember(VerticalAlignment,["top","cap","middle","baseline","bottom"])} = "middle"
        LineWidth (1,1) {mustBeNumeric, mustBePositive} = 0.76
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