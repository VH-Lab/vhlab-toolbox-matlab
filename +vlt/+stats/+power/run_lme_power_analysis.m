function [mdes, power_curve] = run_lme_power_analysis(tbl, categories_name, y_name, reference_category, group_name, category_to_test, target_power, options)
% VLT.STATS.POWER.RUN_LME_POWER_ANALYSIS - Calculate power for a Linear Mixed-Effects model.
%
%   Calculates statistical power for a Linear Mixed-Effects (LME) model by simulation. This
%   function is designed to find the Minimum Detectable Effect Size (MDES) for a specified
%   target power. Along the way, it generates a full power curve, showing the statistical
%   power for a range of different effect sizes.
%
%   This function is particularly useful for repeated-measures, multi-factor, or nested designs,
%   where observations are not independent (e.g., multiple measurements from the same subject).
%
%   SYNTAX:
%   [mdes, power_curve] = vlt.stats.power.run_lme_power_analysis(tbl, categories_name, ...
%       y_name, reference_category, group_name, category_to_test, target_power, options)
%
%   INPUTS:
%   tbl - A MATLAB table containing the data. All columns for the model must be present.
%
%   categories_name - The name(s) of the table column(s) that contain the categorical
%       fixed effects. This can be a single string (e.g., 'Condition') for a simple
%       design, or a cell array of strings (e.g., {'Condition', 'TimePoint'}) for
%       multi-factor designs. The function will build the model formula automatically.
%       **The first entry in the cell array is always treated as the primary variable of
%       interest for which power is being calculated.**
%
%   y_name - The name of the table column that contains the continuous response variable.
%       E.g., 'Measurement' or 'Score'.
%
%   reference_category - A value from the primary 'categories_name' column that should
%       be treated as the baseline or control group.
%
%   group_name - The name of the table column that identifies the source of repeated
%       measures, which will be modeled as a random effect. E.g., 'Animal' or 'SubjectID'.
%
%   category_to_test - The value from the primary 'categories_name' column that
%       should be treated as the experimental group. The hypothetical effect size will be
%       added to this group's data during the simulation.
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
%       (fastest, assumes normal residuals) or 'shuffle' (non-parametric, more robust).
%       Default is 'gaussian'.
%
%   'ShufflePredictor' - (Default: '') As an advanced alternative to the standard 'shuffle'
%       method (which shuffles the response variable), you can provide the name of a
%       predictor column to shuffle here (e.g., 'condition_name'). This simulates the
%       null hypothesis by breaking the relationship between that predictor and the
%       response, while preserving the exact data distribution within each condition.
%       This can prevent rank deficiency errors in highly unbalanced datasets. If a
%       column name is provided here, it overrides the 'Method' setting.
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
%   % An experiment where animals are in one of two Conditions and are measured on multiple Days.
%   % We want to find the power to detect a difference between Conditions, while accounting
%   % for the variability across animals and days.
%
%   t = table(...
%       repmat([1:8, 9:17]', 4, 1), ... % Animal IDs
%       repelem({'XPro', 'No-Xpro'}', [32; 36]), ... % Condition
%       repmat(categorical([1; 2; 3; 6]), 17, 1), ... % Hunting_day
%       randn(68, 1) * 15 + 50, ... % Simulated Data
%       'VariableNames', {'Animal', 'Condition', 'Hunting_day', 'Data'});
%
%   [mdes, power_curve] = vlt.stats.power.run_lme_power_analysis(t, ...
%       {'Condition', 'Hunting_day'}, ... % << Specify both fixed effects here
%       'Data', ...
%       'No-Xpro', ...                   % Reference for the primary category ('Condition')
%       'Animal', ...                    % Random effect
%       'XPro', ...                      % Category to test
%       0.80, ...                        % Target power
%       'Method', 'shuffle');
%
%   fprintf('The Minimum Detectable Effect Size for 80%% power is: %.3f\n', mdes);
%   disp(power_curve);
%
    % --- 1. Argument Handling and Data Preparation ---
    arguments
        tbl table
        categories_name
        y_name {mustBeTextScalar}
        reference_category {mustBeTextScalar}
        group_name {mustBeTextScalar}
        category_to_test {mustBeTextScalar}
        target_power (1,1) double
        options.Alpha (1,1) double = 0.05
        options.NumSimulations (1,1) double = 500
        options.EffectStep (1,1) double = -1
        options.Method (1,1) string {mustBeMember(options.Method,{'gaussian','shuffle','hierarchical'})} = 'gaussian'
        options.plot (1,1) logical = true
        options.ShufflePredictor {mustBeTextScalar} = ''
    end

    if any(ismissing(tbl))
        disp('Missing data detected. Removing rows with NaNs to proceed.');
        tbl = rmmissing(tbl);
        fprintf('Table size reduced to %d rows.\n', height(tbl));
    end

    % --- 2. Run the Core Power Analysis ---
    fprintf('\n--- Starting LME Power Analysis ---\n');
    if ~isempty(options.ShufflePredictor)
        fprintf('Simulation Method: SHUFFLE PREDICTOR (''%s'')\n', options.ShufflePredictor);
    else
        fprintf('Simulation Method: %s\n', upper(options.Method));
    end
    fprintf('Target Power: %.0f%%\n', target_power * 100);

    primary_category = categories_name;
    if iscell(primary_category), primary_category = primary_category{1}; end
    fprintf('Category to Test: %s (Reference: %s)\n', category_to_test, reference_category);

    fprintf('Simulations per Step: %d\n\n', options.NumSimulations);

    [mdes, power_curve] = vlt.stats.power.lme_power_effectsize(tbl, categories_name, y_name, ...
        reference_category, group_name, category_to_test, target_power, ...
        'Method', options.Method, ...
        'Alpha', options.Alpha, ...
        'NumSimulations', options.NumSimulations, ...
        'EffectStep', options.EffectStep, ...
        'ShufflePredictor', options.ShufflePredictor);

    % --- 3. Visualize the Results ---
    if options.plot
        disp('Generating power curve plot...');

        figure_name_str = ['LME Power Analysis (' char(upper(options.Method)) ')'];
        f = figure('Name', figure_name_str, 'NumberTitle', 'off');
        plot(power_curve.EffectSize, power_curve.Power * 100, '-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
        hold on;

        yline(target_power * 100, '--r', sprintf('%.0f%% Power', target_power*100), 'LineWidth', 1.5, 'LabelVerticalAlignment', 'bottom');
        xline(mdes, '--r', sprintf('MDES = %.3g', mdes), 'LineWidth', 1.5, 'LabelVerticalAlignment', 'middle', 'LabelHorizontalAlignment', 'left');

        xlabel(['Hypothetical Effect Size (in units of ' strrep(y_name, '_', '\_') ')']);
        ylabel('Statistical Power (%)');
        title_str = sprintf('Power Curve for %s = ''%s'' (%s method)', strrep(primary_category, '_', '\_'), category_to_test, options.Method);
        title(title_str);
        grid on;
        ylim([0 105]);
        xlim([0, max(mdes * 1.25, eps)]);
        hold off;
    end

    fprintf('\n--- Analysis Complete ---\n\n');
end
