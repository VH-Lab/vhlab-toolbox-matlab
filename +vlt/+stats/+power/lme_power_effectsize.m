function [mdes, power_curve] = lme_power_effectsize(tbl, categories_name, y_name, reference_category, group_name, category_to_test, target_power, options)
% LME_POWER_EFFECTSIZE - Finds the minimum detectable effect size (MDES) via simulation.
%
%   This is the core worker function for the power analysis toolkit. It
%   systematically searches for the smallest effect size that can be
%   detected with a specified statistical power (the MDES).
%
%   ... (documentation unchanged) ...
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

    disp('Fitting baseline model to original data...');
    % The lme_category function prepares the table and creates the 'Y_data_for_fit' column
    [lme_base, tbl_base] = vlt.stats.lme_category(tbl, categories_name, y_name, 'Y', reference_category, group_name, 0, 0);

    if options.EffectStep == -1
        % Base the step size on the standard deviation of the actual data being modeled
        options.EffectStep = std(tbl_base.Y_data_for_fit) / 50;
        fprintf('Using a search step size of %.3f\n', options.EffectStep);
    end

    fprintf('Searching for effect size that yields %.0f%% power...\n', target_power*100);

    current_power = 0;
    test_effect_size = 0;
    power_curve_data = [];

    % Determine the coefficient name to look for in the simulation models
    primary_category = categories_name;
    if iscell(primary_category), primary_category = primary_category{1}; end
    coeff_name = [primary_category '_' category_to_test];

    use_parallel = ~isempty(ver('parallel'));
    if use_parallel
        fprintf('Parallel Computing Toolbox detected. Using parfor for simulations.\n');
    end

    sim_func = vlt.stats.power.getLMESimFunc(options.Method);

    % Define the name of the column that the model is actually fitting and that
    % the effect size should be added to. This is the critical fix.
    data_col_for_sim = 'Y_data_for_fit';

    while current_power < target_power
        test_effect_size = test_effect_size + options.EffectStep;

        significant_count = 0;
        sim_loop = 1:options.NumSimulations;

        if use_parallel
            parfor i = sim_loop
                simTbl = sim_func(lme_base, tbl_base, test_effect_size, primary_category, category_to_test, data_col_for_sim, group_name);
                lme_sim = fitlme(simTbl, lme_base.Formula.char);

                coeff_idx = find(strcmp(lme_sim.Coefficients.Name, coeff_name));
                if ~isempty(coeff_idx) && lme_sim.Coefficients.pValue(coeff_idx) < options.Alpha
                    significant_count = significant_count + 1;
                end
            end
        else % Regular for loop
            for i = sim_loop
                simTbl = sim_func(lme_base, tbl_base, test_effect_size, primary_category, category_to_test, data_col_for_sim, group_name);
                lme_sim = fitlme(simTbl, lme_base.Formula.char);

                coeff_idx = find(strcmp(lme_sim.Coefficients.Name, coeff_name));
                if ~isempty(coeff_idx) && lme_sim.Coefficients.pValue(coeff_idx) < options.Alpha
                    significant_count = significant_count + 1;
                end
            end
        end

        current_power = significant_count / options.NumSimulations;
        power_curve_data = [power_curve_data; test_effect_size, current_power];

        fprintf('  Effect Size: %.3f  -->  Power: %.2f%%\n', test_effect_size, current_power*100);
    end

    mdes = test_effect_size;
    power_curve = array2table(power_curve_data, 'VariableNames', {'EffectSize', 'Power'});

    fprintf('\n--- Search Finished ---\n');
    fprintf('Minimum Detectable Effect Size (MDES) for %.0f%% power is: %.4f\n', target_power*100, mdes);
end
