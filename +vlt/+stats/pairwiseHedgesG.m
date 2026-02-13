function O = pairwiseHedgesG(T, depVar, factors)
% PAIRWISEHEDGESG - Calculate pairwise Hedges' g for groups in a table
%
% O = vlt.stats.pairwiseHedgesG(T, depVar, factors)
%
% Computes Hedges' g effect size between all pairs of groups defined by the
% specified factors.
%
% Inputs:
%   T - A table containing the data.
%   depVar - A string or char array specifying the name of the dependent variable column in T.
%   factors - A string or cell array of strings/chars specifying the names of the grouping columns in T.
%
% Outputs:
%   O - A table containing the pairwise comparisons.
%       - The first N columns correspond to the input factors. Entries are formatted as "Level1 vs Level2"
%         if the levels differ between the pair, or "Level1" if they are the same.
%       - The (N+1)-th column is named "DependentVariable" and contains the name of the dependent variable.
%       - The last column is named "HedgesG" and contains the calculated Hedges' g value.
%
% Example:
%   T = table([1;1;2;2], [10;12;20;22], 'VariableNames', {'Group', 'Value'});
%   O = vlt.stats.pairwiseHedgesG(T, 'Value', 'Group');
%

    arguments
        T table
        depVar (1,:) char
        factors
    end

    % Ensure factors is a cell array of char vectors
    if ischar(factors)
        factors = {factors};
    elseif isstring(factors)
        factors = cellstr(factors);
    end

    if ~iscellstr(factors)
         error('vlt:stats:pairwiseHedgesG:InvalidFactors', 'Factors must be a string or cell array of strings/chars.');
    end

    % Identify unique groups
    [G, U] = findgroups(T(:, factors));
    numGroups = height(U);

    if numGroups < 2
        % Not enough groups for pairwise comparison
        O = table();
        return;
    end

    % Generate all pairs of group indices (1 to numGroups)
    pairs = nchoosek(1:numGroups, 2);
    numPairs = size(pairs, 1);

    % Preallocate output columns
    factorData = cell(numPairs, length(factors));
    hedgesGValues = nan(numPairs, 1);
    depVarCol = repmat({depVar}, numPairs, 1);

    % Loop through each pair
    for i = 1:numPairs
        idx1 = pairs(i, 1);
        idx2 = pairs(i, 2);

        % Get data for dependent variable
        data1 = T.(depVar)(G == idx1);
        data2 = T.(depVar)(G == idx2);

        % Calculate Hedges' g
        hedgesGValues(i) = vlt.stats.hedgesG(data1, data2);

        % Construct factor labels for this pair
        for f = 1:length(factors)
            fname = factors{f};
            val1 = U.(fname)(idx1);
            val2 = U.(fname)(idx2);

            % Convert to string for comparison and display
            str1 = string(val1);
            str2 = string(val2);

            if ismissing(str1), str1 = "NaN"; end % Handle missing values if any
            if ismissing(str2), str2 = "NaN"; end

            if strcmp(str1, str2)
                factorData{i, f} = char(str1);
            else
                factorData{i, f} = char(str1 + " vs " + str2);
            end
        end
    end

    % Construct output table
    % Create table from factor columns first
    O = cell2table(factorData, 'VariableNames', factors);

    % Add dependent variable column (using Valid Variable Name)
    O.DependentVariable = depVarCol;

    % Add HedgesG column
    O.HedgesG = hedgesGValues;

end
