function dataTable = addDifference(dataTable, dataColumn, targetGroup, difference)
% VLT.TABLE.ADDDIFFERENCE - Adds a specified difference to a subset of a table.
%
%   MODIFIED_TABLE = VLT.TABLE.ADDDIFFERENCE(DATATABLE, DATACOLUMN, TARGETGROUP, DIFFERENCE)
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
%     targetGroup (struct or string/char/categorical): Defines the target rows.
%       - For simple designs (one factor), this can be a string, char, or
%         categorical value that exists in the primary factor column. The
%         primary factor column is assumed to be the first field in the struct,
%         or if it's a string, the column name is taken from the first field of
%         the struct array that defines targetGroup.
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
%       specified subset. The original table is modified in place.
%
%   Example:
%     % Create a sample table
%     T = table( ...
%         categorical({'A';'A';'B';'B'}), ...
%         categorical({'X';'Y';'X';'Y'}), ...
%         [10; 12; 20; 22], ...
%         'VariableNames', {'Condition', 'Group', 'Measurement'});
%
%     % Define a target group using a struct for a multi-factor design
%     target = struct('Condition', 'B', 'Group', 'Y');
%
%     % Add a difference of 5 to the 'Measurement' of the target group
%     T_mod = vlt.table.addDifference(T, 'Measurement', target, 5);
%
%     % Display the result: the last row should be 27
%     disp(T_mod);
%
%   See also: VLT.STATS.POWER.FIND_GROUP_INDICES, VLT.STATS.POWER.RUN_LME_POWER_ANALYSIS
%

    arguments
        dataTable table
        dataColumn {mustBeTextScalar, mustBeAValidTableVariable(dataTable, dataColumn)}
        targetGroup
        difference (1,1) double
    end

    % Determine the primary category name. If targetGroup is a struct, it's the
    % first field name. Otherwise, we assume it's the name of the first variable
    % in the table that is not the dataColumn. This logic might need to be
    % adjusted based on more complex use cases, but it's a reasonable default.
    if isstruct(targetGroup)
        fields = fieldnames(targetGroup);
        primaryCategoryName = fields{1};
    else
        % Fallback for non-struct targetGroup: find the first categorical/string column
        varNames = dataTable.Properties.VariableNames;
        isDataCol = strcmp(varNames, dataColumn);
        potentialFactorCols = varNames(~isDataCol);
        isCatOrString = cellfun(@(x) iscategorical(dataTable.(x)) || isstring(dataTable.(x)) || iscellstr(dataTable.(x)), potentialFactorCols);
        firstFactor = find(isCatOrString, 1);
        if isempty(firstFactor)
            error('vlt:table:addDifference:noFactorCol', ...
                'Could not automatically determine the factor column. Please use a struct for targetGroup.');
        end
        primaryCategoryName = potentialFactorCols{firstFactor};
    end

    % Find the indices of the rows that match the target group criteria
    targetIndices = vlt.stats.power.find_group_indices(dataTable, targetGroup, primaryCategoryName);

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
