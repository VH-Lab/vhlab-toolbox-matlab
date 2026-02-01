function stats = simpleLMEM(T, Observation, Replicate, FixedFactors, FactorShuffleMask, TargetFactor, TargetLevel, EffectSize, options)
% SIMPLELMEM Calculates statistical power for an LMEM using shuffle-based simulation.
%
%   stats = simpleLMEM(T, Observation, Replicate, FixedFactors, Mask, TargetFactor, TargetLevel, EffectSize)
%   stats = simpleLMEM(..., 'Simulations', 1000, 'useInteractionTerms', true)
%
%   PURPOSE:
%   Estimates the statistical power (probability of correctly rejecting H0)
%   for a specific Fixed Factor in a Linear Mixed Effects Model.
%   It uses a "Shuffle-First" workflow to sanitize the pilot data before 
%   injecting the target Effect Size.
%
%   INPUTS:
%   T (Table)
%       Pilot data table.
%   Observation (String)
%       Column name for the dependent variable (Y). 
%       If set to "" (empty string), the function attempts to auto-detect 
%       the first numeric column not listed in FixedFactors or Replicate.
%   Replicate (String)
%       Column name for the Random Effect (e.g., "AnimalID").
%   FixedFactors (String Array)
%       List of Fixed Factors in the model (e.g., ["Strain", "Drug"]).
%   FactorShuffleMask (Logical Array)
%       The shuffle configuration. 1=Shuffle, 0=Stratify.
%       CRITICAL: The index corresponding to TargetFactor MUST be 1.
%   TargetFactor (String)
%       The name of the factor you are testing (e.g., "Drug").
%   TargetLevel (String/Numeric)
%       The specific group to receive the signal (e.g., "Drug_A").
%   EffectSize (Double)
%       The magnitude of the signal to inject.
%
%   OPTIONAL PARAMETERS:
%   'Simulations' (Integer, Default: 1000)
%       Number of iterations.
%   'Alpha' (Double, Default: 0.05)
%       Significance threshold.
%   'useConstantTerm' (Boolean, Default: true)
%       If true, fits 'Y ~ 1 + ...'. If false, fits 'Y ~ -1 + ...' (no intercept).
%   'useInteractionTerms' (Boolean, Default: false)
%       If true, fits full interactions between fixed factors (e.g., 'A*B').
%       If false, fits only main effects (e.g., 'A + B').
%   'verbose' (Boolean, Default: false)
%       If true, prints progress to command line every 20 simulations.
%   'useProgressBar' (Boolean, Default: true)
%       If true, displays a graphical waitbar.
%
%   OUTPUTS:
%   stats (Struct)
%       .power        - Fraction of simulations with p < Alpha
%       .pValues      - Vector of p-values from all simulations
%       .successCount - Number of significant hits
%       .simulations  - Total simulations run
%
%   EXAMPLE:
%       mask = [0, 1]; % Stratify Strain, Shuffle Drug
%       res = vlt.stats.power.simpleLMEM(data, "ReactionTime", "MouseID", ...
%             ["Strain", "Drug"], mask, "Drug", "Drug_A", 5.5, ...
%             'useInteractionTerms', true);
%
%   See also VLT.STATS.PERMUTEREPLICATES, VLT.STATS.INJECTEFFECTTOTABLE.

    arguments
        T table
        Observation (1,1) string
        Replicate (1,1) string
        FixedFactors (1,:) string
        FactorShuffleMask (1,:) logical
        TargetFactor (1,1) string
        TargetLevel (1,1) % polymorphic
        EffectSize (1,1) double
        options.Simulations (1,1) double {mustBeInteger, mustBePositive} = 1000
        options.Alpha (1,1) double {mustBeInRange(options.Alpha, 0, 1)} = 0.05
        options.useConstantTerm (1,1) logical = true
        options.useInteractionTerms (1,1) logical = false
        options.verbose (1,1) logical = false
        options.useProgressBar (1,1) logical = true
    end

    %% 1. Setup and Validation
    
    % --- FIX: Define obsCol based on logic, use obsCol for the rest of the function ---
    obsCol = Observation; 

    % Auto-detect Observation column if not provided
    if obsCol == ""
        % Find numeric columns that are NOT in the factor list or Replicate
        varNames = string(T.Properties.VariableNames);
        isExcluded = ismember(varNames, [FixedFactors, Replicate]);
        isNumeric = varfun(@isnumeric, T, 'OutputFormat', 'uniform');
        candidates = varNames(isNumeric & ~isExcluded);
        
        if isempty(candidates)
            error('simpleLMEM:NoObservation', 'Could not auto-detect a numeric Observation column. Please specify "Observation".');
        end
        obsCol = candidates(1);
        if options.verbose
            fprintf('Auto-selected Observation column: "%s"\n', obsCol);
        end
    end

    % Validate Mask Logic: The Target Factor MUST be shuffled (1)
    targetIdx = find(FixedFactors == TargetFactor);
    if isempty(targetIdx)
        error('simpleLMEM:TargetNotFound', 'TargetFactor "%s" is not in the FixedFactors list.', TargetFactor);
    end
    
    if ~FactorShuffleMask(targetIdx)
        error('simpleLMEM:IllegalMask', ...
            ['Invalid Shuffle Mask. You are calculating power for "%s", ' ...
             'so you MUST shuffle "%s" (set its mask bit to 1) to create a null baseline.'], ...
            TargetFactor, TargetFactor);
    end

    % Construct LMEM Formula
    % Operator: '+' for main effects, '*' for interactions
    if options.useInteractionTerms
        joinOp = ' * ';
    else
        joinOp = ' + ';
    end
    formulaFixed = join(FixedFactors, joinOp);
    
    % Intercept: Add '1 +' or '-1 +' depending on options
    if options.useConstantTerm
        interceptStr = '1';
    else
        interceptStr = '-1';
    end
    
    % Full Formula: Y ~ Intercept + Fixed + (1|Replicate)
    % --- FIX: Use obsCol here ---
    formulaFull = sprintf('%s ~ %s + %s + (1|%s)', ...
        obsCol, interceptStr, formulaFixed, Replicate);

    if options.verbose
        fprintf('Model Formula: %s\n', formulaFull);
    end

    %% 2. Simulation Loop
    
    pValues = zeros(options.Simulations, 1);
    
    % Setup Progress Bar
    wb = [];
    if options.useProgressBar && options.Simulations > 10
        wb = waitbar(0, sprintf('Running %d Simulations...', options.Simulations));
        cleanUp = onCleanup(@() delete(wb)); % Ensure closure on error/exit
    end
    
    startTime = tic;
    
    for i = 1:options.Simulations
        
        % A. SANITIZE (Create H0)
        % Shuffle to remove existing effects, respecting the mask.
        % --- FIX: Use obsCol instead of Observation ---
        T_null = vlt.stats.permuteReplicates(T, obsCol, FixedFactors, ...
                                             Replicate, FactorShuffleMask);
        
        % B. INJECT (Create H1)
        % Add the specific signal to the target group.
        % --- FIX: Use obsCol instead of Observation ---
        T_sim = vlt.stats.injectEffectToTable(T_null, obsCol, ...
                                              TargetFactor, TargetLevel, EffectSize);
        
        % C. FIT MODEL
        try
            lme = fitlme(T_sim, formulaFull, 'Verbose', false);
            
            % D. EXTRACT P-VALUE
            % 'anova' gives main effect/interaction p-values (Type III sums of squares)
            tblAnova = anova(lme, 'DFMethod', 'Satterthwaite');
            
            % Find the row matching the TargetFactor
            pVal = tblAnova.pValue(strcmp(tblAnova.Term, TargetFactor));
            
            if isempty(pVal)
                % Fallback: If term dropped or aliased
                pValues(i) = NaN; 
            else
                pValues(i) = pVal;
            end
            
        catch ME
            % Warn only if verbose to avoid spamming 1000 lines
            if options.verbose
                warning('Fit failed on iteration %d: %s', i, ME.message);
            end
            pValues(i) = NaN;
        end
        
        % Progress Reporting
        if mod(i, 20) == 0
            % Verbose text output
            if options.verbose
                t = toc(startTime);
                estTimeLeft = (t / i) * (options.Simulations - i);
                fprintf('Completed %d / %d simulations (%.1f%%). Est time left: %.1f sec.\n', ...
                    i, options.Simulations, (i/options.Simulations)*100, estTimeLeft);
            end
            
            % Waitbar update
            if ~isempty(wb) && isvalid(wb)
                waitbar(i/options.Simulations, wb);
            end
        end
    end
    
    %% 3. Compile Statistics
    
    validSims = sum(~isnan(pValues));
    sigHits = sum(pValues < options.Alpha, 'omitnan');
    
    stats.power = sigHits / validSims;
    stats.successCount = sigHits;
    stats.simulations = validSims;
    stats.pValues = pValues;
    stats.formula = formulaFull;
    stats.effectSize = EffectSize;
    
    if options.verbose
        fprintf('\nPower Analysis Complete.\n');
        fprintf('Detected Signal: %d/%d times.\n', sigHits, validSims);
        fprintf('Estimated Power: %.2f%%\n', stats.power * 100);
    end

end
