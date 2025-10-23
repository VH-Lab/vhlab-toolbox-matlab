function anovaposthocValidation(varargin)
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
    varargin.numShuffles (1,1) double = 2000;
    varargin.alpha (1,1) double = 0.05;
end

% --- Step 1: Define the experimental parameters and create the data table ---

group_means = [10 10 10];
group_stdevs = [2 2 2];
group_n = [10 10 10];

k = numel(group_means); % Total number of groups
n = group_n(1);         % N per group (balanced design)
mse = group_stdevs(1)^2;  % Mean squared error
alpha = varargin.alpha;

dataTable = vlt.stats.artificialAnovaTable(group_means, group_stdevs, group_n);

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
        'numShuffles', varargin.numShuffles, 'alpha', alpha, ...
        'plot', false, 'verbose', false);

    % The difference is added to the last group (GroupC). We want to find the
    % power for the comparison between the first group (GroupA) and the last.
    % The names are like 'Group-GroupA vs. Group-GroupC'
    comparison_name_to_find = [char(power_struct(1).groupComparisonName(1)) ' vs. ' char(power_struct(1).groupComparisonName(end))];

    % Find the index of this comparison
    % Note: the returned names might be in a different order, so we check both directions
    name1 = [string(dataTable.Properties.VariableNames{2}) '-' string(unique(dataTable.Group){1}) ' vs. ' string(dataTable.Properties.VariableNames{2}) '-' string(unique(dataTable.Group){k})];
    idx = find(strcmp(power_struct.groupComparisonName, name1));
    if isempty(idx),
        name2 = [string(dataTable.Properties.VariableNames{2}) '-' string(unique(dataTable.Group){k}) ' vs. ' string(dataTable.Properties.VariableNames{2}) '-' string(unique(dataTable.Group){1})];
        idx = find(strcmp(power_struct.groupComparisonName, name2));
    end

    if ~isempty(idx)
        simulated_power(i) = power_struct.groupComparisonPower(idx);
    else
        error(['Could not find the expected group comparison name: ' name1 ' or ' name2]);
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
