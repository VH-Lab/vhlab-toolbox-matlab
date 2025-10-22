function anovaposthocDemo(options)
% VLT.STATS.POWER.ANOVAPOSTHOCDEMO - Demonstrate the vlt.stats.power.anovaposthoc function
%
%   VLT.STATS.POWER.ANOVAPOSTHOCDEMO(...)
%
%   Demonstrates the usage of the vlt.stats.power.anovaposthoc function by creating a sample
%   dataset and running a power analysis on it.
%
%   The sample dataset is a table with the following columns:
%   - Animal: An identifier for each subject.
%   - Drug: A categorical variable with two levels ('DrugA', 'DrugB').
%   - TestDay: A categorical variable with two levels ('Day1', 'Day2').
%   - Measurement: A continuous variable representing the data.
%
%   Optional Name-Value Pairs:
%   - 'numSamplesPerGroup' (integer > 0): Number of samples per group. Default is 10.
%   - 'numShuffles' (integer > 0): Number of simulations for the power analysis. Default is 1000.
%

arguments
    options.numSamplesPerGroup (1,1) double {mustBeInteger, mustBeGreaterThan(options.numSamplesPerGroup,0)} = 10
    options.numShuffles (1,1) double {mustBeInteger, mustBeGreaterThan(options.numShuffles,0)} = 1000
end

% Create a sample data table
Animal = repelem(1:options.numSamplesPerGroup, 4)';
Drug = repmat(repelem(["DrugA"; "DrugB"], 2), options.numSamplesPerGroup, 1);
TestDay = repmat(["Day1"; "Day2"], 2 * options.numSamplesPerGroup, 1);
Measurement = randn(4 * options.numSamplesPerGroup, 1);

dataTable = table(Animal, Drug, TestDay, Measurement);

disp('Sample data table:');
disp(dataTable);

% Define the parameters for the power analysis
differences = 0:0.5:2;
groupColumnNames = {'Drug', 'TestDay'};
groupComparisons = [1 2]; % Compare combinations of Drug and TestDay
groupShuffles = {[1], [2], [1 2]}; % Shuffle Drug, TestDay, or both

% Run the power analysis
anovaposthoc_results = vlt.stats.power.anovaposthoc(dataTable, differences, groupColumnNames, ...
    groupComparisons, groupShuffles, 'numShuffles', options.numShuffles);

% Display the results
for i = 1:numel(anovaposthoc_results)
    disp(['Results for shuffle group: ' mat2str(groupShuffles{i})]);
    disp('Comparison Powers:');
    disp(anovaposthoc_results(i).groupComparisonPower);
    disp('Comparison Names:');
    disp(anovaposthoc_results(i).groupComparisonName);
end

% Plot the results
figure;
for i = 1:numel(anovaposthoc_results)
    subplot(1, numel(anovaposthoc_results), i);
    plot(differences, anovaposthoc_results(i).groupComparisonPower, '-o');
    title(['Shuffle: ' mat2str(groupShuffles{i})]);
    xlabel('Difference');
    ylabel('Power');
    legend(anovaposthoc_results(i).groupComparisonName, 'Location', 'best');
    box off;
end

end
