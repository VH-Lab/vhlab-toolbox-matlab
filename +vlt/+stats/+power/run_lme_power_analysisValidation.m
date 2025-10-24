function run_lme_power_analysisValidation(options)
% RUN_LME_POWER_ANALYSISVALIDATION - Validate the LME power analysis against analytical results
%
%   vlt.stats.power.run_lme_power_analysisValidation
%
%   Validates the simulation-based power analysis from vlt.stats.power.run_lme_power_analysis
%   against the analytical solution for a simple 1-way ANOVA case provided by
%   vlt.stats.power.calculateTukeyPairwisePower.
%
%   It performs the following steps:
%   1. Creates a simple, balanced 1-way ANOVA dataset using vlt.stats.artificialAnovaTable.
%   2. Determines the theoretical Minimum Detectable Effect Size (MDES) for a given
%      target power by numerically inverting the analytical power function.
%   3. Runs the full simulation-based analysis to find the MDES for the same target power.
%   4. Plots the power curve from the simulation and overlays the analytical and
%      simulated MDES values for visual comparison.
%   5. Displays a table comparing the two MDES values.
%
%   Optional Name-Value Pairs:
%   'numShuffles' - The number of shuffles for the simulation (default 1000).
%                   Higher numbers give more precise results but take longer.
%   'alpha'       - The significance level (default 0.05).
%   'targetPower' - The target power for which to find the MDES (default 0.80).
%
arguments
    options.numShuffles (1,1) double {mustBeInteger, mustBeGreaterThan(options.numShuffles, 0)} = 1000;
    options.alpha (1,1) double {mustBeGreaterThan(options.alpha, 0), mustBeLessThan(options.alpha, 1)} = 0.05;
    options.targetPower (1,1) double {mustBeGreaterThan(options.targetPower, 0), mustBeLessThan(options.targetPower, 1)} = 0.80;
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
% Also capture the parameters used by the generator.
[dataTable, powerParamsFromGen] = vlt.stats.artificialAnovaTable(factorNames, factorLevels, nPerGroup_gen, ...
    0, [1], SD_Components); % Start with difference = 0

% --- Get Parameters for Analytical Calculation FROM the Generator Output ---
powerParamsFromGen.alpha = options.alpha; % Use the alpha passed to this function
dataTable.Properties.VariableNames{2} = 'Y'; % Rename for compatibility

% --- Step 2: Calculate the theoretical MDES by inverting the power function ---
fprintf('Calculating theoretical MDES...\n');

% Extract parameters for the analytical calculation
k = powerParamsFromGen.kTotalGroups;
n = powerParamsFromGen.nPerGroup;
mse = powerParamsFromGen.expectedMSE;
alpha = powerParamsFromGen.alpha;
targetPower = options.targetPower;

% Numerical search to find the effect size that gives the target power
d_test = 0;
power_calc = 0;
step = 0.01;
max_d = 100; % Safety break
while power_calc < targetPower && d_test < max_d
    d_test = d_test + step;
    power_calc = vlt.stats.power.calculateTukeyPairwisePower(d_test, mse, n, k, alpha, 'method', 'cdfTukey');
end
theoretical_mdes = d_test;

fprintf('  Theoretical MDES for %.2f power is %.4f\n', targetPower, theoretical_mdes);

% --- Step 3: Run the simulation-based power analysis ---
fprintf('\nRunning simulation-based LME power analysis...\n');

% Get group names for the function call
group_names = unique(dataTable.Group);
reference_category = char(group_names(1));
category_to_test = char(group_names(end));

[simulated_mdes, power_curve] = vlt.stats.power.run_lme_power_analysis(dataTable, 'Group', 'Y', ...
    reference_category, 'Group', category_to_test, targetPower, ...
    'Alpha', alpha, ...
    'NumSimulations', options.numShuffles, ...
    'Method', 'shuffle'); % Shuffle is appropriate for a simple ANOVA design

fprintf('  Simulation found MDES = %.4f\n', simulated_mdes);

% --- Step 4: Display Comparison Table ---
fprintf('\n--- Validation Summary ---\n');
resultsTable = table(theoretical_mdes, simulated_mdes, 'VariableNames', {'Theoretical_MDES', 'Simulated_MDES'});
disp(resultsTable);

% --- Step 5: Plot the results ---
figure;
hold on;
% Plot the power curve from the simulation
plot(power_curve.EffectSize, power_curve.Power, 'bo-', 'MarkerFaceColor', 'b', 'DisplayName', 'Simulated Power Curve');

% Add lines for target power and MDES values
yline(targetPower, 'k--', 'DisplayName', ['Target Power = ' num2str(targetPower)]);
xline(theoretical_mdes, 'r-', 'LineWidth', 2, 'DisplayName', ['Theoretical MDES = ' num2str(theoretical_mdes, '%.3f')]);
xline(simulated_mdes, 'b--', 'LineWidth', 2, 'DisplayName', ['Simulated MDES = ' num2str(simulated_mdes, '%.3f')]);

box off;
xlabel('Added Difference (Effect Size)');
ylabel('Statistical Power');
title('Validation: Simulated vs. Theoretical MDES');
legend('show', 'Location', 'southeast');
ylim([0 1.05]);
grid on;

fprintf('\nValidation complete. Plot generated.\n');

end
