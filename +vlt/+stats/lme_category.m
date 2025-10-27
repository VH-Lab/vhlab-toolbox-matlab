function [lme,newtable] = lme_category(tbl, categories_name, Y_name, Y_op, reference_category, group, rankorder, logdata, options)
% LME_CATEGORY - Fits a Linear Mixed-Effects model for power analysis.
%
%   This is a core helper function that prepares data and constructs the LME model.
%   It now supports multiple fixed effects and optional, intelligent table trimming.
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
        options.TrimTable (1,1) logical = true
    end

    % --- 1. Gather all required variable names ---
    if iscell(categories_name)
        primary_category_name = categories_name{1};
        all_category_names = categories_name;
    else
        primary_category_name = categories_name;
        all_category_names = {categories_name};
    end

    % Get a unique list of all columns needed for the model
    required_cols = unique([all_category_names(:)', {Y_name, group}]);

    if options.TrimTable
        newtable = tbl(:, required_cols);
    else
        newtable = tbl;
    end

    % --- 2. Sanitize strings in the new table ---
    clean_str = @(s) strtrim(replace(s, char(160), ' '));
    reference_category = clean_str(reference_category);

    cat_data = newtable.(primary_category_name);
    if iscategorical(cat_data), cat_data = cellstr(cat_data); end
    newtable.(primary_category_name) = clean_str(cat_data);

    % --- 3. Prepare data and build model formula ---
    categor = newtable.(primary_category_name);
    if ~iscategorical(categor), categor = categorical(categor); end
    cats = categories(categor);
    rc = find(strcmp(reference_category,cats));
    if isempty(rc), error(['No category found named ''' reference_category '''. Check for spelling errors.']); end
    cats_reord = cats([rc 1:rc-1 rc+1:end]);
    newtable.(primary_category_name) = reordercats(categorical(newtable.(primary_category_name)), cats_reord);

    Y = newtable.(Y_name);
    if ~isempty(Y_op), Y = eval(Y_op); end

    % Important: Do NOT change Y_name, as it may contain dots for struct fields
    newtable.Y_data_for_fit = Y;
    newtable.original_data = newtable.(Y_name);
    if rankorder == 1
        newtable.Y_data_for_fit = tiedrank(newtable.Y_data_for_fit);
    elseif logdata
        newtable.Y_data_for_fit = log10(newtable.Y_data_for_fit);
    end

    all_fixed_effects = strjoin(all_category_names, ' + ');
    formula = sprintf('Y_data_for_fit ~ 1 + %s + (1 | %s)', all_fixed_effects, group);

    % --- 4. Fit the model ---
    lme = fitlme(newtable, formula);
end
