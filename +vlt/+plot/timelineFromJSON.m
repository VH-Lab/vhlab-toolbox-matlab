function timelineFromJSON(jsonString)
% vlt.plot.timelineFromJSON - Creates a timeline plot from a JSON string.
%
% vlt.plot.timelineFromJSON(JSONSTRING)
%
% Creates a timeline plot based on a configuration provided in a JSON string.
% The JSON string should define an object with two fields:
%
%   'timelineParameters': An array of objects, where each object has a 'Name'
%                         and 'Value' field. These correspond to the optional
%                         name-value arguments for vlt.plot.timeline.
%
%   'timelineRows'      : An array of objects, where each object defines the
%                         properties for a single vlt.plot.timelineRow.
%
% Example:
%   jsonStr = ['{', ...
%       '"timelineParameters": [', ...
%       '  {"Name": "timePre", "Value": -2},', ...
%       '  {"Name": "timeStart", "Value": 0},', ...
%       '  {"Name": "timeEnd", "Value": 10},', ...
%       '  {"Name": "timelineBackgroundColor", "Value": [0.8, 0.8, 1]}', ...
%       '],', ...
%       '"timelineRows": [', ...
%       '  {"Row": 1, "Type": "RowLabel", "String": "My JSON Row"},', ...
%       '  {"Row": 1, "Type": "Bar", "T0": 2, "T1": 8, "Color": [1,0,0]}', ...
%       ']', ...
%   '}'];
%   vlt.plot.timelineFromJSON(jsonStr);
%

arguments
    jsonString (1,:) char
end

% Decode the JSON string into a MATLAB struct
data = jsondecode(jsonString);

% --- Process timelineParameters ---
% Convert the array of structs into a cell array of name-value pairs
params = {};
if isfield(data, 'timelineParameters')
    for i = 1:numel(data.timelineParameters)
        params{end+1} = data.timelineParameters(i).Name;
        params{end+1} = data.timelineParameters(i).Value;
    end
end

% --- Process timelineRows ---
% Convert the array of structs into an array of vlt.plot.timelineRow objects
if isfield(data, 'timelineRows') && ~isempty(data.timelineRows)
    % Initialize an empty timelineRow object array
    command_rows(1, numel(data.timelineRows)) = vlt.plot.timelineRow();

    for i = 1:numel(data.timelineRows)
        rowStruct = data.timelineRows(i);
        rowFields = fieldnames(rowStruct);

        % Create a cell array of name-value pairs for the constructor
        rowParams = {};
        for j = 1:numel(rowFields)
            rowParams{end+1} = rowFields{j};
            rowParams{end+1} = rowStruct.(rowFields{j});
        end

        % Create the timelineRow object
        command_rows(i) = vlt.plot.timelineRow(rowParams{:});
    end
else
    error('JSON string must contain a non-empty "timelineRows" field.');
end

% Call the main timeline function with the processed data
vlt.plot.timeline(command_rows, params{:});

end