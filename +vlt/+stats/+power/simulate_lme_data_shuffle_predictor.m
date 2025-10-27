function simTbl = simulate_lme_data_shuffle_predictor(lme_base, tbl_base, effect_size, primary_category, category_to_test, y_name, group_name, options)
% SIMULATE_LME_DATA_SHUFFLE_PREDICTOR - Generates surrogate LME data by shuffling a predictor.
%
%   This simulation function creates a "null" dataset by shuffling a specified predictor
%   column (e.g., 'condition_name'). This breaks the relationship between that predictor
%   and the response variable, simulating the null hypothesis while preserving the exact
%   marginal distributions of both the predictor and the response.
%
%   After shuffling, a hypothetical `effect_size` is added to the specified `category_to_test`.
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
    end

    simTbl = tbl_base;

    % --- Simulate the Null Hypothesis by Shuffling the Predictor ---
    predictor_to_shuffle = options.ShufflePredictor;
    simTbl.(predictor_to_shuffle) = simTbl.(predictor_to_shuffle)(randperm(height(simTbl)));

    % --- Add the Hypothetical Effect Size ---
    % Important: Find the rows for the test category *after* shuffling to apply the effect.
    if effect_size ~= 0
        is_target_category = vlt.stats.power.find_group_indices(simTbl, category_to_test);
        simTbl.(y_name)(is_target_category) = simTbl.(y_name)(is_target_category) + effect_size;
    end
end
