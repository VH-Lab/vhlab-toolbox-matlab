function [lme,newtable] = lme_category(tbl, categories_name, Y_name, Y_op, reference_category, group, rankorder, logdata)
% LME_CATEGORY - Fits a Linear Mixed-Effects model for power analysis.
%
%   This is a core helper function that prepares data and constructs the LME model.
%   It now supports multiple fixed effects by accepting a cell array for categories_name
%   and intelligently trims the input table to only include necessary columns.
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

    % --- 2. Create the smaller, optimized table ---
    newtable = tbl(:, required_cols);

    % --- 3. Sanitize strings in the new table ---
    clean_str = @(s) strtrim(replace(s, char(160), ' '));

    reference_category = clean_str(reference_category);

    cat_data = newtable.(primary_category_name);
    if iscategorical(cat_data)
        cat_data = cellstr(cat_data);
    end
    newtable.(primary_category_name) = clean_str(cat_data);

    % --- 4. Prepare data and build model formula ---
    % Reorder the primary category so the reference is the baseline
    categor = newtable.(primary_category_name);
    if ~iscategorical(categor), categor = categorical(categor); end
    cats = categories(categor);
    rc = find(strcmp(reference_category,cats));
    if isempty(rc), error(['No category found named ''' reference_category '''. Check for spelling errors.']); end
    cats_reord = cats([rc 1:rc-1 rc+1:end]);
    newtable.(primary_category_name) = reordercats(categorical(newtable.(primary_category_name)), cats_reord);

    % Prepare the response variable
    Y = newtable.(Y_name);
    if ~isempty(Y_op), Y = eval(Y_op); end
    data = Y;
    original_data = data;
    if rankorder == 1, data = tiedrank(data); elseif logdata, data = log10(data); end

    Y_name_fixed = matlab.lang.makeValidName(Y_name);

    % Add/replace response column and original data in the new table
    newtable.(Y_name_fixed) = data;
    if ~strcmp(Y_name, Y_name_fixed) % If we created a new column (e.g. invalid name)
        newtable = removevars(newtable, Y_name); % Remove the old one
    end
    newtable.original_data = original_data;

    % Build the model formula dynamically
    all_fixed_effects = strjoin(all_category_names, ' + ');
    formula = sprintf('%s ~ 1 + %s + (1 | %s)', Y_name_fixed, all_fixed_effects, group);

    % --- 5. Fit the model ---
    lme = fitlme(newtable, formula);
end
