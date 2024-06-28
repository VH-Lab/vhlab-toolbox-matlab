function lm = lm_category(tbl, categories_name, Y_name, Y_op, reference_category, rankorder)
% LM_CATEGORY - calculate a linear model for a variable measured in different fixed categories
%
% LM = LM_CATEGORY(TBL, CATEGORIES_NAME, Y_NAME, Y_OP, REFERENCE_CATEGORY, [RANKORDER])
%
% Create a linear model of the property Y_NAME that occurs in a column in 
% the table TBL. The model fits Y as a function of the categories listed in
% the TBL column CATEGORIES_NAME, using REFERENCE_CATEOGORY as a reference.
% The raw values in the table are processed through Y_OP, which evaluates a 
% column of Y elements.
% If RANKORDER is provided and is 1, then the ranks (sort order) values of
% Y are used instead of the raw values.
% 
% 
% Example:
%  load carsmall
%  tbl = table(Model_Year,MPG);
%  Y_op = 'Y'; % just use Y
%  % compute standard linear model
%  lm = vlt.stats.lm_category(tbl,'Model_Year','MPG',Y_op,'70',0)
%  % compute non-parametric linear model
%  lm_ = vlt.stats.lm_category(tbl,'Model_Year','MPG',Y_op,'70',1)
%
%

if nargin<6,
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

Y = tbl.(Y_name);
if ~isempty(Y_op),
	Y = eval(Y_op);
end;

data = Y;

if rankorder == 1,
	data = vlt.data.sortorder(data);
end;

Y_name_fixed = strrep(Y_name,'.','__');

newtable = table(categor_reordered,data,'VariableNames',{categories_name,Y_name_fixed});

lm = fitlm(newtable, [Y_name_fixed ' ~ 1+ ' categories_name]);

