function run_lme_power_analysisValidation(options)
% RUN_LME_POWER_ANALYSISVALIDATION - Validate the LME power analysis against analytical results
%
%   vlt.stats.power.run_lme_power_analysisValidation
%
%   Validates the simulation-based power curve from vlt.stats.power.run_lme_power_analysis
%   against the analytical solution for a simple 1-way ANOVA case provided by
%   vlt.stats.power.calculateTukeyPairwisePower.
%
%   It performs the following steps:
%   1. Creates a simple, balanced 1-way ANOVA dataset using vlt.stats.artificialAnovaTable.
%   2. Calls `run_lme_power_analysis` to generate a simulated power curve across a
%      range of effect sizes.
%   3. For each effect size tested in the simulation, it calculates the corresponding
%      theoretical power using the analytical Tukey HSD power formula.
%   4. Plots the simulated power curve (blue circles) and the theoretical power
%      curve (red line) on the same axes for visual comparison.
%   5. Displays a table comparing the simulated and analytical power values.
%
%   See also: vlt.stats.power.anovaposthocValidation
%
%   Optional Name-Value Pairs:
%   'numShuffles' - The number of shuffles for the simulation (default 1000).
%                   Higher numbers give more precise results but take longer.
%   'alpha'       - The significance level (default 0.05).
%
arguments
    options.numShuffles (1,1) double {mustBeInteger, mustBeGreaterThan(options.numShuffles, 0)} = 1000;
    options.alpha (1,1) double {mustBeGreaterThan(options.alpha, 0), mustBeLessThan(options.alpha, 1)} = 0.05;
end

% --- Step 1: Define the experimental parameters and create the data table ---
% Parameters for a simple 1-way ANOVA design with 3 groups
factorNames = {'Group'};
factorLevels = [3];
nPerGroup_gen = 10;
SD_Residual = 2.0;
SD_RandomIntercept = 0; % No subject-specific random effect for this simple case

% The SD_Components struct is required by the generation function
SD_Components = struct('RandomIntercept', SD_RandomIntercept, 'Residual', SD_Residual);

% Generate a baseline data table with NO difference added yet.
[dataTable, powerParamsFromGen] = vlt.stats.artificialAnovaTable(factorNames, factorLevels, nPerGroup_gen, ...
    0, [1], SD_Components); % Start with difference = 0

% --- Get Parameters for Analytical Calculation FROM the Generator Output ---
powerParamsFromGen.alpha = options.alpha; % Use the alpha passed to this function
dataTable.Properties.VariableNames{2} = 'Y'; % Rename for compatibility
alpha = powerParamsFromGen.alpha;

% --- Step 2: Run the simulation-based power analysis to get the power curve ---
fprintf('\nRunning simulation-based LME power analysis...\n');

% Get group names for the function call
group_names = unique(dataTable.Group);
reference_category = char(group_names(1));
category_to_test = char(group_names(end));

% We must provide a target_power, but we are interested in the whole curve, not the final MDES.
% The function will still calculate it, but we will ignore it.
targetPowerForFunc = 0.80;

[~, power_curve] = vlt.stats.power.run_lme_power_analysis(dataTable, 'Group', 'Y', ...
    reference_category, 'Group', category_to_test, targetPowerForFunc, ...
    'Alpha', alpha, ...
    'NumSimulations', options.numShuffles, ...
    'Method', 'shuffle', ...
    'EffectStep', 0.5); % Use a fixed step size for a clean curve

simulated_power = power_curve.Power;
effect_sizes = power_curve.EffectSize;

fprintf('  Simulation complete.\n');

% --- Step 3: Calculate the corresponding analytical power for each effect size ---
fprintf('Calculating theoretical power curve...\n');

% Extract parameters for the analytical calculation
k = powerParamsFromGen.kTotalGroups;
n = powerParamsFromGen.nPerGroup;
mse = powerParamsFromGen.expectedMSE;

analytical_power = nan(size(effect_sizes));
for i=1:numel(effect_sizes)
    d = effect_sizes(i);
    analytical_power(i) = vlt.stats.power.calculateTukeyPairwisePower(d, mse, n, k, alpha, 'method', 'cdfTukey');
end

% --- Step 4: Display Comparison Table ---
fprintf('\nValidation Results Table:\n');
resultsTable = table(effect_sizes, simulated_power, analytical_power, ...
    'VariableNames', {'EffectSize', 'SimulatedPower', 'AnalyticalPower'});
disp(resultsTable);

% --- Step 5: Plot the results ---
figure;
hold on;
plot(effect_sizes, simulated_power, 'bo', 'MarkerFaceColor', 'b', 'DisplayName', 'Simulated (run_lme_power_analysis)');
plot(effect_sizes, analytical_power, 'r-', 'LineWidth', 2, 'DisplayName', 'Theoretical (Tukey HSD)');
yline(alpha, 'k--', 'DisplayName', ['Alpha = ' num2str(alpha)]);
box off;
xlabel('Added Difference (Effect Size)');
ylabel('Statistical Power');
title('Validation: Simulated vs. Analytical Power');
legend('show', 'Location', 'southeast');
ylim([0 1.05]);
grid on;

fprintf('\nValidation complete. Plot generated.\n');

end
