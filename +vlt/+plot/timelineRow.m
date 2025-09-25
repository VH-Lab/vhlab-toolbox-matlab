classdef timelineRow
    % vlt.plot.timelineRow - A class to represent a single row in a timeline plot.
    %
    % This class defines the properties for a single event in the timeline,
    % including validation for each property.
    %

    properties
        Row (1,1) {mustBeInteger, mustBePositive} = 1
        Type (1,1) string {mustBeMember(Type,["Heading1","Heading2","Heading3","Marker","Bar","OnsetTriangle","OffsetTriangle","RowLabel"])} = "Marker"
        String (1,1) string = ""
        Color (1,3) {mustBeNumeric, mustBeNonnegative, mustBeLessThanOrEqual(Color, 1)} = [0 0 0]
        Symbol (1,1) string = "o"
        BarHeight (1,1) {mustBeNumeric, mustBePositive, mustBeLessThanOrEqual(BarHeight, 1)} = 0.8
        T0 (1,1) {mustBeNumeric} = 0
        T1 (1,1) {mustBeNumeric} = 0
    end

    methods
        function obj = timelineRow(options)
            % TIMELINEROW - Constructor for the timelineRow class
            %
            %   OBJ = vlt.plot.timelineRow('NAME1', VALUE1, 'NAME2', VALUE2, ...)
            %
            %   Creates a timelineRow object, allowing properties to be set
            %   using name-value pairs. Tab completion is enabled for property names.
            %
            %   Example:
            %     row = vlt.plot.timelineRow('Row', 2, 'Type', "Bar", 'T0', 5, 'T1', 10);
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
            end

            % Get field names of options that were actually passed in
            passedOptions = fieldnames(options);

            % Assign passed options to object properties.
            % The validation defined in the properties block will be triggered here.
            for i = 1:numel(passedOptions)
                propName = passedOptions{i};
                obj.(propName) = options.(propName);
            end

            % Post-construction validation
            % Check if T0 or T1 was passed for relevant types
            if ismember(obj.Type, ["Marker", "Heading1", "Heading2", "Heading3"])
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