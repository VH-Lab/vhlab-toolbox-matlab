function T_injected = injectEffectToTable(T, Observation, TargetFactor, TargetLevel, EffectSize)
% INJECTEFFECTTOTABLE Adds a synthetic signal to a specific experimental group.
%
%   T_injected = injectEffectToTable(T, Observation, TargetFactor, TargetLevel, EffectSize)
%
%   PURPOSE:
%   This function simulates a specific biological effect size (H1) for Power 
%   Analysis. It adds a constant scalar value (signal) to the dependent 
%   variable (Observation) for all rows belonging to a specific group.
%
%   This is typically used in a "Shuffle-First" workflow:
%     1. Permute the data to create a Null (H0) state (Zero Effect).
%     2. Inject a known signal using this function to create an H1 state.
%     3. Run the statistical model to see if it detects the signal.
%
%   INPUTS:
%   T (Table)
%       The input data table containing observations.
%
%   Observation (String)
%       The column name of the dependent variable (Y). 
%       This column must be numeric.
%
%   TargetFactor (String)
%       The column name of the Fixed Factor to manipulate (e.g., "Drug").
%
%   TargetLevel (String, Numeric, or Logical)
%       The specific group label within TargetFactor to receive the signal 
%       (e.g., "Drug_A" or 1). The data type must match the type of the 
%       column in the table.
%
%   EffectSize (Double)
%       The magnitude of the signal to add. 
%       (e.g., +5.5 adds 5.5 units to the Observation).
%
%   OUTPUTS:
%   T_injected (Table)
%       The modified table with the signal added to the targeted rows.
%
%   -----------------------------------------------------------------------
%   EXAMPLE USAGE:
%   -----------------------------------------------------------------------
%   Suppose you have a table 'experimentData' (N=100) from a pilot study.
%   You want to calculate the power to detect a +10ms increase in reaction
%   time caused by 'Drug_C'.
%
%       % 1. Create a "Blank Slate" (Remove existing effects via shuffle)
%       T_null = vlt.stats.permuteReplicates(experimentData, "ReactionTime", ...
%                ["Strain", "Drug"], "MouseID", [1, 1]);
%
%       % 2. Inject the synthetic signal (+10) into the 'Drug_C' group
%       effectSize = 10;
%       T_sim = vlt.stats.injectEffectToTable(T_null, "ReactionTime", ...
%               "Drug", "Drug_C", effectSize);
%
%       % 3. Fit Model (H1)
%       lme = fitlme(T_sim, 'ReactionTime ~ Strain + Drug + (1|MouseID)');
%
%   -----------------------------------------------------------------------
%
%   See also VLT.STATS.PERMUTEREPLICATES.

    arguments
        T table
        Observation (1,1) string
        TargetFactor (1,1) string
        TargetLevel (1,1) % Flexible type (accepts string, double, categorical)
        EffectSize (1,1) double
    end

    %% 1. Input Validation
    
    % Ensure the Observation column is numeric so we can do math on it
    if ~isnumeric(T.(Observation))
        error('injectEffectToTable:NonNumericObservation', ...
            'The Observation column "%s" must be numeric to add an effect size.', ...
            Observation);
    end

    % Ensure the TargetFactor column exists
    if ~ismember(TargetFactor, T.Properties.VariableNames)
        error('injectEffectToTable:MissingColumn', ...
            'The TargetFactor column "%s" does not exist in the table.', ...
            TargetFactor);
    end

    %% 2. Identify Target Rows
    
    % We use logical indexing to find the rows matching the TargetLevel.
    % This works for Strings, Categoricals, and Numbers.
    targetRows = (T.(TargetFactor) == TargetLevel);
    
    %% 3. Safety Check: Did we find anything?
    
    % Common bug: User passes "DrugA" (string) but column is categorical,
    % or user passes "1" (string) but column is numeric double.
    if ~any(targetRows)
        warning('injectEffectToTable:NoTargetsFound', ...
            ['No rows matched TargetFactor="%s" == TargetLevel="%s". ' ...
             'No effect was injected. Check data types and spelling.'], ...
            TargetFactor, string(TargetLevel));
    end

    %% 4. Inject Signal
    
    T_injected = T;
    
    % Add the EffectSize to the existing values
    T_injected.(Observation)(targetRows) = ...
        T_injected.(Observation)(targetRows) + EffectSize;

end
