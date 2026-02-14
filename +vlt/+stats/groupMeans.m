function O = groupMeans(T, dependent_variable, factors)
% vlt.stats.groupMeans - Calculate the mean of a dependent variable across groups defined by factors
%
% O = vlt.stats.groupMeans(T, DEPENDENT_VARIABLE, FACTORS)
%
% This function calculates the mean of a dependent variable for all groups defined by the combinations
% of the different levels of all provided factors.
%
% Inputs:
%  T - A table containing the data.
%  DEPENDENT_VARIABLE - A string or character array specifying the column name of the dependent variable to average.
%  FACTORS - A string array or cell array of character arrays specifying the column names of the factors to group by.
%
% Outputs:
%  O - A table with columns for each of the factor names and a column called ['Mean_' DEPENDENT_VARIABLE].
%      Rows correspond to unique combinations of the factor levels.
%
% Example:
%  T = table(['A';'A';'B';'B'], [1;2;1;2], [10;20;30;40], 'VariableNames', {'F1', 'F2', 'Y'});
%  O = vlt.stats.groupMeans(T, 'Y', {'F1', 'F2'});
%

arguments
    T table
    dependent_variable (1,1) string
    factors
end

% Ensure factors is a cellstr or string array
if ischar(factors)
    factors = {factors};
end

if ~isstring(factors) && ~iscellstr(factors)
    error('vlt:stats:groupMeans:InvalidInput', 'FACTORS must be a string array or a cell array of character arrays.');
end

% Calculate group means using groupsummary
% groupsummary(T, GroupVars, Method, DataVars)
G = groupsummary(T, factors, 'mean', dependent_variable);

% Determine the default output column name from groupsummary
default_mean_col_name = ['mean_' char(dependent_variable)];

% Determine the desired output column name
desired_mean_col_name = ['Mean_' char(dependent_variable)];

% Select columns: Factors + Mean Column
% We explicitly select by name to ensure we only get what we asked for (excluding GroupCount, etc.)
cols_to_keep = [cellstr(factors(:)'), {default_mean_col_name}];
O = G(:, cols_to_keep);

% Rename the mean column
O.Properties.VariableNames{default_mean_col_name} = desired_mean_col_name;

end
