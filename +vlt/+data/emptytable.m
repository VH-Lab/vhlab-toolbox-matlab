function t = emptytable(name,dataType)
% EMPTYTABLE - make an empty table
%
% T = EMPTYTABLE("variable1Name","variable1DataType",...
%    "variable2Name","variable2DataType", ...)
%
% Create an empty table with the variable names (column names) provided.
%
% Example:
%   t = vlt.data.emptytable("id","string","x","double","y","double");
%  

arguments (Repeating)
    name (1,1) string
    dataType (1,1) string
end

t = table('Size',[0 numel(name)],'VariableNames',[name{:}],'VariableTypes',[dataType{:}]);
