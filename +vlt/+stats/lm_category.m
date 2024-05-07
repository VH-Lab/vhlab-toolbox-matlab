function lm = lm_category(tbl, categories_name, Y_name, reference_category, rankorder)
% LM_CATEGORY - calculate a linear model for a variable measured in different fixed categories
%
% LM = LM_CATEGORY(TBL, CATEGORIES_NAME, Y_NAME, REFERENCE_CATEGORY, [RANKORDER])
%
% Create a linear model of the property Y_NAME that occurs in a column in 
% the table TBL. The model fits Y as a function of the categories listed in
% the TBL column CATEGORIES_NAME, using REFERENCE_CATEOGORY as a reference.
% If RANKORDER is provided and is 1, then the ranks (sort order) values of
% Y are used instead of the raw values.
% 
% Example:
%  load carsmall
%  tbl = table(Model_Year,MPG);
%  % compute standard linear model
%  lm = vlt.stats.lm_category(tbl,'Model_Year','MPG','70',0)
%  % compute non-parametric linear model
%  lm_ = vlt.stats.lm_category(tbl,'Model_Year','MPG','70',1)
%
%

if nargin<5,
	rankorder = 0;
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
end;

lm = fitlm(categor_reordered,data,'VarNames',{categories_name,Y_name});

