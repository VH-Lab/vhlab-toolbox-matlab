function simTbl = simulate_lme_data_shuffle_predictor(lme_base, tbl_base, effect_size, primary_category, category_to_test, y_name, group_name, options)
% SIMULATE_LME_DATA_SHUFFLE_PREDICTOR - Generates surrogate LME data by shuffling a predictor.
%
%   This simulation function creates a "null" dataset by shuffling a specified predictor
%   column (e.g., 'condition_name'). This breaks the relationship between that predictor
%   and the response variable.
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
        options.InteractionFields cell = {}
    end

    % --- 1. Simulate the Null Hypothesis for Fixed Effects by Shuffling ---
    % We do a row-level shuffle of just the predictor column. The data column (y_name)
    % and any other columns remain fixed in place.
    simTbl = vlt.table.shuffle(tbl_base, y_name, {}, options.ShufflePredictor);

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

    % --- 3. Add the Hypothetical Effect Size ---
    if effect_size ~= 0
        % Note: We use the *original* table (tbl_base) to find the target indices
        % to ensure the effect is applied to a consistent set of observations,
        % even though the predictor values in simTbl have been shuffled.
        simTbl = vlt.table.addDifference(simTbl, y_name, primary_category, category_to_test, effect_size);
    end
end
