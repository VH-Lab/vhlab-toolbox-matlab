function [T, powerParams] = artificialAnovaTable(factorNames, factorLevels, nPerGroup, differenceToTest, differenceFactors, SD_Components)
%vlt.stats.artificialAnovaTable Generates an artificial data table for ANOVA power analysis.
%
%   [T, powerParams] = vlt.stats.artificialAnovaTable(factorNames, factorLevels, ...
%       nPerGroup, differenceToTest, differenceFactors, SD_Components)
%
%   Generates a data table T for a repeated-measures (mixed-effects)
%   design. It assumes the first factor (e.g., 'Drug') is the
%   between-subjects grouping factor, and all subsequent factors (e.g., 'Day')
%   are within-subjects (repeated measures).
%
%   This function is ideal for generating data to test a power simulation.
%
%   Inputs:
%
%     factorNames (cell array): The names of the *fixed factors* only.
%         Example: {'Drug', 'Day'}
%
%     factorLevels (vector): The number of levels for each fixed factor.
%         Example: [2, 4] (for 2 drugs and 4 time points)
%
%     nPerGroup (scalar): The number of random subjects (e.g., animals)
%         per group in the *first* factor.
%         Example: 10 (Creates 10 animals for 'Drug_1' and 10 for 'Drug_2')
%
%     differenceToTest (scalar): The effect size (mean difference) to apply.
%         Example: 5.0
%
%     differenceFactors (vector): 1-based indices of the factors to apply
%         the difference to. The difference is *always* applied to the
%         *last level* of these factors.
%         Example 1 (Main Effect): [1] -> Applies diff to all 'Drug_2' cells.
%         Example 2 (Interaction): [1, 2] -> Applies diff to the
%                                           ('Drug_2', 'Day_4') cell.
%
%     SD_Components (struct): Struct with standard deviations.
%         Example: struct('RandomIntercept', 2.0, 'Residual', 3.0)
%         .RandomIntercept: The "between-subject" SD (e.g., sigma_animal).
%         .Residual: The "within-subject" SD (e.g., sqrt(MSE) or sigma_error).
%
%   Outputs:
%
%     T (table): The generated artificial data table.
%         Columns: [factorNames..., 'Animal', 'Measurement']
%         (e.g., 'Drug', 'Day', 'Animal', 'Measurement')
%
%     powerParams (struct): A struct formatted to pass to
%         vlt.stats.calculateTukeyPairwisePower.
%
%   See also: vlt.stats.calculateTukeyPairwisePower, fitlme

% --- 1. Input Validation and Setup ---
arguments
    factorNames (1,:) cell {mustBeText}
    factorLevels (1,:) double {mustBeInteger, mustBePositive, mustHaveEqualSize(factorNames, factorLevels)}
    nPerGroup (1,1) double {mustBeInteger, mustBePositive}
    differenceToTest (1,1) double {mustBeNumeric}
    differenceFactors (1,:) double {mustBeInteger, mustBePositive, mustBeValidFactorIndex(differenceFactors, factorNames)}
    SD_Components (1,1) struct {mustContainFields(SD_Components, {'RandomIntercept', 'Residual'})}
end

nFactors = numel(factorNames);
kTotalGroups = prod(factorLevels);
nBetweenGroups = factorLevels(1);
nSubjectsPerGroup = nPerGroup;
nTotalSubjects = nBetweenGroups * nSubjectsPerGroup;

% --- 2. Create the Fixed-Effects Design Table (the "Mean Table") ---

% Create a grid of all factor level combinations
% FIX: Create cell array of vectors (e.g., {1:2, 1:4}) for ndgrid
gridVectors = arrayfun(@(x) 1:x, factorLevels, 'UniformOutput', false);
levelGrids = cell(1, nFactors);
[levelGrids{:}] = ndgrid(gridVectors{:});

% This table will have kTotalGroups rows
meanTable = table();
for i = 1:nFactors
    factorName = string(factorNames{i}); % Convert to string

    % FIX: Use string concatenation which categorical() handles correctly.
    levelNames = categorical(factorName + "_" + string(levelGrids{i}(:)));

    meanTable.(factorNames{i}) = levelNames; % Use original char name for column
end

% --- 3. Define and Apply the Effect (The H1 Hypothesis) ---
% Start with a baseline mean of 0 for all cells
meanTable.Mean = zeros(kTotalGroups, 1);

if ~isempty(differenceToTest) && ~isempty(differenceFactors)
    % Create a logical index for the rows to apply the difference

    % Start with all rows (all true)
    effectIdx = true(kTotalGroups, 1);

    for i = 1:numel(differenceFactors)
        factorIdx = differenceFactors(i);
        factorName = factorNames{factorIdx};
        lastLevel = factorLevels(factorIdx);

        % FIX: Use string concatenation and convert to categorical
        lastLevelName = categorical(string(factorName) + "_" + string(lastLevel));

        % Intersect the index
        effectIdx = effectIdx & (meanTable.(factorName) == lastLevelName);
    end

    % Apply the difference to the selected rows
    meanTable.Mean(effectIdx) = differenceToTest;
