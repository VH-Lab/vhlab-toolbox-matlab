function [lme,newtable] = lme_category(tbl, categories_name, Y_name, Y_op, reference_category, group, rankorder, logdata)
% LME_CATEGORY - (Dependency) Your original LME fitting function.
    if nargin<7, rankorder = 0; end
    if nargin<8, logdata = 0; end
    categor = categorical(tbl.(categories_name));
    cats = categories(categor);
    rc = find(strcmp(reference_category,cats));
    if isempty(rc), error(['No category found named ' reference_category '.']); end
    cats_reord = cats([rc 1:rc-1 rc+1:end]);
    categor_reordered = reordercats(categor,cats_reord);
    Y = tbl.(Y_name);
    if ~isempty(Y_op), Y = eval(Y_op); end
    data = Y;
    original_data = data;
    if rankorder == 1, data = tiedrank(data); elseif logdata, data = log10(data); end
    group_data = tbl.(group);
    Y_name_fixed = strrep(Y_name,'.','__');
    newtable = table(categor_reordered,group_data,data,original_data,'VariableNames',{categories_name,group,Y_name_fixed,'original_data'});
    lme = fitlme(newtable, [Y_name_fixed ' ~ 1 + ' categories_name ' + (1 | ' group ')']);
end
