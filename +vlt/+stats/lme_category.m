function [lme,newtable] = lme_category(tbl, categories_name, Y_name, reference_category, group, rankorder, logdata)
% LME_CATEGORY - calculate a mixed linear model for a variable measured in different fixed categories and random effects across group
%
% LME = LME_CATEGORY(TBL, CATEGORIES_NAME, Y_NAME, REFERENCE_CATEGORY, GROUP_NAME, [RANKORDER], [LOGDATA])
%
% Create a linear model of the property Y_NAME that occurs in a column in 
% the table TBL, controlling for random effects that vary across the
% table column called GROUP_NAME. The model fits Y as a function of the
% categories listed in the TBL column CATEGORIES_NAME, using REFERENCE_CATEOGORY
% as a reference.
%
% If RANKORDER is provided and is 1, then the ranks (sort order) values of
% Y are used instead of the raw values.
% 
% Example:
%  load carsmall
%  tbl = table(Mfg,Model_Year,MPG);
%  % compute standard linear model
%  [lme,newtable] = vlt.stats.lme_category(tbl,'Model_Year','MPG','70','Mfg',0)
%  % compute non-parametric linear model
%  [lme_,newtable_] = vlt.stats.lme_category(tbl,'Model_Year','MPG','70','Mfg',1)
%
%

if nargin<6,
	rankorder = 0;
end;

if nargin<7,
	logdata = 0;
end;

categor = categorical(tbl.(categories_name));
cats = categories(categor);

rc = find(strcmp(reference_category,cats));
if isempty(rc),
	error(['No category found named ' reference_category '.']);
end;

cats_reord = cats([rc 1:rc-1 rc+1:end]);

categor_reordered = reordercats(categor,cats_reord);

data = tbl.(Y_name);

if rankorder == 1,
	data = vlt.data.sortorder(data);
elseif logdata,
	data = log10(data);
end;

group_data = tbl.(group);

newtable = table(categor_reordered,group_data,data,'VariableNames',{categories_name,group,Y_name});

lme = fitlme(newtable, [Y_name ' ~ 1+ ' categories_name ' + (1 | ' group ')']);


