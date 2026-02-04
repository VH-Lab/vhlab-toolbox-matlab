function T_shuffled = permuteReplicates(T, Observation, Factors, Replicate, FactorShuffleMask, options)
% PERMUTEREPLICATES Permutes factor labels across biological replicates.
%
%   T_shuffled = permuteReplicates(T, Observation, Factors, Replicate, FactorShuffleMask)
%   T_shuffled = permuteReplicates(..., 'shuffleReplicates', true)
%
%   PURPOSE:
%   This function creates "shuffled" datasets for Null Hypothesis testing 
%   and Power Analysis in Linear Mixed Models (LMMs). It preserves the 
%   hierarchical structure of the data (the nesting of observations within 
%   replicates) by shuffling the LABELS of whole replicates (e.g., Animals) 
%   rather than shuffling individual observations.
%
%   INPUTS:
%   T (Table)
%       The input data table containing raw observations.
%
%   Observation (String)
%       The column name of the dependent variable (Y).
%
%   Factors (String Array)
%       A list of column names representing the Fixed Factors in the design.
%       Example: ["Strain", "Drug", "BehTrt"]
%
%   Replicate (String)
%       The column name of the Random Grouping Factor (the "Unit"). 
%       This is typically AnimalID or SubjectID. 
%       CRITICAL: The function assumes that observations sharing this ID 
%       cannot be split apart physically.
%
%   FactorShuffleMask (Logical Array)
%       A boolean vector matching the length of Factors.
%       1 (true)  = TARGET. These labels are permuted across Replicates.
%       0 (false) = STRATIFIER. These labels are held fixed. Shuffling
%                   is restricted to occur WITHIN groups defined by these.
%
%   OPTIONAL PARAMETERS:
%   'shuffleReplicates' (Boolean, Default: false)
%       false: STANDARD MODE. Preserves Replicate integrity. Observations 
%              from "Mouse A" stay together; only the Factor labels assigned 
%              to "Mouse A" change. Preserves within-subject correlation.
%       true:  NAIVE MODE (Destructive). Ignores the Replicate grouping 
%              entirely. All observations are shuffled freely. This destroys 
%              the random effect structure. Use only to test if the 
%              Random Effect itself is significant.
%
%   -----------------------------------------------------------------------
%   EXAMPLE USAGE:
%   -----------------------------------------------------------------------
%   Suppose you have a table 'experimentData' with the following columns:
%     - 'MouseID' (The biological replicate)
%     - 'ReactionTime' (The observation)
%     - 'Strain', 'Drug', 'Therapy' (The fixed factors)
%
%   Goal: You want to randomize the influence of the 'Drug' factor to 
%   create a null distribution, but you must ensure you only swap Drug 
%   labels between mice of the same Strain and Therapy (Stratification).
%
%       factors   = ["Strain", "Drug", "Therapy"];
%       replicate = "MouseID";
%       obs       = "ReactionTime";
%
%       % Mask Definition: 0 = Stratify/Hold Fixed, 1 = Shuffle
%       % We shuffle 'Drug' (index 2), keeping 'Strain' and 'Therapy' fixed.
%       mask = [false, true, false]; 
%
%       % Run the permutation
%       T_null = permuteReplicates(experimentData, obs, factors, replicate, mask);
%
%   -----------------------------------------------------------------------
%
%   See also UNIQUE, RANDPERM, FINDGROUPS.

    arguments
        T table
        Observation (1,1) string
        Factors (1,:) string
        Replicate (1,1) string
        FactorShuffleMask (1,:) logical
        options.shuffleReplicates (1,1) logical = false
    end

    % Validation: Mask length must match Factors length
    if length(FactorShuffleMask) ~= length(Factors)
        error('permuteReplicates:InputMismatch', ...
            'Length of FactorShuffleMask (%d) must match length of Factors (%d).', ...
            length(FactorShuffleMask), length(Factors));
    end

    %% 1. Handling Naive Shuffle (Destructive Mode)
    if options.shuffleReplicates
        warning('permuteReplicates:DestructiveShuffle', ...
            'Running Naive Shuffle: Random Effect structure is being destroyed.');
        T_shuffled = T;
        % Simple random permutation of the Observation column only
        T_shuffled.(Observation) = T.(Observation)(randperm(height(T)));
        return;
    end

    %% 2. Preparation: Collapse to Units
    
    % Identify Stratifiers vs Targets
    stratifyCols = Factors(~FactorShuffleMask);
    targetCols = Factors(FactorShuffleMask);
    
    % Extract the structural columns
    colsToExtract = [Replicate, Factors];
    
    % CRITICAL: Use the 3rd output of UNIQUE (J)
    % J maps every row in T to a row in unitTable.
    % This allows us to reconstruct T without needing 'join', which fixes
    % issues with Crossed Designs (duplicate keys).
    [unitTable, ~, J] = unique(T(:, colsToExtract), 'rows');
    
    % Informational Check for Crossed Designs
    uniqueUnits = unique(T.(Replicate));
    if height(unitTable) > length(uniqueUnits)
        % This is valid for crossed designs, so we proceed silently or 
        % with a verbose flag if desired. The logic below handles it fine.
    end

    %% 3. Perform the Permutation
    
    % If there are stratifiers, we group by them.
    if ~isempty(stratifyCols)
        [G, ~] = findgroups(unitTable(:, stratifyCols));
    else
        % No stratifiers, everyone is in Group 1
        G = ones(height(unitTable), 1); 
    end
    
    % Iterate through groups and permute the Target Columns
    numGroups = max(G);
    for i = 1:numGroups
        idx = (G == i); % Logical index for rows in unitTable belonging to this group
        
        % How many units in this group?
        nUnits = sum(idx);
        
        % We can only shuffle if there are at least 2 units to swap
        if nUnits > 1
            % Isolate the data to swap
            targetData = unitTable{idx, targetCols};
            
            % Generate random order
            shuffledOrder = randperm(nUnits);
            
            % Assign back in shuffled order
            unitTable{idx, targetCols} = targetData(shuffledOrder, :);
        end
    end
    
    %% 4. Reconstruction (Fast Indexing)
    
    T_shuffled = T;
    
    % We map the scrambled labels back to the original rows using J.
    % This maps the exact shuffled Factor combination back to every observation
    % that originally belonged to that Replicate-Condition pair.
    T_shuffled(:, Factors) = unitTable(J, Factors);
    
end