end

% --- 4. Create the Full Data Table with Subjects (Random Effects) ---

% Generate random intercepts for each subject
% One unique intercept for each of the nTotalSubjects
subjectIntercepts = normrnd(0, SD_Components.RandomIntercept, [nTotalSubjects, 1]);

% Create subject names ('Animal_1', 'Animal_2', ...)
% FIX: Use string array, then convert to categorical
subjectNames_str = "Animal_" + string((1:nTotalSubjects)');
subjectNames = categorical(subjectNames_str);


% Create the final table design
% This is complex, so we build it step-by-step

% Replicate the meanTable for each subject, but this is tricky
% because subjects are nested within the first factor.

% Initialize empty cell arrays to build the final table columns
tableCells = cell(1, nFactors + 2); % factors + 'Animal' + 'Measurement'
colNames = [factorNames, 'Animal', 'Measurement'];

% Get the number of within-subject levels (all factors *except* the first)
withinLevels = factorLevels(2:end);
nWithinMeasurements = prod(withinLevels);
if isempty(nWithinMeasurements)
    nWithinMeasurements = 1; % Handle case with only 1 factor
end

% Total rows in final table
nTotalRows = nTotalSubjects * nWithinMeasurements;

% Pre-allocate columns
for i = 1:nFactors
    tableCells{i} = repmat(categorical(missing), nTotalRows, 1);
end
tableCells{nFactors + 1} = repmat(categorical(missing), nTotalRows, 1); % Animal
tableCells{nFactors + 2} = zeros(nTotalRows, 1); % Measurement

rowCounter = 1;
subjectCounter = 1;

% Loop over the *between-subject* factor (Factor 1)
for i = 1:nBetweenGroups

    % Get the name of this between-subject level (e.g., 'Drug_1')
    % FIX: Use string concatenation and convert to categorical
    betweenLevelName = categorical(string(factorNames{1}) + "_" + string(i));

    % Find all rows in the meanTable matching this level
    meanTable_subset = meanTable(meanTable.(factorNames{1}) == betweenLevelName, :);

    % Loop over the subjects *in this group*
    for j = 1:nSubjectsPerGroup

        % Get this subject's ID and random intercept
        subjectID = subjectNames(subjectCounter);
        subjectIntercept = subjectIntercepts(subjectCounter);

        % Get the indices for this subject's rows in the final table
        rows_to_fill = rowCounter : (rowCounter + nWithinMeasurements - 1);

        % Fill in the fixed factor columns
        for f = 1:nFactors
            tableCells{f}(rows_to_fill) = meanTable_subset.(factorNames{f});
        end

        % Fill in the Animal column
        tableCells{nFactors + 1}(rows_to_fill) = subjectID;

        % Generate measurement = mean + subject_intercept + residual_error
        tableCells{nFactors + 2}(rows_to_fill) = ...
            meanTable_subset.Mean + ...
            subjectIntercept + ...
            normrnd(0, SD_Components.Residual, [nWithinMeasurements, 1]);

        % Increment counters
        rowCounter = rowCounter + nWithinMeasurements;
        subjectCounter = subjectCounter + 1;
    end
end

% Create the final table
T = table(tableCells{:}, 'VariableNames', colNames);

% --- 5. Prepare the powerParams Output Struct ---
powerParams = struct();
powerParams.expectedDifference = differenceToTest;
powerParams.expectedMSE = SD_Components.Residual^2;
powerParams.nPerGroup = nPerGroup;
powerParams.kTotalGroups = kTotalGroups;
powerParams.alpha = 0.05; % Set default alpha

end

% --- Custom Validation Functions for Arguments Block ---

function mustHaveEqualSize(a, b)
    % Custom validator to ensure numel matches
    if ~isequal(numel(a), numel(b))
        error('MATLAB:InputParser:ArgumentFailedValidation', ...
            'Number of factorNames must equal number of factorLevels.');
    end
end

function mustBeValidFactorIndex(indices, factorNames)
    % Custom validator for differenceFactors
    if any(indices > numel(factorNames))
        error('MATLAB:InputParser:ArgumentFailedValidation', ...
            'differenceFactors contains an index larger than the number of factors.');
    end
end

function mustContainFields(s, fields)
    % Custom validator for SD_Components struct
    if ~isstruct(s)
         error('MATLAB:InputParser:ArgumentFailedValidation', 'SD_Components must be a struct.');
    end
    if ~all(isfield(s, fields))
        missing = fields(~isfield(s, fields));
        error('MATLAB:InputParser:ArgumentFailedValidation', ...
            'SD_Components struct is missing required field(s): %s', strjoin(missing, ', '));
    end
end
