function [data,exper_indexes] = conditiongroup2cell(values, experiment_indexes, condition_indexes)
% VLT.DATA.CONDITIONGROUP2CELL - Convert a condition grouping matrix to a cell array
%
%   [DATA, EXPER_INDEXES] = vlt.data.conditiongroup2cell(VALUES, EXPERIMENT_INDEXES, CONDITION_INDEXES)
%
%   This function reorganizes data based on condition and experiment indexes.
%
%   Inputs:
%   'VALUES' is an array of data values.
%   'EXPERIMENT_INDEXES' is an array of the same size as VALUES, indicating
%     the experiment number for each value.
%   'CONDITION_INDEXES' is an array of the same size as VALUES, indicating
%     the condition number for each value.
%
%   Outputs:
%   'DATA' is a cell array where each cell contains the values for a specific
%     condition.
%   'EXPER_INDEXES' is a cell array where each cell contains the experiment
%     indexes for the corresponding values in DATA.
%
%   This function is useful for preparing data for plotting functions like
%   vlt.plot.median_within_between_plot.
%
%   Example:
%       values = [10 20 30 40 50];
%       exp_indexes = [1 1 2 2 1];
%       cond_indexes = [1 2 1 2 1];
%       [data, exper_indexes] = vlt.data.conditiongroup2cell(values, exp_indexes, cond_indexes);
%       % data{1} will be [10 30 50]
%       % exper_indexes{1} will be [1 2 1]
%       % data{2} will be [20 40]
%       % exper_indexes{2} will be [1 2]
%
%   See also: vlt.plot.median_within_between_plot
%


data = {};
exper_indexes = {};

C = unique(condition_indexes);

for c=1:length(C),
	indexes = find(condition_indexes==C(c));
	data{c} = values(indexes);
	exper_indexes{c} = experiment_indexes(indexes);
end;
 
 
