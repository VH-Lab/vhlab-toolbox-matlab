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
%   'timelineRows'      : An array of objects (can be heterogeneous), where each
%                         object defines the properties for a single vlt.plot.timelineRow.
%
% Example:
%   jsonStr = ['{', ...
%       '"timelineParameters": [', ...
%       '  {"Name": "timeStart", "Value": 20}, {"Name": "timeEnd", "Value": 65}, {"Name": "timePre", "Value": 0}, ', ...
%       '  {"Name": "Heading1FontSize", "Value": 16}, {"Name": "Heading2FontSize", "Value": 14}, ', ...
%       '  {"Name": "Heading3FontSize", "Value": 12}, {"Name": "XLabel", "Value": "Postnatal day"}', ...
%       '],', ...
%       '"timelineRows": [', ...
%       '  {"Row": 1, "Type": "Heading1", "T0": 32.5, "String":"Developmental milestones"},', ...
%       '  {"Row": 2, "Type": "OnsetTriangle", "T0": 25, "T1": 46, "Color": [0, 1, 0]},', ...
%       '  {"Row": 2, "Type": "Bar", "T0": 46, "T1": 65, "Color": [0, 1, 0]},', ...
%       '  {"Row": 2, "Type": "Heading3", "T0": 32, "Color": [0, 0, 0], "String": "Orientation selectivity", "HorizontalAlignment": "left"},', ...
%       '  {"Row": 3, "Type": "OnsetTriangle", "T0": 32, "T1": 46, "Color": [0, 0, 1]},', ...
%       '  {"Row": 3, "Type": "Bar", "T0": 46, "T1": 65, "Color": [0, 0, 1]},', ...
%       '  {"Row": 3, "Type": "Heading3", "T0": 32, "Color": [0, 0, 0], "String": "Direction selectivity", "HorizontalAlignment": "left"},', ...
%       '  {"Row": 4, "Type": "Bar", "T0": 32, "T1": 46, "Color": [0, 0, 1]},', ...
%       '  {"Row": 4, "Type": "Heading3", "T0": 32, "Color": [0, 0, 0], "String": "Critical period direction", "HorizontalAlignment": "left"},', ...
%       '  {"Row": 6, "Type": "verticalDashedBar", "T0": 32}', ...
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
params = {};
if isfield(data, 'timelineParameters')
    for i = 1:numel(data.timelineParameters)
        params{end+1} = data.timelineParameters(i).Name;
        params{end+1} = data.timelineParameters(i).Value;
    end
end

% --- Process timelineRows ---
if isfield(data, 'timelineRows') && ~isempty(data.timelineRows)
    rowsData = data.timelineRows;
    isCell = iscell(rowsData);
    numRows = numel(rowsData);
    command_rows = vlt.plot.timelineRow.empty(1, 0);

    for i = 1:numRows
        if isCell
            rowStruct = rowsData{i};
        else
            rowStruct = rowsData(i);
        end

        rowFields = fieldnames(rowStruct);
        rowParams = {};
        for j = 1:numel(rowFields)
            rowParams{end+1} = rowFields{j};
            value = rowStruct.(rowFields{j});
            if iscell(value)
                rowParams{end+1} = cell2mat(value);
            else
                rowParams{end+1} = value;
            end
        end

        command_rows(end+1) = vlt.plot.timelineRow(rowParams{:});
    end
else
    command_rows = vlt.plot.timelineRow.empty(1,0);
end

% Call the main timeline function with the processed data
vlt.plot.timeline(command_rows, params{:});

end