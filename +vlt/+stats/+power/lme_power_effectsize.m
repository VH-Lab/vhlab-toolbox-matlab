function [mdes, power_curve] = lme_power_effectsize(tbl, categories_name, y_name, reference_category, group_name, category_to_test, target_power, options)
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

    if isstruct(reference_category)
        % Post-hoc test mode
        disp('Post-hoc mode: Creating temporary interaction variable...');

        % Combine all fields from the struct to create a unique group identifier
        fields = fieldnames(reference_category);
        interaction_vars = cell(height(tbl), numel(fields));
        for i = 1:numel(fields)
            interaction_vars(:,i) = cellstr(tbl.(fields{i}));
        end
        tbl.InteractionGroup = categorical(join(interaction_vars, '_'));

        ref_group_str = strjoin(struct2cell(reference_category), '_');
        test_group_str = strjoin(struct2cell(category_to_test), '_');

        disp('Fitting baseline model to original data using interaction term...');
        [lme_base, tbl_base] = vlt.stats.lme_category(tbl, 'InteractionGroup', y_name, '', ref_group_str, group_name, 0, 0);

        primary_category = 'InteractionGroup';
        category_to_test = test_group_str; % for coefficient finding

    else
        % Original main effect mode
        disp('Fitting baseline model to original data...');
        [lme_base, tbl_base] = vlt.stats.lme_category(tbl, categories_name, y_name, '', reference_category, group_name, 0, 0);

        if iscell(categories_name)
            primary_category = categories_name{1};
        else
            primary_category = categories_name;
        end
    end

    y_name_fixed = 'Y_data_for_fit'; % This is now the fixed response variable name

    if options.EffectStep == -1
        options.EffectStep = std(tbl_base.(y_name_fixed), 'omitnan') / 50;
        fprintf('Using a search step size of %.3f\n', options.EffectStep);
    end

    fprintf('Searching for effect size that yields %.0f%% power...\n', target_power*100);

    current_power = 0;
    test_effect_size = 0;
    power_curve_data = [];

    % --- Whitespace and Character Sanitization ---
    if ischar(category_to_test) || isstring(category_to_test)
        clean_str = @(s) strtrim(replace(s, char(160), ' '));
        category_to_test = clean_str(category_to_test);
    end
    % --- End Sanitization ---

    % Programmatically find the exact coefficient name from the baseline model
    all_coeffs = lme_base.CoefficientNames;
    coeff_idx = find(contains(all_coeffs, category_to_test) & ~strcmp(all_coeffs, '(Intercept)'));
    if isempty(coeff_idx)
        error('Could not find the coefficient corresponding to the category to test in the baseline model.');
    end
    coeff_name = all_coeffs{coeff_idx};
    fprintf('Found coefficient to test: ''%s''\n', coeff_name);


    use_parallel = ~isempty(ver('parallel'));
    if use_parallel
        fprintf('Parallel Computing Toolbox detected. Using parfor for simulations.\n');
    end

    sim_func = vlt.stats.power.getLMESimFunc(options.Method, 'ShufflePredictor', options.ShufflePredictor);
    alpha = options.Alpha;
    num_simulations = options.NumSimulations;

    while current_power < target_power
        test_effect_size = test_effect_size + options.EffectStep;

        p_values = ones(num_simulations, 1);
        sim_loop = 1:num_simulations;

        if use_parallel
            parfor i = sim_loop
                simTbl = sim_func(lme_base, tbl_base, test_effect_size, primary_category, category_to_test, y_name_fixed, group_name);
                p_values(i) = run_single_simulation(simTbl, lme_base.Formula, coeff_name);
            end
        else % Regular for loop
            for i = sim_loop
                simTbl = sim_func(lme_base, tbl_base, test_effect_size, primary_category, category_to_test, y_name_fixed, group_name);
                p_values(i) = run_single_simulation(simTbl, lme_base.Formula, coeff_name);
            end
        end

        significant_count = sum(p_values < alpha);
        current_power = significant_count / num_simulations;
        power_curve_data = [power_curve_data; test_effect_size, current_power];

        fprintf('  Effect Size: %.3f  -->  Power: %.2f%%\n', test_effect_size, current_power*100);
    end

    mdes = test_effect_size;
    power_curve = array2table(power_curve_data, 'VariableNames', {'EffectSize', 'Power'});

    fprintf('\n--- Search Finished ---\n');
    fprintf('Minimum Detectable Effect Size (MDES) for %.0f%% power is: %.4f\n', target_power*100, mdes);
end

function p_value = run_single_simulation(simTbl, formula, coeff_name)
    % Runs a single LME fit and extracts the p-value for the coefficient of interest.
    % Returns a p-value of 1 if the model cannot be fit (e.g., due to rank deficiency).

    % Check for rank deficiency before fitting
    unique_conditions = unique(simTbl.(formula.ResponseName));
    if numel(unique_conditions) < 2
        p_value = 1;
        return;
    end

    try
        lme_sim = fitlme(simTbl, formula.char);
        coeff_idx_sim = find(strcmp(lme_sim.Coefficients.Name, coeff_name));
        if ~isempty(coeff_idx_sim)
            p_value = lme_sim.Coefficients.pValue(coeff_idx_sim);
        else
            p_value = 1; % Coefficient not found, cannot reject null
        end
    catch ME
        if strcmp(ME.identifier, 'stats:fitlme:RankDeficient')
            p_value = 1; % Treat rank-deficient fits as non-significant
        else
            rethrow(ME); % Rethrow other errors
        end
    end
end
