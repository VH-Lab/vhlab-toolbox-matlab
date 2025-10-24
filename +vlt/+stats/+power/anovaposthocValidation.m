function anovaposthocValidation(options)
% ANOVAPOSTHOCVALIDATION - Validate the anovaposthoc simulation against analytical results
%
%   vlt.stats.power.anovaposthocValidation
%
%   Validates the simulation-based power analysis from vlt.stats.power.anovaposthoc
%   against the analytical solution provided by vlt.stats.power.calculateTukeyPairwisePower.
%
%   It performs the following steps:
%   1. Creates a simple, balanced 1-way ANOVA dataset using
%      vlt.stats.artificialAnovaTable.
%   2. Defines a range of effect sizes (differences) to test.
%   3. For each effect size, it calculates the statistical power using both the
%      simulation method and the analytical method.
%   4. Plots the results from both methods on the same axes for visual comparison.
%      The simulated power (blue circles) should closely follow the theoretical
%      power curve (red line).
%
%   This function also accepts optional name-value pairs to modify the simulation:
%   'numShuffles' - The number of shuffles for the simulation (default 2000).
%                   Higher numbers give smoother curves but take longer.
%   'alpha'       - The significance level (default 0.05).
%

arguments
    options.numShuffles (1,1) double = 2000;
    options.alpha (1,1) double = 0.05;
end

% --- Step 1: Define the experimental parameters and create the data table ---

% Parameters for a simple 1-way ANOVA design with 3 groups
factorNames = {'Group'};
factorLevels = [3];
nPerGroup = 10;
SD_Residual = 2.0; % The within-group standard deviation
SD_RandomIntercept = 0; % No subject-specific random effect for this simple case

% We will apply the 'difference' to the last level of the 'Group' factor
differenceFactors = [1];

% The SD_Components struct is required by the generation function
SD_Components = struct('RandomIntercept', SD_RandomIntercept, 'Residual', SD_Residual);

% Generate a baseline data table with NO difference added yet.
% The 'difference' will be added manually within the simulation loop of anovaposthoc.
dataTable = vlt.stats.artificialAnovaTable(factorNames, factorLevels, nPerGroup, ...
    0, differenceFactors, SD_Components); % Start with difference = 0

% Parameters needed for the analytical calculation
k = factorLevels(1);    % Total number of groups
n = nPerGroup;          % N per group (balanced design)
mse = SD_Residual^2;      % Mean squared error
alpha = options.alpha;

% --- Step 2: Set up the power analysis ---

differences = 0:0.5:5; % Range of effect sizes to test
simulated_power = nan(size(differences));
analytical_power = nan(size(differences));

groupColumnNames = {'Group'};
groupComparisons = [1];
groupShuffles = {[1]};

fprintf('Running validation...\n');

% --- Step 3: Loop through differences and calculate power ---

for i=1:numel(differences)
    d = differences(i);
    fprintf('  Testing difference = %.2f\n', d);

    % Run the simulation
    power_struct = vlt.stats.power.anovaposthoc(dataTable, d, groupColumnNames, ...
        groupComparisons, groupShuffles, ...
        'numShuffles', options.numShuffles, 'alpha', alpha, ...
        'plot', false, 'verbose', false);

    % The difference is added to the last group. We want to find the power for a
    % comparison involving this group, e.g., between the first and last groups.
    group_names = unique(dataTable.Group);
    group_name_first = string(group_names(1));
    group_name_last = string(group_names(end));

    % Find the index for this comparison in the power results
    idx = find(contains(power_struct.groupComparisonName, group_name_first) & ...
               contains(power_struct.groupComparisonName, group_name_last));

    if ~isempty(idx)
        % If multiple matches, take the first (should only be one)
        simulated_power(i) = power_struct.groupComparisonPower(idx(1));
    else
        error('Could not find the expected group comparison name in the power results.');
    end


    % Calculate the analytical power
    analytical_power(i) = vlt.stats.power.calculateTukeyPairwisePower(d, mse, n, k, alpha);
end

% --- Step 4: Plot the results ---

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
ylim([0 1]);

fprintf('Validation complete. Plot generated.\n');

end