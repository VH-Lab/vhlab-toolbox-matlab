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
    end

    disp('Fitting baseline model to original data...');
    [lme_base, tbl_base] = vlt.stats.lme_category(tbl, categories_name, y_name, '', reference_category, group_name, 0, 0);

    y_name_fixed = lme_base.ResponseName;

    if options.EffectStep == -1
        options.EffectStep = std(tbl_base.(y_name_fixed)) / 50;
        fprintf('Using a search step size of %.3f\n', options.EffectStep);
    end

    fprintf('Searching for effect size that yields %.0f%% power...\n', target_power*100);

    current_power = 0;
    test_effect_size = 0;
    power_curve_data = [];

    % Determine the primary category for testing
    if iscell(categories_name)
        primary_category = categories_name{1};
    else
        primary_category = categories_name;
    end

    % Programmatically find the exact coefficient name from the baseline model
    % This is the most robust way to handle spaces or special characters.
    all_coeffs = lme_base.CoefficientNames;
    % Find the coefficient that contains the category to test, but is not the intercept
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

    sim_func = vlt.stats.power.getLMESimFunc(options.Method);
    alpha = options.Alpha;
    num_simulations = options.NumSimulations;

    while current_power < target_power
        test_effect_size = test_effect_size + options.EffectStep;

        significant_count = 0;
        sim_loop = 1:num_simulations;

        if use_parallel
            parfor i = sim_loop
                simTbl = sim_func(lme_base, tbl_base, test_effect_size, primary_category, category_to_test, y_name_fixed, group_name);
                lme_sim = fitlme(simTbl, lme_base.Formula.char);

                coeff_idx_sim = find(strcmp(lme_sim.Coefficients.Name, coeff_name));
                p_value = 1;
                if ~isempty(coeff_idx_sim), p_value = lme_sim.Coefficients.pValue(coeff_idx_sim); end
                if p_value < alpha, significant_count = significant_count + 1; end
            end
        else % Regular for loop
            for i = sim_loop
                simTbl = sim_func(lme_base, tbl_base, test_effect_size, primary_category, category_to_test, y_name_fixed, group_name);
                lme_sim = fitlme(simTbl, lme_base.Formula.char);

                coeff_idx_sim = find(strcmp(lme_sim.Coefficients.Name, coeff_name));
                p_value = 1;
                if ~isempty(coeff_idx_sim), p_value = lme_sim.Coefficients.pValue(coeff_idx_sim); end
                if p_value < alpha, significant_count = significant_count + 1; end
            end
        end

        current_power = significant_count / num_simulations;
        power_curve_data = [power_curve_data; test_effect_size, current_power];

        fprintf('  Effect Size: %.3f  -->  Power: %.2f%%\n', test_effect_size, current_power*100);
    end

    mdes = test_effect_size;
    power_curve = array2table(power_curve_data, 'VariableNames', {'EffectSize', 'Power'});

    fprintf('\n--- Search Finished ---\n');
    fprintf('Minimum Detectable Effect Size (MDES) for %.0f%% power is: %.4f\n', target_power*100, mdes);
end
