function [mdes, power_curve] = lme_power_effectsize(tbl, categories_name, y_name, reference_category, group_name, category_to_test, target_power, options)
% LME_POWER_EFFECTSIZE - Finds the minimum detectable effect size (MDES) via simulation.
%
%   This is the core worker function for the power analysis toolkit. It
%   systematically searches for the smallest effect size that can be
%   detected with a specified statistical power (the MDES).
%
%   Process:
%   1.  A baseline linear mixed-effects model is fit to the actual data to
%       extract its variance components (random effects and residual error).
%   2.  The function enters a loop, starting with a small hypothetical
%       effect size.
%   3.  In each loop iteration, it runs hundreds or thousands of simulations.
%       Each simulation generates a new dataset with the same noise
%       characteristics as the real data but with the current hypothetical
%       effect "injected" into the specified category.
%   4.  An LME model is fit to each simulated dataset, and the function
%       checks if the p-value for the effect is significant (e.g., < 0.05).
%   5.  The statistical power for the current effect size is calculated as
%       the proportion of simulations that yielded a significant result.
%   6.  If the calculated power is less than the `target_power`, the effect
%       size is increased, and the loop repeats.
%   7.  The loop terminates when the `target_power` is achieved, and the
%       effect size from that iteration is returned as the MDES.
%
%   Inputs:
%       tbl              - The input data table.
%       categories_name  - String name of the column with fixed-effect categories.
%       y_name           - String name of the response variable column.
%       reference_category - String name of the category to use as a baseline.
%       group_name       - String name of a column for the random-effects grouping.
%       category_to_test - String name of the specific category to test.
%       target_power     - The desired statistical power (e.g., 0.80 for 80%).
%
%   Name-Value Options:
%       'Alpha'          - The significance level (p-value threshold). Default is 0.05.
%       'NumSimulations' - The number of simulations to run at each step of the
%                          effect-size search. More simulations lead to more
%                          stable estimates but take longer. Default is 500.
%       'EffectStep'     - The amount to increase the effect size at each
%                          step of the search. If not specified (-1), it is
%                          auto-calculated based on the data's standard deviation.
%       'Method'         - The simulation method to use: 'gaussian', 'shuffle',
%                          or 'hierarchical'. Default is 'gaussian'.
%
%   Outputs:
%       mdes        - The minimum detectable effect size for the target power.
%       power_curve - A table containing the results of the search, with
%                     columns 'EffectSize' and 'Power'. This is useful for
%                     plotting how power changes with effect size.
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
    [lme_base, tbl_base] = vlt.stats.lme_category(tbl, categories_name, y_name, 'Y', reference_category, group_name, 0, 0);

    y_name_fixed = strrep(y_name,'.','__');

    if options.EffectStep == -1
        options.EffectStep = std(tbl_base.(y_name_fixed)) / 50;
        fprintf('Using a search step size of %.3f\n', options.EffectStep);
    end

    fprintf('Searching for effect size that yields %.0f%% power...\n', target_power*100);

    current_power = 0;
    test_effect_size = 0;
    power_curve_data = [];
    coeff_name = [categories_name '_' category_to_test];

    use_parallel = ~isempty(ver('parallel'));
    if use_parallel
        fprintf('Parallel Computing Toolbox detected. Using parfor for simulations.\n');
    end

    while current_power < target_power
        test_effect_size = test_effect_size + options.EffectStep;

        significant_count = 0;
        sim_loop = 1:options.NumSimulations;

        if use_parallel
            parfor i = sim_loop
                simTbl = feval(vlt.stats.getLMESimFunc(options.Method), lme_base, tbl_base, test_effect_size, categories_name, category_to_test, y_name_fixed, group_name);
                lme_sim = fitlme(simTbl, lme_base.Formula.char);
                p_value = lme_sim.Coefficients.pValue(coeff_name);
                if p_value < options.Alpha
                    significant_count = significant_count + 1;
                end
            end
        else % Regular for loop
            for i = sim_loop
                simTbl = feval(vlt.stats.getLMESimFunc(options.Method), lme_base, tbl_base, test_effect_size, categories_name, category_to_test, y_name_fixed, group_name);
                lme_sim = fitlme(simTbl, lme_base.Formula.char);
                p_value = lme_sim.Coefficients.pValue(coeff_name);
                if p_value < options.Alpha
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
