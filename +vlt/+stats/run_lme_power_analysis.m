function [mdes, power_curve] = run_lme_power_analysis(tbl, categories_name, y_name, reference_category, group_name, category_to_test, target_power, options)
% RUN_LME_POWER_ANALYSIS - A pipeline to calculate and visualize the minimum detectable effect size (MDES).
%
%   This is the main function to call for the power analysis.
%
%   Example (Hierarchical Method):
%       load carsmall;
%       tbl = table(Mfg, Model_Year, MPG);
%       [mdes, ~] = vlt.stats.run_lme_power_analysis(tbl, 'Model_Year', 'MPG', '70', ...
%           'Mfg', '76', 0.80, 'Method', 'hierarchical', 'NumSimulations', 250);
%
%   Example (Gaussian Method):
%       load carsmall;
%       tbl = table(Mfg, Model_Year, MPG);
%       [mdes, ~] = vlt.stats.run_lme_power_analysis(tbl, 'Model_Year', 'MPG', '70', ...
%           'Mfg', '76', 0.80, 'Method', 'gaussian');

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

    [mdes, power_curve] = vlt.stats.lme_power_effectsize(tbl, categories_name, y_name, ...
        reference_category, group_name, category_to_test, target_power, ...
        'Method', options.Method, ...
        'Alpha', options.Alpha, ...
        'NumSimulations', options.NumSimulations, ...
        'EffectStep', options.EffectStep);

    % --- 3. Visualize the Results ---
    disp('Generating power curve plot...');

    f = figure('Name', ['LME Power Analysis (' upper(options.Method) ')'], 'NumberTitle', 'off', 'Visible', 'off');
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
