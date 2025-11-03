function simTbl = simulate_lme_data_shuffle_predictor(lme_base, tbl_base, effect_size, primary_category, category_to_test, y_name, group_name, options)
% SIMULATE_LME_DATA_SHUFFLE_PREDICTOR - Generates surrogate LME data by shuffling a predictor.
%
%   This simulation function creates a "null" dataset by shuffling a specified predictor
%   column (e.g., 'condition_name'). This breaks the relationship between that predictor
%   and the response variable.
%
%   Crucially, to preserve the original noise structure of the data, the simulation then:
%   1. Predicts the response based on the shuffled fixed effects.
%   2. Adds back shuffled residuals from the original model.
%
%   Finally, a hypothetical `effect_size` is added to the specified `category_to_test`.
%
    arguments
        lme_base
        tbl_base
        effect_size
        primary_category
        category_to_test
        y_name
        group_name
        options.ShufflePredictor {mustBeTextScalar}
        options.InteractionFields cell = {}
    end

    simTbl = tbl_base;

    % --- 1. Simulate the Null Hypothesis for Fixed Effects by Shuffling ---
    predictor_to_shuffle = options.ShufflePredictor;
    simTbl.(predictor_to_shuffle) = simTbl.(predictor_to_shuffle)(randperm(height(simTbl)));

    % --- 2. Recalculate Interaction Term if Necessary ---
    if ~isempty(options.InteractionFields)
        fields = options.InteractionFields;
        interaction_vars = cell(height(simTbl), numel(fields));
        for i = 1:numel(fields)
            column_data = simTbl.(fields{i});
            if isnumeric(column_data)
                interaction_vars(:,i) = cellstr(num2str(column_data));
            else
                interaction_vars(:,i) = cellstr(column_data);
            end
        end
        simTbl.InteractionGroup = categorical(join(interaction_vars, '_'));
    end

    % --- 3. Create the Null Data by Predicting from Shuffled + Adding Residuals ---
    % Predict the response based on the fixed effects of our shuffled data
    y_predicted_null = predict(lme_base, simTbl);

    % Get the original residuals and shuffle them to preserve noise structure
    residuals_shuffled = resid(lme_base);
    residuals_shuffled = residuals_shuffled(randperm(numel(residuals_shuffled)));

    % The null data is the prediction from the shuffled predictors + shuffled noise
    simTbl.(y_name) = y_predicted_null + residuals_shuffled;

    % --- 4. Add the Hypothetical Effect Size ---
    if effect_size ~= 0
        is_target_category = vlt.stats.power.find_group_indices(simTbl, category_to_test, primary_category);
        simTbl.(y_name)(is_target_category) = simTbl.(y_name)(is_target_category) + effect_size;
    end
end
