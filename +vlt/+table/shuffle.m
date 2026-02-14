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
%        []);                        % Factors to shuffle (implicitly 'Drug', 'Day', 'DM')
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
        dataTable (:,:) table
        % Calling the external validator function: Correctly passed 'dataColumn'
        % (the variable being validated) and 'dataTable' (the context).
        dataColumn (:,:) string {vlt.validators.mustBeAValidTableVariable(dataColumn, dataTable)}
        groupingFactors (:,:) string {vlt.validators.mustBeAValidTableVariable(groupingFactors, dataTable)} = string.empty(1,0)
        shuffleFactors (:,:) string {vlt.validators.mustBeAValidTableVariable(shuffleFactors, dataTable)} = string.empty(1,0)
    end

    % --- 0. Setup: Convert all factor lists to cell arrays of strings for logic ---
    % Note: After validation in the arguments block, we ensure these are valid inputs.
    dataColumn = cellstr(dataColumn);
    groupingFactors = cellstr(groupingFactors);
    shuffleFactors = cellstr(shuffleFactors);

    % --- 1. Identify Factors to Shuffle (LabelsToShuffle) ---
    allCols = dataTable.Properties.VariableNames;

    if isempty(shuffleFactors)
        % --- IMPLICIT SHUFFLE FACTORS ---
        if isempty(groupingFactors)
            % Case 3: Row-Level Shuffle. Shuffle everything EXCEPT data.
            factorsToExclude = dataColumn;
        else
            % Case 2: Subject-Level Shuffle. Shuffle everything EXCEPT grouping factors.
            % The dataColumn is *part of* the shuffle in this case.
            factorsToExclude = groupingFactors;
        end
        LabelsToShuffle = setdiff(allCols, factorsToExclude);

        if isempty(LabelsToShuffle)
            error('vlt.table.shuffle:NoShuffleFactors', ...
                  'With empty SHUFFLEFACTORS, no columns remained to shuffle after excluding DATACOLUMN and/OR GROUPINGFACTORS.');
        end
    else
        % --- EXPLICIT SHUFFLE FACTORS ---
        % Case 1: Block Shuffle (explicit).
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
        numGroups = numRows; % Each row is a group
    else
        % Case: Block Shuffle (group rows based on grouping factors)
        % findgroups creates a vector of group numbers and a table of unique combinations
        groupVars = dataTable(:, groupingFactors);
        [groupIndex, uniqueGroups] = findgroups(groupVars);
        numGroups = height(uniqueGroups);
    end

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
        newLabelValuesTable = shuffledLabels;
    else
        % Block Shuffle:

        % 1. Create a cell array where each cell holds one *column* of data
        %    (e.g., a 4x1 categorical vector, a 4x1 double vector).
        %    These 4x1 columns match the 4x1 groupIndex.
        dataCols = cell(1, length(LabelsToShuffle));
        for i = 1:length(LabelsToShuffle)
            dataCols{i} = labelsTable.(LabelsToShuffle{i});
        end

        % 2. Apply splitapply to these columns.
        %    For each group, 'varargin' will contain the *chunks* of each column
        %    (e.g., a 2x1 categorical, a 2x1 double).
        %    The anonymous function re-combines them into a table.
        labelBlocks = splitapply(@(varargin) {table(varargin{:}, 'VariableNames', LabelsToShuffle)}, ...
                                 dataCols{:}, ...
                                 groupIndex);

        % labelBlocks is now a cell array, e.g. (for testSubjectLevelShuffle):
        % { table(Drug,Day,DM) for S1; table(Drug,Day,DM) for S2 }

        % 3. Shuffle this cell array of label blocks
        permutedBlocks = labelBlocks(randperm(numGroups));

        % 4. Vertically concatenate the shuffled blocks back into a single table
        newLabelValuesTable = vertcat(permutedBlocks{:});
    end

    % --- 4. Construct Shuffled Table ---
    % 4a. Create a copy of the input table
    shuffledTable = dataTable;

    % 4b. Overwrite the shuffle factor columns with the new permuted values
    for i = 1:length(LabelsToShuffle)
        colName = LabelsToShuffle{i};
        % Assigning the new values.
        shuffledTable.(colName) = newLabelValuesTable.(colName);
    end
end
