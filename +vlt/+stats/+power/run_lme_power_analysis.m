function [mdes, power_curve] = run_lme_power_analysis(tbl, categories_name, y_name, reference_category, group_name, category_to_test, target_power, options)
% VLT.STATS.POWER.RUN_LME_POWER_ANALYSIS - Calculate power for a Linear Mixed-Effects model.
%
%   Calculates statistical power for a Linear Mixed-Effects (LME) model by simulation. This
%   function is designed to find the Minimum Detectable Effect Size (MDES) for a specified
%   target power. Along the way, it generates a full power curve, showing the statistical
%   power for a range of different effect sizes.
%
%   This function is particularly useful for repeated-measures or nested designs, where
%   observations are not independent (e.g., multiple measurements from the same subject).
%
%   SYNTAX:
%   [mdes, power_curve] = vlt.stats.power.run_lme_power_analysis(tbl, categories_name, ...
%       y_name, reference_category, group_name, category_to_test, target_power, options)
%
%   INPUTS:
%   tbl - A MATLAB table containing the data.
%
%   categories_name - The name of the table column that contains the primary categorical
%       variable you want to test (a fixed effect). E.g., 'Condition'.
%
%   y_name - The name of the table column that contains the continuous response variable.
%       E.g., 'Data'.
%
%   reference_category - One of the values from the 'categories_name' column that should
%       be treated as the baseline or control group. The effect size will be added to the
%       'category_to_test' group for comparison against this reference.
%
%   group_name - The name of the table column that identifies the source of repeated
%       measures, which will be modeled as a random effect. E.g., 'Animal' or 'SubjectID'.
%
%   category_to_test - The value from the 'categories_name' column that should be
%       treated as the experimental group. During the simulation, the hypothetical
%       effect size will be added to this group's data.
%
%   target_power - The desired statistical power (e.g., 0.80 for 80% power). The
%       function's primary output, 'mdes', is the effect size required to achieve this power.
%
%   OPTIONAL NAME-VALUE PAIRS:
%   'Alpha' - The significance level for the statistical test (default: 0.05).
%
%   'NumSimulations' - The number of simulations to run for each point on the power
%       curve (default: 500). Higher numbers increase accuracy but take longer.
%
%   'EffectStep' - The step size to use when searching for the MDES. If set to -1
%       (default), the function automatically determines a reasonable step size based
%       on the data's standard deviation.
%
%   'Method' - The simulation method for generating surrogate data. Can be 'gaussian'
%       (fastest, assumes normal residuals), 'shuffle' (non-parametric), or
%       'hierarchical' (for nested data structures). Default is 'gaussian'.
%
%   OUTPUTS:
%   mdes - The Minimum Detectable Effect Size. This is the magnitude of the change in
%       'y_name' that you can detect with the specified 'target_power'.
%
%   power_curve - A table containing the data used to generate the power curve plot,
%       with two columns: 'EffectSize' and 'Power'. This is useful for finding the
%       statistical power for a specific, hypothetical effect size.
%
%   EXAMPLE FOR A REPEATED-MEASURES DESIGN:
%   % Imagine an experiment where different animals are assigned to one of two
%   % conditions ('XPro' or 'No-Xpro'), and each animal is measured on
%   % multiple days ('Hunting_day').
%
%   % Create a sample data table
%   t = table(...
%       repmat([1:8, 9:17]', 4, 1), ... % Animal IDs
%       repelem({'Hunting XPro', 'Hunting No-Xpro'}', [32; 36]), ... % Condition
%       repmat([1; 2; 3; 6], 17, 1), ... % Hunting_day
%       randn(68, 1) * 15 + 50, ... % Simulated Data
%       'VariableNames', {'Animal', 'Condition', 'Hunting_day', 'Data'});
%
%   % Define the parameters for the power analysis
%   categories_name = 'Condition';
%   y_name = 'Data';
%   reference_category = 'Hunting No-Xpro'; % Control group
%   group_name = 'Animal';                 % Subject ID (random effect)
%   category_to_test = 'Hunting XPro';   % Experimental group
%   target_power = 0.80;                   % Target power of 80%
%
%   % Run the analysis
%   [mdes, power_curve] = vlt.stats.power.run_lme_power_analysis(t, ...
%       categories_name, y_name, reference_category, group_name, ...
%       category_to_test, target_power, 'NumSimulations', 500);
%
%   % Display the results
%   fprintf('The Minimum Detectable Effect Size for 80%% power is: %.3f\n', mdes);
%   disp('Full Power Curve Data:');
%   disp(power_curve);
%
%   % To find the power to detect a specific effect size (e.g., 20):
%   [~, idx] = min(abs(power_curve.EffectSize - 20));
%   fprintf('Power to detect an effect of %.2f is ~%.2f%%\n', ...
%       power_curve.EffectSize(idx), power_curve.Power(idx) * 100);

    % --- 1. Argument Handling and Data Preparation ---
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

    if any(ismissing(tbl))
        disp('Missing data detected. Removing rows with NaNs to proceed.');
        tbl = rmmissing(tbl);
        fprintf('Table size reduced to %d rows.\n', height(tbl));
    end

    % --- 2. Run the Core Power Analysis ---
    fprintf('\n--- Starting LME Power Analysis ---\n');
    fprintf('Simulation Method: %s\n', upper(options.Method));
    fprintf('Target Power: %.0f%%\n', target_power * 100);
    fprintf('Category to Test: %s (Reference: %s)\n', category_to_test, reference_category);
    fprintf('Simulations per Step: %d\n\n', options.NumSimulations);

    [mdes, power_curve] = vlt.stats.power.lme_power_effectsize(tbl, categories_name, y_name, ...
        reference_category, group_name, category_to_test, target_power, ...
        'Method', options.Method, ...
        'Alpha', options.Alpha, ...
        'NumSimulations', options.NumSimulations, ...
        'EffectStep', options.EffectStep);

    % --- 3. Visualize the Results ---
    disp('Generating power curve plot...');

    figure_name_str = ['LME Power Analysis (' char(upper(options.Method)) ')'];
    f = figure('Name', figure_name_str, 'NumberTitle', 'off', 'Visible', 'off');
    plot(power_curve.EffectSize, power_curve.Power * 100, '-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    hold on;

    yline(target_power * 100, '--r', sprintf('%.0f%% Power', target_power*100), 'LineWidth', 1.5, 'LabelVerticalAlignment', 'bottom');
    xline(mdes, '--r', sprintf('MDES = %.3g', mdes), 'LineWidth', 1.5, 'LabelVerticalAlignment', 'middle', 'LabelHorizontalAlignment', 'left');

    xlabel(['Hypothetical Effect Size (in units of ' strrep(y_name, '_', '\_') ')']);
    ylabel('Statistical Power (%)');
    title_str = sprintf('Power Curve for %s = ''%s'' (%s method)', strrep(categories_name, '_', '\_'), category_to_test, options.Method);
    title(title_str);
    grid on;
    ylim([0 105]);
    xlim([0, mdes * 1.25]);
    hold off;

    fprintf('\n--- Analysis Complete ---\n\n');
end
