function tbl_out = nonbsp(tbl_in)
% NONBSP - Removes non-breaking spaces from all string-based columns in a table.
%
%   TBL_OUT = vlt.table.nonbsp(TBL_IN)
%
%   Examines each column of the input table TBL_IN. For columns that are of type
%   string, cell array of characters, or character arrays, it replaces any
%   non-breaking spaces (char(160)) with a regular space (char(32)).
%
%   Other variable types (numeric, logical, etc.) are passed through unchanged.
%
%   Returns the modified table TBL_OUT.
%

    arguments
        tbl_in table
    end

    tbl_out = tbl_in;
    varNames = tbl_out.Properties.VariableNames;

    for i = 1:numel(varNames)
        varName = varNames{i};
        columnData = tbl_out.(varName);

        if isstring(columnData)
            % For string arrays, we can use vectorized replace
            tbl_out.(varName) = replace(columnData, char(160), ' ');
        elseif iscell(columnData)
            % For cell arrays, iterate through elements
            for j = 1:numel(columnData)
                if ischar(columnData{j}) || isstring(columnData{j})
                    columnData{j} = replace(columnData{j}, char(160), ' ');
                end
            end
            tbl_out.(varName) = columnData;
        elseif ischar(columnData)
            % For char arrays, use strrep
            tbl_out.(varName) = strrep(columnData, char(160), ' ');
        end
    end
end
