function [lme,newtable] = lme_category(tbl, categories_name, Y_name, Y_op, reference_category, group, rankorder, logdata)
% LME_CATEGORY - Fits a Linear Mixed-Effects model for power analysis.
%
%   This is a core helper function that prepares data and constructs the LME model.
%   It now supports multiple fixed effects by accepting a cell array for categories_name.
%
    arguments
        tbl table
        categories_name
        Y_name {mustBeTextScalar}
        Y_op {mustBeTextScalar}
        reference_category {mustBeTextScalar}
        group {mustBeTextScalar}
        rankorder (1,1) double = 0
        logdata (1,1) double = 0
    end

    % Handle single string or cell array for fixed effects
    if iscell(categories_name)
        primary_category_name = categories_name{1};
        all_fixed_effects = strjoin(categories_name, ' + ');
    else
        primary_category_name = categories_name;
        all_fixed_effects = categories_name;
    end

    % --- Whitespace and Character Sanitization ---
    % A robust cleaning function to handle different space characters
    clean_str = @(s) strtrim(replace(s, char(160), ' '));

    reference_category = clean_str(reference_category);

    cat_data = tbl.(primary_category_name);
    if iscategorical(cat_data)
        cat_data = cellstr(cat_data);
    end
    tbl.(primary_category_name) = clean_str(cat_data);
    % --- End Sanitization ---

    % Reorder the primary category so the reference is the baseline
    categor = tbl.(primary_category_name);
    if ~iscategorical(categor), categor = categorical(categor); end
    cats = categories(categor);
    rc = find(strcmp(reference_category,cats));
    if isempty(rc), error(['No category found named ''' reference_category '''. Check for spelling errors.']); end
    cats_reord = cats([rc 1:rc-1 rc+1:end]);

    % Prepare the response variable
    Y = tbl.(Y_name);
    if ~isempty(Y_op), Y = eval(Y_op); end
    data = Y;
    original_data = data;
    if rankorder == 1, data = tiedrank(data); elseif logdata, data = log10(data); end

    Y_name_fixed = matlab.lang.makeValidName(Y_name);

    newtable = tbl;
    newtable.(Y_name_fixed) = data;
    if ~strcmp(Y_name, Y_name_fixed), newtable.(Y_name) = []; end
    newtable.original_data = original_data;
    newtable.(primary_category_name) = reordercats(categorical(newtable.(primary_category_name)), cats_reord);

    formula = sprintf('%s ~ 1 + %s + (1 | %s)', Y_name_fixed, all_fixed_effects, group);

    lme = fitlme(newtable, formula);
end
