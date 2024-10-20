function [lme,lme_] = plot_lme_array(tbl, categories_name, Y_name_array, Y_label_array, Y_op, reference_category, group_name, log_type, plot_type, stat_type, varargin)
% PLOT_LME_ARRAY - plot an array of linear mixed effects models from a table
%
% [LME, LME_] = PLOT_LME_ARRAY(TBL, CATEGORIES_NAME, Y_NAME_ARRAY, Y_LABEL_ARRAY, Y_OP, ...
%        REFERENCE_CATEGORY, GROUP_NAME, LOG_TYPE, PLOT_TYPE, STAT_TYPE, ...)
%
% Inputs:
%   TBL - a table with the data to be examined
%   CATEGORIES_NAME - the table field with the categories to be examined (maybe 'condition_name')
%   Y_NAME_ARRAY - an array of TBL fields to be examined with LME
%   Y_LABEL_ARRAY - an array labels for the Y axis (one entry per Y_NAME_ARRAY value)
%   Y_OP - the operation to perform on Y; usually just 'Y' but could be '1-Y' or 'sin(Y)'. Can be empty
%          to indicate 'Y'; can be a cell array to use a different operation for each array item
%   REFERENCE_CATEGORY - the reference category (maybe 'control')
%   GROUP_NAME - the TBL field name with random effect names (maybe 'subject_name')
%   LOG_TYPE - 0/1 vector the same size as Y_NAME_ARRAY. For each entry, 0 if log should not be
%       used and 1 if the data should be log transformed for fitting and plotting.
%   PLOT_TYPE - 1/2 vector the same size as Y_NAME_ARRAY. For each entry, 1 if the plot should
%       be the regular LME model, and 2 if it should be the ranked/non-parametric version
%   STAT_TYPE - 1/2 vector the same size as Y_NAME_ARRAY. For each entry, 1 if the stats shown
%       should be from the regular LME fit, and 2 if it should be from the ranked/non-parametric version.
%   
% This function takes name/value pairs that modify the default behavior.
% The name/value pairs that are accepted are PLOT_LME_CATEGORY_OPTIONS.
% See: PLOT_LME_CATEGORY_OPTIONS, vlt.stats.plot_lme_category_options
%

ops = vlt.stats.plot_lme_category_options(varargin{:});

if isempty(Y_op),
	Y_op = repmat({'Y'},numel(Y_name_array),1);
elseif numel(Y_op)==1,
	Y_op = repmat({Y_op},numel(Y_name_array),1);
end;

f = figure;

for i=1:numel(Y_name_array),
	supersubplot(f,2,2,i);
	try, [lme{i},newtable{i}] = vlt.stats.lme_category(tbl,categories_name,Y_name_array{i},...
		Y_op{i}, reference_category,group_name,0,log_type(i));
        catch, warning(['LME non-ranked calculation failed.']);
    end;
	[lme_{i},newtable_{i}] = vlt.stats.lme_category(tbl,categories_name,Y_name_array{i},...
		Y_op{i}, reference_category,group_name,1);

	ops_here = ops;
	ops_here.islog10 = log_type(i);
	ops_nvp = vlt.data.struct2namevaluepair(ops_here);
	switch(plot_type(i)),
		case 1,
			[h,plot_info]=vlt.stats.plot_lme_category(lme{i},newtable{i},categories_name,...
				Y_name_array{i}, reference_category,group_name,...
				ops_nvp{:},'Y_label',Y_label_array{i},'isranked',0);
		case 2,
			[h,plot_info]=vlt.stats.plot_lme_category(lme_{i},newtable_{i},categories_name,...
				Y_name_array{i},reference_category,group_name,...
				ops_nvp{:},'Y_label',Y_label_array{i},'isranked',1);
	end;

	switch(stat_type(i)),
		case 1, % use LME
			[fe,fenames,festats]=fixedEffects(lme{i});
			title(['P < ' num2str(festats.pValue(:)')]);
		case 2, % use non-parametric LME
			[fe,fenames,festats]=fixedEffects(lme_{i});
			title(['P < ' num2str(festats.pValue(:)')]);
	end;
	set(gca,'fontsize',12);
end;


