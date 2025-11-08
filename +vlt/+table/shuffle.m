function shuffledTable = shuffle(dataTable, dataColumn, groupingFactors, shuffleFactors)
% VLT.TABLE.SHUFFLE Shuffles factor labels in a table while keeping grouping factors constant.
%
% SHUFFLEDTABLE = VLT.TABLE.SHUFFLE(DATATABLE, DATACOLUMN, GROUPINGFACTORS, SHUFFLEFACTORS)
% performs a block-wise permutation test shuffle on the input DATATABLE.
% This function is designed to support power analysis and permutation testing
% by preserving the structure (the grouping factors) of the experimental design.
%
% INPUTS:
%   DATATABLE:        A MATLAB table object containing all data and factor
%                     columns. (e.g., a table with columns 'Drug', 'Day',
%                     'Animal', 'DM').
%
%   DATACOLUMN:       A string or cell array of strings specifying the name(s)
%                     of the column(s) containing the measured data (the values
%                     that remain in their original row positions).
%                     Example: 'DM'
%
%   GROUPINGFACTORS:  A string or cell array of strings specifying the factor
%                     columns that define the **unit of randomization** (the
%                     structure that must remain intact). Rows sharing the same
%                     unique combination of these factors belong to the same
%                     block. The shuffling operation is performed *across*
%                     these blocks.
%                     Example: {'Animal', 'Day'}
%
%                     To perform a **Row-Level Shuffle** (shuffling all labels
%                     randomly), pass an empty cell array: {}.
%
%   SHUFFLEFACTORS:   A string or cell array of strings specifying the factor
%                     column(s) whose labels will be randomly permuted.
%                     If this is empty ([] or None), the function implicitly
%                     uses all columns that are NOT in GROUPINGFACTORS and NOT
%                     in DATACOLUMN as the factors to be shuffled.
%                     Example: 'Drug'
%
% OUTPUTS:
%   SHUFFLEDTABLE:    A new MATLAB table object with the same dimensions as
%                     DATATABLE, but with the labels in the SHUFFLEFACTORS
%                     column(s) permuted according to the grouping scheme.
%
% DESIGN MECHANISM:
% (The core shuffling logic remains the same, but input handling is modernized)
%
% EXAMPLES:
%
% 1. BLOCK SHUFFLE (Shuffling Drug assignments to specific Animal/Day units):
%    % Goal: Preserve the relationship between an animal's measurements (DM)
%    %       at a specific Day, but shuffle the Drug label assigned to that unit.
%    % Input table columns: {'Drug', 'Day', 'Animal', 'DM'}
%    T = table('Size', [100 4], 'VariableTypes', {'string', 'double', 'string', 'double'}, ...
%              'VariableNames', {'Drug', 'Day', 'Animal', 'DM'});
%    % ... Populate T with data ...
%
%    shuffledT = vlt.table.shuffle(T, ...
%        'DM', ...                   % Data column
%        {'Day', 'Animal'}, ...      % Grouping Factors (Unit of randomization)
%        {'Drug'});                  % Factor to shuffle
%
%    % Result: The 'DM' data stays in place. The 'Drug' assignment for
%    % (Animal 'A', Day 2) is swapped with the 'Drug' assignment for a *different* %    % (Animal 'B', Day 2), preserving the 'Day' and 'Animal' structure.
%
% 2. SUBJECT-LEVEL SHUFFLE (Shuffling entire Animal profiles):
%    % Goal: Preserve the internal structure of all measurements for a single animal,
%    %       but randomly swap the *entire* profile (including Drug and Day labels)
%    %       between different animals.
%    % Input table columns: {'Drug', 'Day', 'Animal', 'DM'}
%    T = table('Size', [100 4], 'VariableTypes', {'string', 'double', 'string', 'double'}, ...
%              'VariableNames', {'Drug', 'Day', 'Animal', 'DM'});
%    % ... Populate T with data ...
%
%    shuffledT = vlt.table.shuffle(T, ...
%        'DM', ...                   % Data column
%        {'Animal'}, ...             % Grouping Factor (The entire Animal unit)
%        []);                        % Factors to shuffle (implicitly 'Drug', 'Day')
%
%    % Result: The entire sequence of {Drug, Day} assignments and associated 'DM'
%    % values for Animal 1 might be reassigned to the Animal 5 unit.
%
% 3. ROW-LEVEL SHUFFLE (Shuffling all labels randomly):
%    % Goal: Completely destroy all structure and randomly permute every single
%    %       factor label against all other factor labels in the table.
%    % Input table columns: {'Drug', 'Day', 'Animal', 'DM'}
%    T = table('Size', [100 4], 'VariableTypes', {'string', 'double', 'string', 'double'}, ...
%              'VariableNames', {'Drug', 'Day', 'Animal', 'DM'});
%    % ... Populate T with data ...
%
%    shuffledT = vlt.table.shuffle(T, ...
%        'DM', ...                   % Data column
%        {}, ...                     % Grouping Factors (Empty array for row-level)
%        []);                        % Factors to shuffle (implicitly 'Drug', 'Day', 'Animal')
%
%    % Result: Every factor label in every row is randomly permuted with
%    % labels from every other row, effectively creating a completely random
%    % assignment of all factors.

    % --- ARGUMENTS BLOCK FOR VALIDATION AND DEFAULTS ---
    arguments
        dataTable (1,1) table
        % Calling the external validator function: Correctly passed 'dataColumn'
        % (the variable being validated) and 'dataTable' (the context).
        dataColumn (1,:) {vlt.validators.mustBeAValidTableVariable(dataColumn, dataTable)}
        groupingFactors (1,:) {vlt.validators.mustBeAValidTableVariable(groupingFactors, dataTable)} = string.empty(1,0)
        shuffleFactors (1,:) {vlt.validators.mustBeAValidTableVariable(shuffleFactors, dataTable)} = string.empty(1,0)
    end

    % --- 0. Setup: Convert all factor lists to cell arrays of strings for logic ---
    % Note: After validation in the arguments block, we ensure these are valid inputs.
    dataColumn = cellstr(dataColumn);
    groupingFactors = cellstr(groupingFactors);
    shuffleFactors = cellstr(shuffleFactors);

    % --- 1. Identify Factors to Shuffle (LabelsToShuffle) ---

    allCols = dataTable.Properties.VariableNames;

    if isempty(shuffleFactors)
        % Implicitly determine shuffle factors: All columns minus data and grouping factors
        factorsToExclude = [dataColumn, groupingFactors];
        LabelsToShuffle = setdiff(allCols, factorsToExclude);

        if isempty(LabelsToShuffle)
            error('vlt.table.shuffle:NoShuffleFactors', ...
                  'With empty SHUFFLEFACTORS, no columns remained to shuffle after excluding DATACOLUMN and GROUPINGFACTORS.');
        end
    else
        % Explicitly use provided shuffle factors
        LabelsToShuffle = shuffleFactors;

        % Check for conflicts: LabelsToShuffle must not contain data or grouping factors
        if any(ismember(LabelsToShuffle, dataColumn))
            error('vlt.table.shuffle:Conflict', 'SHUFFLEFACTORS cannot include columns from DATACOLUMN.');
        end
        if any(ismember(LabelsToShuffle, groupingFactors))
            error('vlt.table.shuffle:Conflict', 'SHUFFLEFACTORS cannot include columns from GROUPINGFACTORS.');
        end
    end

    % --- 2. Create Shuffling Units using findgroups ---

    if isempty(groupingFactors)
        % Case: Row-Level Shuffle (every row is its own group)
        numRows = height(dataTable);
        groupIndex = (1:numRows)';
        % uniqueGroups is not strictly used in this branch, but we define it for clarity
        uniqueGroups = table((1:numRows)', 'VariableNames', {'GroupID'});
    else
        % Case: Block Shuffle (group rows based on grouping factors)
        % findgroups creates a vector of group numbers and a table of unique combinations
        groupVars = dataTable(:, groupingFactors);
        [groupIndex, uniqueGroups] = findgroups(groupVars);
    end

    numGroups = height(uniqueGroups);

    % --- 3. Extract, Permute, and Reassign Labels ---

    % Prepare the table containing only the labels we intend to shuffle
    labelsTable = dataTable(:, LabelsToShuffle);

    if isempty(groupingFactors)
        % Row-Level Shuffle:
        numRows = height(dataTable);
        permutedLabelIndices = randperm(numRows)';

        % The shuffled labels are the rows of labelsTable indexed by the permutation
        shuffledLabels = labelsTable(permutedLabelIndices, :);

        % The assignment is direct: shuffledLabels(i, :) goes to row i
        newLabelValues = shuffledLabels.Variables;

    else
        % Block Shuffle:

        % Strategy: Find the label combination for the first row of each group
        firstRowIndices = splitapply(@(x) x(1), (1:height(dataTable))', groupIndex);

        % Extract the LabelsToShuffle columns for just the first row of each group.
        % This gives us one unique label combination per unique group ID.
        groupLabelsToShuffle = labelsTable(firstRowIndices, :);

        % 3a. Generate the permutation for the groups
        permutedGroupIndices = randperm(numGroups)';

        % 3b. Shuffle the unique label combinations
        shuffledGroupLabels = groupLabelsToShuffle(permutedGroupIndices, :);

        % 3c. Map the shuffled labels back to the original rows
        % The 'shuffledGroupLabels' are indexed by the ORIGINAL Group ID index (1 to numGroups).
        % We use the 'groupIndex' vector to map the group-wise shuffled label back to all
        % rows belonging to that group.

        newLabelValues = shuffledGroupLabels(groupIndex, :);
        newLabelValues = newLabelValues.Variables;
    end

    % --- 4. Construct Shuffled Table ---

    % 4a. Create a copy of the input table
    shuffledTable = dataTable;

    % 4b. Overwrite the shuffle factor columns with the new permuted values
    for i = 1:length(LabelsToShuffle)
        colName = LabelsToShuffle{i};
        % Assigning the new values. This handles categorical, string, and numeric types correctly.
        shuffledTable.(colName) = newLabelValues(:, i);
    end

end
