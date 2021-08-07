function str = cell2str(theCell)
% CELL2STR - Convert 1-D cells to a string
%
%   STR = vlt.data.cell2str(THECELL)
%
% Converts a 1-D cell to a string representation that
% can be evaluated to reproduce the cell array.
% At present, this function works with 1-dimensional cells only,
% and only chars and matrixes
%
% Example: 
%   A = {'test','test2','test3'};
%   str = vlt.data.cell2str(A)
%    % str = '{ 'test','test2','test3'}'
%   B = eval(str);
%   vlt.data.eqlen(A,B), % should return 1
% 

if isempty(theCell), str = '{}'; return; end;

str = '{ ';
for i=1:length(theCell),
        if ischar(theCell{i})
                str = [str '''' theCell{i} ''', '];
        elseif isnumeric(theCell{i}),
                str = [str mat2str(theCell{i}) ', '];
        end;
end;
str = [str(1:end-2) ' }'];

