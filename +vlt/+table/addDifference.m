function dataTable = addDifference(dataTable, dataColumn, factorColumn, targetGroup, difference)
% VLT.TABLE.ADDDIFFERENCE - Adds a specified difference to a subset of a table.
%
%   MODIFIED_TABLE = VLT.TABLE.ADDDIFFERENCE(DATATABLE, DATACOLUMN, FACTORCOLUMN, TARGETGROUP, DIFFERENCE)
%
%   Takes a MATLAB table (DATATABLE) and adds a numeric value (DIFFERENCE) to
%   the column specified by DATACOLUMN. The modification is only applied to
%   rows that match the criteria defined in TARGETGROUP.
%
%   This function provides a robust, centralized way to inject an effect size
%   into a dataset, which is a core operation for statistical power simulations.
%
%   Arguments:
%     dataTable (table): The input MATLAB table.
%
%     dataColumn (string): The name of the column containing the numeric data
%       to which the difference will be added.
%
%     factorColumn (string): The name of the primary factor column to search
%       when `targetGroup` is a simple value (e.g., a string).
%
%     targetGroup (struct or string/char/categorical): Defines the target rows.
%       - For simple designs (one factor), this can be a string, char, or
%         categorical value that exists in the `factorColumn`.
%       - For multi-factor designs, this must be a scalar struct where field
%         names correspond to factor column names in the table and values
%         correspond to the specific levels of those factors that define the
%         target group.
%
%     difference (numeric scalar): The numeric value to add to the data in the
%       target rows.
%
%   Returns:
%     dataTable (table): The modified table with the difference applied to the
%       specified subset. The original table is not modified; a copy is returned.
%
%   Example:
%     % Create a sample table
%     T = table( ...
%         categorical({'A';'A';'B';'B'}), ...
%         categorical({'X';'Y';'X';'Y'}), ...
%         [10; 12; 20; 22], ...
%         'VariableNames', {'Condition', 'Group', 'Measurement'});
%
%     % Add 5 to all rows where 'Condition' is 'B'
%     T_mod1 = vlt.table.addDifference(T, 'Measurement', 'Condition', 'B', 5);
%
%     % Define a multi-factor target group
%     target = struct('Condition', 'B', 'Group', 'Y');
%
%     % Add 100 to the 'Measurement' of the target group
%     T_mod2 = vlt.table.addDifference(T, 'Measurement', 'Condition', target, 100);
%
%   See also: VLT.STATS.POWER.FIND_GROUP_INDICES, VLT.STATS.POWER.RUN_LME_POWER_ANALYSIS
%

    arguments
        dataTable table
        dataColumn {mustBeTextScalar, mustBeAValidTableVariable(dataTable, dataColumn)}
        factorColumn {mustBeTextScalar, mustBeAValidTableVariable(dataTable, factorColumn)}
        targetGroup
        difference (1,1) double
    end

    % Find the indices of the rows that match the target group criteria
    targetIndices = vlt.stats.power.find_group_indices(dataTable, targetGroup, factorColumn);

    % Add the difference to the specified rows in the data column
    dataTable.(dataColumn)(targetIndices) = dataTable.(dataColumn)(targetIndices) + difference;

end

function mustBeAValidTableVariable(tbl, varName)
    % Custom validator to check if a variable name exists in a table
    if ~any(strcmp(tbl.Properties.VariableNames, varName))
        eid = 'vlt:validators:mustBeAValidTableVariable:notFound';
        msg = ['The variable name ''' char(varName) ''' was not found in the table.'];
        throwAsCaller(MException(eid,msg));
    end
end
