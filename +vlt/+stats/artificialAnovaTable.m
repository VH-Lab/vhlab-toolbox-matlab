function [T, powerParams] = artificialAnovaTable(factorNames, factorLevels, nPerGroup, differenceToTest, differenceFactors, SD_Components)
%vlt.stats.artificialAnovaTable Generates an artificial data table for a mixed-effects ANOVA.
%
%   [T, powerParams] = vlt.stats.artificialAnovaTable(factorNames, factorLevels, ...
%       nPerGroup, differenceToTest, differenceFactors, SD_Components)
%
%   Generates a data table 'T' suitable for testing a repeated-measures
%   (linear mixed-effects) N-way ANOVA.
%
%   This function assumes a common experimental design:
%   1.  The first factor (factorNames{1}) is a BETWEEN-SUBJECT factor
%       (e.g., 'Drug').
%   2.  All subsequent factors (factorNames{2:end}) are WITHIN-SUBJECT
%       factors (e.g., 'Day'), meaning they are repeated measures on the
%       same subject.
%
%   INPUTS:
%
%   factorNames     (cell array): The names of the fixed factors.
%                   Example: {'Drug', 'Day'}
%
%   factorLevels    (vector): The number of levels for each fixed factor.
%                   Example: [2, 4] (for 2 drugs and 4 time points)
%
%   nPerGroup       (scalar): The number of unique subjects (e.g., animals)
%                   per level of the *first* (between-subject) factor.
%                   Example: 10
%
%   differenceToTest (scalar): The effect size to add to the baseline mean (0).
%                   Example: 5.0
%
%   differenceFactors (vector): 1-based indices of factors to apply the
%                   difference to. The difference is applied only to
%                   the *last level* of each specified factor.
%                   Example 1 (Main Effect): [1]
%                       Applies difference to all cells of 'Drug_2'.
%                   Example 2 (Interaction): [1, 2]
%                       Applies difference only to cell ('Drug_2', 'Day_4').
%
%   SD_Components   (struct): Struct with the standard deviations for the
%                   mixed-effects model.
%                   Example: struct('RandomIntercept', 2.0, 'Residual', 3.0)
%
%     .RandomIntercept - The "between-subject" SD (e.g., sigma_animal).
%     .Residual        - The "within-subject" SD (e.g., sigma_residual,
%                        or sqrt(MSE)).
%
%   OUTPUTS:
%
%   T               (table): The generated artificial data table. Columns
%                   will be the factor names (e.g., 'Drug', 'Day'), plus
%                   'Animal' (the random factor) and 'Measurement'.
%
%   powerParams     (struct): A struct of parameters formatted for use with
%                   vlt.stats.calculateTukeyPairwisePower.
%
%   EXAMPLE:
%   % Generate data for a 2x3 (Drug x Day) design with 10 animals per drug.
%   % We want to test for an interaction effect in the last cell.
%
%   factorNames = {'Drug', 'Day'};
%   factorLevels = [2, 3];
%   nPerGroup = 10;
%   differenceToTest = 5;
%   differenceFactors = [1, 2]; % Apply to last Drug AND last Day
%   SD_Components = struct('RandomIntercept', 2.0, 'Residual', 3.0);
%
%   [T, p] = vlt.stats.artificialAnovaTable(factorNames, factorLevels, ...
%       nPerGroup, differenceToTest, differenceFactors, SD_Components);
%
%   % T will have 2 (drugs) * 10 (animals) * 3 (days) = 60 rows.
%   % p will be:
%   %   p.expectedDifference: 5
%   %   p.expectedMSE: 9  (3.0^2)
%   %   p.nPerGroup: 10
%   %   p.kTotalGroups: 6  (2*3 cells)
%   %   p.alpha: 0.05
%
%   See also: vlt.stats.calculateTukeyPairwisePower, fullfact, fitlme

% --- 1. Input Validation & Parameter Setup ---
arguments
    factorNames (1,:) cell {mustBeText}
    factorLevels (1,:) double {mustBeInteger, mustBePositive}
    nPerGroup (1,1) double {mustBeInteger, mustBePositive}
    differenceToTest (1,1) double {mustBeNumeric}
    differenceFactors (1,:) double {mustBeInteger, mustBePositive}
    SD_Components (1,1) struct
end

if numel(factorNames) ~= numel(factorLevels)
    error('Number of factorNames must equal number of factorLevels.');
end
if max(differenceFactors) > numel(factorNames)
    error('differenceFactors contains an index larger than the number of factors.');
end
if ~isfield(SD_Components, 'RandomIntercept') || ~isfield(SD_Components, 'Residual')
    error('SD_Components struct must contain fields "RandomIntercept" and "Residual".');
