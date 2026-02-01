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
%   EffectSize (Numeric Vector)
%       The magnitude(s) of the signal to inject.
%       If a vector is provided, power is calculated for each effect size.
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
%       If true, prints progress to command line.
%   'useProgressBar' (Boolean, Default: true)
%       If true, displays a graphical waitbar (only in serial mode).
%   'useRanks' (Boolean, Default: false)
%       If true, transforms the Observation values to ranks before computing.
%   'useLog' (Boolean, Default: false)
%       If true, transforms the Observation values to log10 before computing.
%   'useParallel' (Boolean, Default: true)
%       If true, uses parfor to run simulations in parallel.
%
%   OUTPUTS:
%   stats (Struct)
%       .power        - Vector of fractions of simulations with p < Alpha (one per EffectSize)
%       .pValues      - Matrix of p-values (Simulations x NumEffectSizes)
%       .successCount - Vector of number of significant hits
%       .simulations  - Vector of total valid simulations run
%       .formula      - The LMEM formula used
%       .effectSize   - The input EffectSize vector
%
%   EXAMPLE:
%       mask = [0, 1]; % Stratify Strain, Shuffle Drug
%       res = vlt.stats.power.simpleLMEM(data, "ReactionTime", "MouseID", ...
%             ["Strain", "Drug"], mask, "Drug", "Drug_A", [0, 5, 10], ...
%             'useInteractionTerms', true, 'useParallel', true);
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
        EffectSize double {mustBeVector}
        options.Simulations (1,1) double {mustBeInteger, mustBePositive} = 1000
        options.Alpha (1,1) double {mustBeInRange(options.Alpha, 0, 1)} = 0.05
        options.useConstantTerm (1,1) logical = true
        options.useInteractionTerms (1,1) logical = false
        options.verbose (1,1) logical = false
        options.useProgressBar (1,1) logical = true
        options.useRanks (1,1) logical = false
        options.useLog (1,1) logical = false
        options.useParallel (1,1) logical = true
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

    % Apply Transformations
    if options.useLog
        if any(T.(obsCol) <= 0)
            warning('simpleLMEM:LogNegative', 'Log10 requested but data contains <= 0 values. Results may be complex or NaN.');
        end
        T.(obsCol) = log10(T.(obsCol));
    end

    if options.useRanks
        T.(obsCol) = vlt.stats.ranks(T.(obsCol));
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
    
    numES = numel(EffectSize);
    pValues = zeros(options.Simulations, numES);
    
    % Setup Progress Bar (Only for serial mode)
    wb = [];
    useWB = options.useProgressBar && options.Simulations > 10 && ~options.useParallel;
    if useWB
        wb = waitbar(0, sprintf('Running %d Simulations...', options.Simulations));
        cleanUp = onCleanup(@() delete(wb)); % Ensure closure on error/exit
    end
    
    startTime = tic;
    
    if options.useParallel
        parfor i = 1:options.Simulations
            pValues(i, :) = simulationWorker(T, obsCol, FixedFactors, Replicate, FactorShuffleMask, ...
                TargetFactor, TargetLevel, EffectSize, formulaFull);
        end
    else
        for i = 1:options.Simulations
            pValues(i, :) = simulationWorker(T, obsCol, FixedFactors, Replicate, FactorShuffleMask, ...
                TargetFactor, TargetLevel, EffectSize, formulaFull);

            % Progress Reporting (Serial only)
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
    end

    %% 3. Compile Statistics

    % Initialize output stats vectors
    stats.power = zeros(1, numES);
    stats.successCount = zeros(1, numES);
    stats.simulations = zeros(1, numES);

    for e = 1:numES
        colP = pValues(:, e);
        validSims = sum(~isnan(colP));
        sigHits = sum(colP < options.Alpha, 'omitnan');
        
        stats.power(e) = sigHits / validSims;
        stats.successCount(e) = sigHits;
        stats.simulations(e) = validSims;
    end

    stats.pValues = pValues;
    stats.formula = formulaFull;
    stats.effectSize = EffectSize;

    if options.verbose
        fprintf('\nPower Analysis Complete.\n');
        for e = 1:numES
             fprintf('Effect Size %.2f: Detected %d/%d (%.2f%%)\n', ...
                 EffectSize(e), stats.successCount(e), stats.simulations(e), stats.power(e) * 100);
        end
    end

end

function pVals = simulationWorker(T, obsCol, FixedFactors, Replicate, FactorShuffleMask, TargetFactor, TargetLevel, EffectSizes, formulaFull)
    % Helper function to run one simulation iteration (shuffle -> loop effect sizes -> fit)

    numES = numel(EffectSizes);
    pVals = NaN(1, numES);

    % A. SANITIZE (Create H0)
    % Shuffle to remove existing effects, respecting the mask.
    T_null = vlt.stats.permuteReplicates(T, obsCol, FixedFactors, ...
                                         Replicate, FactorShuffleMask);

    for e = 1:numES
        es = EffectSizes(e);
        
        % B. INJECT (Create H1)
        % Add the specific signal to the target group.
        T_sim = vlt.stats.injectEffectToTable(T_null, obsCol, ...
                                              TargetFactor, TargetLevel, es);
        
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
                pVals(e) = NaN;
            else
                pVals(e) = pVal;
            end
            
        catch
            % Fit failed
            pVals(e) = NaN;
        end
    end
end
