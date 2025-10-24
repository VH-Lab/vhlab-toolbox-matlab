function anovaposthocValidation(options)
% ANOVAPOSTHOCVALIDATION - Validate the anovaposthoc simulation against analytical results
%
%   vlt.stats.power.anovaposthocValidation
%
%   Validates the simulation-based power analysis from vlt.stats.power.anovaposthoc
%   against the analytical solution provided by vlt.stats.power.calculateTukeyPairwisePower.
%   It uses vlt.stats.artificialAnovTable to generate the base dataset and
%   retrieve consistent parameters for both simulation and analytical calculation.
%
%   It performs the following steps:
%   1. Creates a simple, balanced 1-way ANOVA dataset using
%      vlt.stats.artificialAnovaTable and retrieves the parameters used.
%   2. Defines a range of effect sizes (differences) to test.
%   3. For each effect size, it calculates the statistical power using both the
%      simulation method (on the generated table) and the analytical method
%      (using the retrieved parameters).
%   4. Plots the results from both methods on the same axes for visual comparison.
%   5. Displays a table comparing the simulated and analytical power values.
%
%   **Understanding Discrepancies Between Simulation and Theory:**
%   It is common to observe that the simulated power (blue circles) is slightly
%   higher than the theoretical power curve (red line), especially in the
%   middle range (e.g., power between 0.3 and 0.8). This is generally *not*
%   an error in the simulation but reflects the difference between assuming
%   perfect knowledge versus estimating parameters from data:
%
%   * **Analytical Power:** Assumes the true population variance (Mean Squared
%       Error, MSE) is known exactly and is fixed.
%   * **Simulated Power:** In each simulation run, the ANOVA model *estimates*
%       the MSE from the randomly generated sample data. Due to sampling
%       variability, this estimated MSE will fluctuate around the true value.
%   * **Effect:** When, by chance, the estimated MSE in a simulation run is
%       *lower* than the true MSE, the statistical test (e.g., Tukey's HSD)
%       has an easier time detecting a significant difference. Over many
%       simulations, these instances slightly inflate the average observed power
%       compared to the theoretical calculation.
%
%   Therefore, the simulation often provides a slightly more realistic estimate
%   of the power achievable when analyzing actual experimental data, where the
%   true variance must also be estimated. The analytical curve serves as a
%   valuable theoretical benchmark under ideal conditions.
%
%   Optional Name-Value Pairs:
%   'numShuffles' - The number of shuffles for the simulation (default 2000).
%                   Higher numbers give smoother curves but take longer.
%   'alpha'       - The significance level (default 0.05).
%
arguments
    options.numShuffles (1,1) double {mustBeInteger, mustBeGreaterThan(options.numShuffles, 0)} = 2000;
    options.alpha (1,1) double {mustBeGreaterThan(options.alpha, 0), mustBeLessThan(options.alpha, 1)} = 0.05;
end

% --- Step 1: Define the experimental parameters and create the data table ---
% Parameters for a simple 1-way ANOVA design with 3 groups
factorNames = {'Group'};
factorLevels = [3];
nPerGroup_gen = 10; % Renamed to avoid conflict with analytical param 'n'
SD_Residual = 2.0; % The within-group standard deviation
SD_RandomIntercept = 0; % No subject-specific random effect for this simple case

% We will apply the 'difference' to the last level of the 'Group' factor
differenceFactors = [1];

% The SD_Components struct is required by the generation function
SD_Components = struct('RandomIntercept', SD_RandomIntercept, 'Residual', SD_Residual);

% Generate a baseline data table with NO difference added yet.
% Also capture the parameters used by the generator.
[dataTable, powerParamsFromGen] = vlt.stats.artificialAnovaTable(factorNames, factorLevels, nPerGroup_gen, ...
    0, differenceFactors, SD_Components); % Start with difference = 0

% --- Get Parameters for Analytical Calculation FROM the Generator Output ---
k = powerParamsFromGen.kTotalGroups;       % Total number of groups
n = powerParamsFromGen.nPerGroup;          % N per group
mse = powerParamsFromGen.expectedMSE;      % Mean squared error
alpha = options.alpha; % Use the alpha passed to this function (or default)
% Update the alpha in powerParamsFromGen *if* it was overridden
powerParamsFromGen.alpha = alpha;


% --- Step 2: Set up the power analysis ---
differences = 0:0.5:5; % Range of effect sizes to test
simulated_power = nan(size(differences));
analytical_power = nan(size(differences));

% Define how anovaposthoc should run
groupColumnNames = {'Group'};
groupComparisons = [1]; % Dimension for multcompare in 1-way ANOVA
groupShuffles = {[1]}; % Shuffle the 'Group' factor labels

fprintf('Running validation...\n');

% --- Step 3: Loop through differences and calculate power ---
for i=1:numel(differences)
    d = differences(i);
    fprintf('  Testing difference = %.2f\n', d);

    % --- Run the simulation ---
    % Pass only the single difference 'd' for this iteration
    power_struct = vlt.stats.power.anovaposthoc(dataTable, d, groupColumnNames, ...
        groupComparisons, groupShuffles, ...
        'numShuffles', options.numShuffles, 'alpha', alpha, ...
        'plot', false, 'verbose', false);

    % --- Extract the relevant simulated power ---
    group_names = unique(dataTable.Group);
    group_name_first = string(group_names(1));
    group_name_last = string(group_names(end));

    factor_name = string(factorNames{1});
    expected_name_1 = factor_name + "=" + group_name_first + " vs. " + factor_name + "=" + group_name_last;
    expected_name_2 = factor_name + "=" + group_name_last + " vs. " + factor_name + "=" + group_name_first;

    idx = find(strcmp(power_struct.groupComparisonName, expected_name_1) | ...
               strcmp(power_struct.groupComparisonName, expected_name_2));

    if numel(idx) == 1
        simulated_power(i) = power_struct.groupComparisonPower(1, idx);
    elseif isempty(idx)
        warning('Could not find the expected group comparison name (%s vs. %s) in the simulation results.', group_name_first, group_name_last);
        simulated_power(i) = NaN;
    else
         warning('Found multiple matches for group comparison name (%s vs. %s). Using the first.', group_name_first, group_name_last);
         simulated_power(i) = power_struct.groupComparisonPower(1, idx(1));
    end

    % --- Calculate the analytical power ---
    % Use the parameters extracted from powerParamsFromGen
    % The difference 'd' comes from the loop
    analytical_power(i) = vlt.stats.power.calculateTukeyPairwisePower(d, mse, n, k, alpha, 'method', 'cdfTukey');
end

% --- Step 4: Display Comparison Table ---
fprintf('\nValidation Results Table:\n');
resultsTable = table(differences(:), simulated_power(:), analytical_power(:), ...
    'VariableNames', {'Difference', 'SimulatedPower', 'AnalyticalPower'});
disp(resultsTable);

% --- Step 5: Plot the results ---
figure;
hold on;
plot(differences, simulated_power, 'bo', 'MarkerFaceColor', 'b', 'DisplayName', 'Simulated (anovaposthoc)');
plot(differences, analytical_power, 'r-', 'LineWidth', 2, 'DisplayName', 'Theoretical (Tukey HSD)');
yline(alpha, 'k--', 'DisplayName', ['Alpha = ' num2str(alpha)]);
box off;
xlabel('Added Difference (Effect Size)');
ylabel('Statistical Power');
title('Validation: Simulated vs. Analytical Power');
legend('show', 'Location', 'southeast');
ylim([0 1.05]); % Extend ylim slightly
grid on;

fprintf('\nValidation complete. Plot generated.\n');

end