end

baselineMean = 0;
nFactors = numel(factorNames);
kTotalCells = prod(factorLevels);
sd_intercept = SD_Components.RandomIntercept;
sd_residual = SD_Components.Residual;

% --- 2. Define Cell Means (The H1 Hypothesis) ---

% Use fullfact to get all combinations of level indices
% E.g., for [2, 3], this is:
% [1 1; 2 1; 1 2; 2 2; 1 3; 2 3]
levelIndices = fullfact(factorLevels);

% Find rows to apply the difference
rowsToModify = true(kTotalCells, 1);
for i = 1:numel(differenceFactors)
    factorIdx = differenceFactors(i);
    lastLevel = factorLevels(factorIdx);
    rowsToModify = rowsToModify & (levelIndices(:, factorIdx) == lastLevel);
end

% Create the vector of cell means
cellMeans = repmat(baselineMean, kTotalCells, 1);
cellMeans(rowsToModify) = baselineMean + differenceToTest;

% Create a "lookup" for the cell means
% E.g., meanLookup(1,1)=0, meanLookup(2,1)=0, ..., meanLookup(2,3)=5
meanLookup = zeros(factorLevels);
linIndices = sub2ind(factorLevels, levelIndices(:,1), levelIndices(:,2));
if nFactors > 2
    % Handle N-way case
    indicesCell = num2cell(levelIndices, 1);
    linIndices = sub2ind(factorLevels, indicesCell{:});
end
meanLookup(linIndices) = cellMeans;


% --- 3. Generate Factor Level Names (e.g., 'Drug_1', 'Drug_2') ---
levelNames = cell(1, nFactors);
for i = 1:nFactors
    levelNames{i} = cell(factorLevels(i), 1);
    for j = 1:factorLevels(i)
        levelNames{i}{j} = sprintf('%s_%d', factorNames{i}, j);
    end
end

% --- 4. Generate Data Table ---

% Define "between-subject" (grouping) and "within-subject" factors
betweenFactorName = factorNames{1};
nBetweenLevels = factorLevels(1);
nWithinLevels = kTotalCells / nBetweenLevels; % Total # of repeated measures

nTotalAnimals = nBetweenLevels * nPerGroup;
nTotalRows = nTotalAnimals * nWithinLevels; % Total rows in final table

% Generate random intercepts for EACH animal
animalIntercepts = normrnd(0, sd_intercept, [nTotalAnimals, 1]);

% Pre-allocate the output table
T = table('Size', [nTotalRows, nFactors + 2], ...
    'VariableTypes', [repmat("categorical", 1, nFactors+1), "double"]);
T.Properties.VariableNames = [factorNames, 'Animal', 'Measurement'];

% Get all combinations of *within-subject* factor levels
if nFactors > 1
    withinLevelIndices = fullfact(factorLevels(2:end));
else
    withinLevelIndices = 1; % No within-factors
end

% --- Loop through all subjects and fill the table ---
row = 1;
animalCounter = 1;
for i = 1:nBetweenLevels % Loop per between-group (e.g., 'Drug_1', 'Drug_2')
    betweenLevelName = levelNames{1}{i};

    for j = 1:nPerGroup % Loop per animal in that group
        animalName = sprintf('Animal_%d', animalCounter);
        animalIntercept = animalIntercepts(animalCounter);

        for w = 1:nWithinLevels % Loop per repeated measure (e.g., 'Day_1', 'Day_2'...)

            % Get full index for this cell
            if nFactors > 1
                fullFactorIndex = [i, withinLevelIndices(w, :)];
            else
                fullFactorIndex = i;
            end

            % Get the mean for this cell
            idxCell = num2cell(fullFactorIndex);
            cellMean = meanLookup(idxCell{:});

            % Generate measurement
            residualError = normrnd(0, sd_residual);
            measurement = cellMean + animalIntercept + residualError;

            % --- Assign data to table ---
            T(row, 'Measurement') = {measurement};
            T(row, 'Animal') = {animalName};

            % Assign all factor levels
            for f = 1:nFactors
                T(row, factorNames{f}) = levelNames{f}(fullFactorIndex(f));
            end

            row = row + 1;
        end
        animalCounter = animalCounter + 1;
    end
end

% --- 5. Prepare Power Parameter Output ---
powerParams = struct();
powerParams.expectedDifference = differenceToTest;
powerParams.expectedMSE = sd_residual^2;
powerParams.nPerGroup = nPerGroup; % n per cell
powerParams.kTotalGroups = kTotalCells;
powerParams.alpha = 0.05; % Default alpha

end
