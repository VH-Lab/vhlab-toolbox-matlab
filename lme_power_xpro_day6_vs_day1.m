function [mdes, power_curve] = lme_power_xpro_day6_vs_day1(t, options)
% LME_POWER_XPRO_DAY6_VS_DAY1 - Power analysis for a specific cross-condition comparison.
%
%   [mdes, power_curve] = LME_POWER_XPRO_DAY6_VS_DAY1(t, options)
%
%   This function runs a highly specific LME power analysis. It simulates the
%   null hypothesis by shuffling the main 'Condition' effect, but calculates
%   power for a specific post-hoc comparison:
%       'Hunting XPro' on Day 6   vs.   'Hunting No-Xpro' on Day 1.
%
%   This answers the question: "If there is no overall effect of Condition,
%   what is our power to detect a specific difference between Day 6 of the
%   experiment and Day 1 of the control?"
%
%   INPUTS:
%   t - The input data table. It must contain 'Condition', 'Hunting_day', etc.
%
%   OPTIONAL NAME-VALUE PAIRS:
%   'target_power' (0.80) - The desired statistical power.
%   'plot' (true)         - Whether to generate the power curve plot.
%   'NumSimulations' (500)- The number of simulations to run per step.
%

    arguments
        t table
        options.target_power (1,1) double = 0.80
        options.plot (1,1) logical = true
        options.NumSimulations (1,1) double = 500
    end

    % --- Data Sanitization ---
    % Clean the table of any non-breaking spaces that can cause issues with string comparisons
    t = vlt.table.nonbsp(t);

    % --- 1. Define the parameters for the LME model ---
    % The model itself still accounts for both main factors.
    categories_name = {'Condition', 'Hunting_day'};
    y_name = 'Data';
    group_name = 'Animal';

    % --- 2. Define the specific post-hoc comparison using structs ---
    % This is the core of the request. We define the exact multi-factor
    % groups we want to compare.
    reference_category = struct('Condition', 'Hunting No-Xpro', 'Hunting_day', 1);
    category_to_test   = struct('Condition', 'Hunting XPro',    'Hunting_day', 6);

    % --- 3. Run the LME power analysis ---
    % We use 'ShufflePredictor' to shuffle ONLY the 'Condition' column,
    % while the test itself is performed on the more specific struct comparison.
    [mdes, power_curve] = vlt.stats.power.run_lme_power_analysis( ...
        t, ...
        categories_name, ...
        y_name, ...
        reference_category, ... % << Pass the struct here
        group_name, ...
        category_to_test, ...   % << Pass the struct here
        options.target_power, ...
        'ShufflePredictor', 'Condition', ... % << The key step for the simulation
        'plot', options.plot, ...
        'NumSimulations', options.NumSimulations ...
    );

    % --- 4. View the results ---
    fprintf('POST-HOC TEST: ''Hunting XPro Day 6'' vs. ''Hunting No-Xpro Day 1''\n');
    fprintf('The Minimum Detectable Effect Size for %.0f%% power is: %.3f\n', options.target_power*100, mdes);
    disp('Full Power Curve Data:');
    disp(power_curve);

end
