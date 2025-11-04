function [mdes, power_curve, primary_category] = lme_power_effectsize(tbl, categories_name, y_name, reference_category, group_name, category_to_test, target_power, options)
% LME_POWER_EFFECTSIZE - Finds the minimum detectable effect size (MDES) via simulation.
%
%   Core worker function for LME power analysis. See the documentation for the main
%   function vlt.stats.power.run_lme_power_analysis for detailed information.
%
    arguments
        tbl
        categories_name
        y_name
        reference_category
        group_name
        category_to_test
        target_power
        options.Alpha (1,1) double = 0.05
        options.NumSimulations (1,1) double = 500
        options.EffectStep (1,1) double = -1
        options.Method (1,1) string {mustBeMember(options.Method,{'gaussian','shuffle','hierarchical'})} = 'gaussian'
        options.ShufflePredictor {mustBeTextScalar} = ''
    end

    interaction_fields = {};
    if isstruct(reference_category)
        % Post-hoc test mode
        disp('Post-hoc mode: Creating temporary interaction variable...');

        % Combine all fields from the struct to create a unique group identifier
        fields = fieldnames(reference_category);
        interaction_fields = fields;
        interaction_vars = cell(height(tbl), numel(fields));
        for i = 1:numel(fields)
            column_data = tbl.(fields{i});
            if isnumeric(column_data)
                interaction_vars(:,i) = cellstr(num2str(column_data));
            else
                interaction_vars(:,i) = cellstr(column_data);
            end
        end
        tbl.InteractionGroup = categorical(join(interaction_vars, '_'));

        % Convert struct values to cell array of strings for robust joining
        ref_cells = struct2cell(reference_category);
        for i=1:numel(ref_cells)
            if isnumeric(ref_cells{i})
                ref_cells{i} = num2str(ref_cells{i});
            end
        end
        ref_group_str = strjoin(ref_cells, '_');

        test_cells = struct2cell(category_to_test);
        for i=1:numel(test_cells)
            if isnumeric(test_cells{i})
                test_cells{i} = num2str(test_cells{i});
            end
        end
        test_group_str = strjoin(test_cells, '_');

        disp('Fitting baseline model to original data using interaction term...');
        trim_opt = isempty(options.ShufflePredictor); % Don't trim if we need the predictor column for shuffling
        [lme_base, tbl_base] = vlt.stats.lme_category(tbl, 'InteractionGroup', y_name, '', ref_group_str, group_name, 0, 0, 'TrimTable', trim_opt);

        primary_category = 'InteractionGroup';
        category_to_test = test_group_str; % for coefficient finding

    else
        % Original main effect mode
        disp('Fitting baseline model to original data...');
        trim_opt = isempty(options.ShufflePredictor); % Don't trim if we need the predictor column for shuffling
        [lme_base, tbl_base] = vlt.stats.lme_category(tbl, categories_name, y_name, '', reference_category, group_name, 0, 0, 'TrimTable', trim_opt);

        if iscell(categories_name)
            primary_category = categories_name{1};
        else
            primary_category = categories_name;
        end
    end

    y_name_fixed = 'Y_data_for_fit'; % This is now the fixed response variable name

    % --- Whitespace and Character Sanitization ---
    if ischar(category_to_test) || isstring(category_to_test)
        clean_str = @(s) strtrim(replace(s, char(160), ' '));
        category_to_test = clean_str(category_to_test);
    end
    % --- End Sanitization ---

    sim_func = vlt.stats.power.getLMESimFunc(options.Method, 'ShufflePredictor', options.ShufflePredictor, 'InteractionFields', interaction_fields);

    % --- DEBUGGING LOOP ---
    fprintf('\n--- DEBUGGING: Displaying 3 sample shuffles and their LME models ---\n');
    for i = 1:3
        fprintf('\n--- SHUFFLE %d ---\n', i);
        simTbl = sim_func(lme_base, tbl_base, 0.5, primary_category, category_to_test, y_name_fixed, group_name);

        fprintf('--- Simulated Table Head ---\n');
        disp(head(simTbl));

        fprintf('\n--- Fitted LME Model for Shuffle %d ---\n', i);
        lme_sim = fitlme(simTbl, lme_base.Formula.char);
        disp(lme_sim);
    end

    % --- Disable the rest of the function for debugging ---
    mdes = NaN;
    power_curve = table();
    return;

end
