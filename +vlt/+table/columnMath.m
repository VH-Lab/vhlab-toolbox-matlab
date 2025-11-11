function tbl_out = columnMath(tbl_in, columnName, newColumnName, op)
% VLT.TABLE.COLUMNMATH - Perform a mathematical operation on a table column.
%
%   TBL_OUT = VLT.TABLE.COLUMNMATH(TBL_IN, COLUMNNAME, NEWCOLUMNNAME, OP)
%
%   Takes a MATLAB table TBL_IN and performs a mathematical operation specified
%   by the string OP on the data in the column named COLUMNNAME. The results are
%   stored in a new column named NEWCOLUMNNAME in the output table TBL_OUT.
%
%   The operation string OP must be a valid MATLAB expression that operates on
%   a variable named 'X'. The function will substitute the data from
%   TBL_IN.(COLUMNNAME) for 'X' when evaluating the expression.
%
%   This function provides a robust and consistent way to perform column-wise
%   calculations, centralizing the logic and reducing errors.
%
%   Arguments:
%     tbl_in (table): The input table.
%     columnName (string): The name of the source column to use for the calculation.
%       This column must exist in TBL_IN.
%     newColumnName (string): The name of the new column to be created with the
%       results of the operation.
%     op (string): The mathematical operation to perform. This string must use
%       the variable 'X' to refer to the data from the source column.
%
%   Returns:
%     tbl_out (table): The output table, which is a copy of TBL_IN with the
%       additional NEWCOLUMNNAME.
%
%   Examples:
%      % Example 1: Squaring a column
%      T = table([1;2;3;4], 'VariableNames', {'MyData'});
%      op = 'X.^2';
%      T_new = vlt.table.columnMath(T, 'MyData', 'MyDataSquared', op);
%      % T_new will be a 2-column table with 'MyData' and 'MyDataSquared'
%      % The 'MyDataSquared' column will contain [1; 4; 9; 16].
%
%      % Example 2: Z-scoring a column
%      T = table(rand(5,1)*10, 'VariableNames', {'Values'});
%      op = '(X - mean(X)) / std(X)'; % z-score normalization
%      T_zscored = vlt.table.columnMath(T, 'Values', 'ZScoredValues', op);
%      % T_zscored will have a new column with the z-scored data.
%
%      % Example 3: Applying a log transform
%      T = table([10;100;1000], 'VariableNames', {'Measurements'});
%      op = 'log10(X)';
%      T_log = vlt.table.columnMath(T, 'Measurements', 'LogMeasurements', op);
%      % T_log will have a new column with values [1; 2; 3].
%
%   See also: VLT.STATS.LME_CATEGORY, VLT.STATS.LM_CATEGORY, TABLE
%

    arguments
        tbl_in table
        columnName {mustBeTextScalar, mustBeAValidTableVariable(tbl_in, columnName)}
        newColumnName {mustBeTextScalar}
        op {mustBeTextScalar}
    end

    % Make a copy to avoid modifying the original table in the caller's workspace
    tbl_out = tbl_in;

    % Extract the source column data
    X = tbl_out.(columnName);

    % Create an anonymous function from the operation string.
    % The string must use 'X' as the placeholder for the column data.
    % Using str2func is safer than a direct eval on the op string.
    try
        math_operation = str2func(['@(X)' char(op)]);

        % Apply the operation
        new_column_data = math_operation(X);

        % Add the new column to the output table
        tbl_out.(newColumnName) = new_column_data;

    catch ME
        % Provide a more informative error message if the op is invalid
        new_ME = MException('vlt:table:columnMath:invalidOp', ...
            ['The operation string ''' char(op) ''' could not be evaluated. ' ...
             'Ensure it is a valid MATLAB expression using ''X'' as the input variable. '...
             'Original error: ' ME.message]);
        throw(new_ME);
    end
end

function mustBeAValidTableVariable(tbl, varName)
    % Custom validator to check if a variable name exists in a table
    if ~any(strcmp(tbl.Properties.VariableNames, varName))
        eid = 'vlt:validators:mustBeAValidTableVariable:notFound';
        msg = ['The variable name ''' char(varName) ''' was not found in the table.'];
        throwAsCaller(MException(eid,msg));
    end
end
