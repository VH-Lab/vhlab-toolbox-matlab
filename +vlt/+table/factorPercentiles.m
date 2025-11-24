function T = factorPercentiles(T, dataVar, factors)
% vlt.table.factorPercentiles - Compute percentile ranks of a variable within factor groups
%
% T = vlt.table.factorPercentiles(T, dataVar, factors)
%
% This function calculates the percentile rank (0-100) of a specified numeric
% variable (`dataVar`) within groups defined by the `factors`. The results are
% added to the table `T` in a new column.
%
% Inputs:
%   T       - A MATLAB table.
%   dataVar - A string or character vector specifying the name of the numeric
%             variable in `T` for which to calculate percentiles.
%   factors - A string array or cell array of character vectors specifying the
%             variable names in `T` to group by.
%
% Outputs:
%   T       - The input table with an additional column containing the percentile
%             ranks. The new column name is constructed as:
%             [dataVar '_' FACTOR1 '_' FACTOR2 ... '_PERCENTILE']
%             where FACTOR1, etc., are the names of the grouping factors.
%
%             The percentile rank is calculated using the formula:
%             Percentile = (Rank / N) * 100
%             where Rank is the rank of the value within its group (using average
%             ranks for ties) and N is the number of non-NaN observations in the group.
%             NaN values in the data variable are assigned a percentile of NaN.
%
% Example:
%   % Create sample table
%   T = table(['A';'A';'B';'B'], [1; 2; 10; 20], 'VariableNames', {'Group', 'Value'});
%
%   % Calculate percentiles
%   T = vlt.table.factorPercentiles(T, 'Value', "Group");
%
%   % Resulting T has a new column 'Value_Group_PERCENTILE' with values [50; 100; 50; 100].
%

    arguments
        T table
        dataVar (1,1) string
        factors (1,:) string
    end

    % 1. Validation
    % Check if data variable exists
    if ~ismember(dataVar, T.Properties.VariableNames)
        error('vlt:table:factorPercentiles:VariableNotFound', ...
            'Variable "%s" not found in table.', dataVar);
    end

    % Check if data variable is numeric
    if ~isnumeric(T.(dataVar))
        error('vlt:table:factorPercentiles:DataNotNumeric', ...
            'Data variable "%s" must be numeric to calculate percentiles.', dataVar);
    end

    % Check if factors exist
    missingFactors = setdiff(factors, T.Properties.VariableNames);
    if ~isempty(missingFactors)
        error('vlt:table:factorPercentiles:FactorNotFound', ...
            'Grouping factors not found in table: %s', strjoin(missingFactors, ', '));
    end

    % 2. Construct new column name
    % Format: dataVar_Factor1_Factor2_..._PERCENTILE
    newColName = strjoin([dataVar, factors, "PERCENTILE"], '_');

    % Check if new column name already exists?
    % The function will overwrite if it does, which is standard behavior for "adding/updating" columns.
    % I won't error, just overwrite.

    % Initialize new column with NaNs
    T.(newColName) = nan(height(T), 1);

    % 3. Grouping
    if isempty(factors)
        % If no factors are provided, treat the entire table as one group
        G = ones(height(T), 1);
        numGroups = 1;
    else
        % Extract factor columns to determine groups
        factorData = T(:, factors);
        G = findgroups(factorData);
        numGroups = max(G);
    end

    % 4. Calculate Percentiles per Group
    data = T.(dataVar);

    for i = 1:numGroups
        idx = (G == i);
        groupData = data(idx);

        % tiedrank computes ranks. NaN values get NaN rank.
        % Ties get the average rank.
        ranks = tiedrank(groupData);

        % Number of non-NaN observations in this group
        N = sum(~isnan(groupData));

        if N > 0
            % Calculate percentile: (Rank / N) * 100
            % For NaNs, ranks is NaN, so result is NaN.
            percentiles = (ranks / N) * 100;
        else
            % If all are NaN or empty
            percentiles = ranks;
        end

        T.(newColName)(idx) = percentiles;
    end

end
