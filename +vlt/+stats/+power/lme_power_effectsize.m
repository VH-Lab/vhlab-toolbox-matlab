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
        disp('Post-hoc mode: Using full model with coefTest for post-hoc comparison.');
        primary_category = categories_name{1}; % The main variable of interest

    else
        % Original main effect mode
        if iscell(categories_name)
            primary_category = categories_name{1};
        else
            primary_category = categories_name;
        end
    end

    trim_opt = isempty(options.ShufflePredictor);
    [lme_base, tbl_base] = vlt.stats.lme_category(tbl, categories_name, y_name, '', reference_category, group_name, 0, 0, 'TrimTable', trim_opt);

    y_name_fixed = 'Y_data_for_fit'; % This is now the fixed response variable name

    if options.EffectStep == -1
        options.EffectStep = std(tbl_base.(y_name_fixed), 'omitnan') / 50;
        fprintf('Using a search step size of %.3f\n', options.EffectStep);
    end

    fprintf('Searching for effect size that yields %.0f%% power...\n', target_power*100);

    current_power = 0;
    test_effect_size = 0;
    power_curve_data = [];

    use_parallel = ~isempty(ver('parallel'));
    if use_parallel
        fprintf('Parallel Computing Toolbox detected. Using parfor for simulations.\n');
    end

    sim_func = vlt.stats.power.getLMESimFunc(options.Method, 'ShufflePredictor', options.ShufflePredictor, 'InteractionFields', interaction_fields);
    alpha = options.Alpha;
    num_simulations = options.NumSimulations;

    while current_power < target_power
        test_effect_size = test_effect_size + options.EffectStep;

        p_values = ones(num_simulations, 1);
        sim_loop = 1:num_simulations;

        if use_parallel
            parfor i = sim_loop
                simTbl = sim_func(lme_base, tbl_base, test_effect_size, primary_category, category_to_test, y_name_fixed, group_name);
                p_values(i) = run_single_simulation(simTbl, lme_base.Formula, reference_category, category_to_test);
            end
        else % Regular for loop
            for i = sim_loop
                simTbl = sim_func(lme_base, tbl_base, test_effect_size, primary_category, category_to_test, y_name_fixed, group_name);
                p_values(i) = run_single_simulation(simTbl, lme_base.Formula, reference_category, category_to_test);
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

function p_value = run_single_simulation(simTbl, formula, ref_group, test_group)
    % Runs a single LME fit and extracts the p-value.

    try
        % --- DEBUG START ---
        fprintf('[DEBUG] Fitting LME model with formula: %s\n', formula.char);
        % --- DEBUG END ---

        lme_sim = fitlme(simTbl, formula.char);

        % --- DEBUG START ---
        fprintf('[DEBUG] Model fit complete. Coefficient names:\n');
        disp(lme_sim.Coefficients.Name);
        % --- DEBUG END ---

        if isstruct(ref_group)
            % Post-hoc mode: use coefTest
            p_value = vlt.stats.power.posthoc_coef_test(lme_sim, ref_group, test_group);
        else
            % Main effect mode: find coefficient p-value directly
            predictor_name = formula.PredictorNames{1};

            % Robustly find the coefficient name
            all_coeffs = lme_sim.Coefficients.Name;

            % Find the index of the coefficient that starts with the predictor name
            % and contains the test group name. This is robust to whether fitlme
            % uses an underscore or not.
            idx = find(startsWith(all_coeffs, predictor_name) & contains(all_coeffs, test_group));

            % --- DEBUG START ---
            fprintf('[DEBUG]   Searching for coefficient starting with "%s" and containing "%s"\n', predictor_name, test_group);
            % --- DEBUG END ---

            if ~isempty(idx)
                coeff_name = all_coeffs{idx};
                p_value = lme_sim.Coefficients.pValue(idx);
                % --- DEBUG START ---
                fprintf('[DEBUG]   Coefficient "%s" found. p-value: %.4f\n', coeff_name, p_value);
                % --- DEBUG END ---
            else
                p_value = 1; % Coefficient not found, cannot reject null
                % --- DEBUG START ---
                fprintf('[DEBUG]   WARNING: Coefficient not found. Defaulting p-value to 1.\n');
                % --- DEBUG END ---
            end
        end
    catch ME
        if strcmp(ME.identifier, 'stats:fitlme:RankDeficient')
            p_value = 1; % Treat rank-deficient fits as non-significant
            % --- DEBUG START ---
            fprintf('[DEBUG]   WARNING: Model fit was rank-deficient. Defaulting p-value to 1.\n');
            % --- DEBUG END ---
        else
            rethrow(ME); % Rethrow other errors
        end
    end
end
