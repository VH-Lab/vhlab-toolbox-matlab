function [data,exper_indexes] = conditiongroup2cell(values, experiment_indexes, condition_indexes)
%  CONDITIONGROUP2VALUE - Convert a condition grouping matrix to a cell.
%
%  [DATA, EXPER_INDEXES] = CONDITIONGROUP2CELL(VALUES, EXPERIMENT_INDEXES, CONDITION_INDEXES)
%
%  Given an array of values VALUES, and another array EXPERIMENT_INDEXES that describes
%  (with an index number) the experiment number that produced each entry of VALUES,
%  and another array CONDITION_INDEXES that describes (with an index number) the
%  experimental condition of each observation in VALUES, this function produces
%  
%  DATA - a cell array with the number of entries equal to the number of unique values of
%   CONDITION_INDEXES. Each entry has a matrix of VALUES from that condition.
%  EXPER_INDEXES - a cell array with the number of entries equal to the number of
%   unique values of CONDITION_INDEXES. Each entry EXPER_INDEXES{n}(i) describes the
%  experiment index number that produced the observation DATA{n}(i)
%   
%  This function is useful for preparing data in the form expected by MEDIAN_WITHIN_BETWEEN_PLOT
%
%  The documentation is way longer than the code.


data = {};
exper_indexes = {};

C = unique(condition_indexes);

for c=1:length(C),
	indexes = find(condition_indexes==C(c));
	data{c} = values(indexes);
	exper_indexes{c} = experiment_indexes(indexes);
end;
 
 
