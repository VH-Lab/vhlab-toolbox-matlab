classdef timelineRow
    % vlt.plot.timelineRow - A class to represent a single row in a timeline plot.
    %
    % This class defines the properties for a single event in the timeline,
    % including validation for each property.
    %

    properties
        Row (1,1) {mustBeInteger, mustBePositive} = 1
        Type (1,1) string {mustBeMember(Type,["Heading1","Heading2","Heading3","Marker","Bar","OnsetTriangle","OffsetTriangle"])} = "Marker"
        String (1,1) string = ""
        Color (1,3) {mustBeNumeric, mustBeNonnegative, mustBeLessThanOrEqual(Color, 1)} = [0 0 0]
        Symbol (1,1) string = "o"
        BarHeight (1,1) {mustBeNumeric, mustBePositive, mustBeLessThanOrEqual(BarHeight, 1)} = 0.8
        T0 (1,1) {mustBeNumeric} = 0
        T1 (1,1) {mustBeNumeric} = 0
    end

    methods
        function obj = timelineRow(args)
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
            arguments (Repeating)
                args.?timelineRow
            end

            % If arguments were provided, assign them
            if ~isempty(args)
                for i = 1:numel(args)
                    s = args{i};
                    fn = fieldnames(s);
                    for j=1:numel(fn)
                        obj.(fn{j}) = s.(fn{j});
                    end
                end
            end

            % Post-construction validation
            if ismember(obj.Type, ["Marker", "Heading1", "Heading2", "Heading3"])
                if obj.T0 ~= obj.T1
                    warning('For Type %s, T0 and T1 are typically the same. T1 will be set to T0.', obj.Type);
                    obj.T1 = obj.T0;
                end
            end
        end
    end
end