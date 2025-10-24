function anovaposthocDemo(options)
% VLT.STATS.POWER.ANOVAPOSTHOCDEMO - Demonstrate the vlt.stats.power.anovaposthoc function
%
%   VLT.STATS.POWER.ANOVAPOSTHOCDEMO(...)
%
%   Demonstrates the usage of the vlt.stats.power.anovaposthoc function by creating a sample
%   dataset and running a power analysis on it. This function serves as a practical example
%   of how to structure the input data and parameters for a power analysis of a multi-factor
%   ANOVA design.
%
%   The sample dataset created is a table with columns for Animal, Drug, TestDay, and
%   Measurement. This represents a typical repeated-measures design where multiple animals
%   are tested with different drugs on different days.
%
%   The demo then calculates the statistical power for detecting differences in the 'Measurement'
%   variable based on the 'Drug' and 'TestDay' factors. It explores three different shuffling
%   schemes to evaluate power under different assumptions about the data's variance structure.
%
%   Optional Name-Value Pairs:
%   - 'numberOfAnimals' (integer > 0): The number of animals (subjects) in the simulation. Default is 5.
%   - 'numberOfDrugs' (integer > 0): The number of drug conditions. Default is 2.
%   - 'numberOfDays' (integer > 0): The number of test days. Default is 5.
%   - 'numShuffles' (integer > 0): Number of simulations for the power analysis. Default is 1000.
%

arguments
    options.numberOfAnimals (1,1) double {mustBeInteger, mustBeGreaterThan(options.numberOfAnimals,0)} = 5
    options.numberOfDrugs (1,1) double {mustBeInteger, mustBeGreaterThan(options.numberOfDrugs,0)} = 2
    options.numberOfDays (1,1) double {mustBeInteger, mustBeGreaterThan(options.numberOfDays,0)} = 5
    options.numShuffles (1,1) double {mustBeInteger, mustBeGreaterThan(options.numShuffles,0)} = 1000
end

% Create a sample data table
num_total_measurements = options.numberOfAnimals * options.numberOfDrugs * options.numberOfDays;

Animal = repelem(1:options.numberOfAnimals, options.numberOfDrugs * options.numberOfDays)';

drug_labels = "Drug" + (1:options.numberOfDrugs)';
Drug = repmat(repelem(drug_labels, options.numberOfDays), options.numberOfAnimals, 1);

day_labels = "Day" + (1:options.numberOfDays)';
TestDay = repmat(day_labels, num_total_measurements / options.numberOfDays, 1);

Measurement = randn(num_total_measurements, 1);

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

end
