function simpleLMEMDemo(EffectSizes, doPlot)
% SIMPLELMEMDEMO Demonstrates the functionality of vlt.stats.power.simpleLMEM
%
%   vlt.stats.power.simpleLMEMDemo()
%   vlt.stats.power.simpleLMEMDemo(EffectSizes, doPlot)
%
%   This demo simulates a typical 3-Factor experiment (Strain x Drug x Therapy)
%   with repeated measures on animals (Animal_ID).
%   It calculates the statistical power to detect a specific Drug effect 
%   assuming a "Shuffle-First" workflow.

    arguments
        EffectSizes (1,:) double = [0 1 2 3]
        doPlot (1,1) logical = true
    end

    clc;
    fprintf('=======================================================\n');
    fprintf('   vlt.stats.power.simpleLMEM Demonstration\n');
    fprintf('=======================================================\n\n');

    %% 1. Generate Simulated Data
    fprintf('1. Generating simulated pilot data...\n');
    
    % Experimental Design Parameters
    nStrains = 2;   % C57, BalbC
    nDrugs = 2;     % Vehicle, DrugA
    nTherapy = 2;   % None, CBT
    nAnimalsPerGroup = 5; 
    nObsPerAnimal = 10;
    
    % Create Factor Lists
    strains = ["C57", "BalbC"];
    drugs = ["Vehicle", "DrugA"];
    therapies = ["None", "CBT"];
    
    % Build the Table
    T = table();
    animalCount = 0;
    
    for s = 1:nStrains
        for d = 1:nDrugs
            for t = 1:nTherapy
                % For this specific group...
                for k = 1:nAnimalsPerGroup
                    animalCount = animalCount + 1;
                    animalID = "Mouse_" + string(animalCount);
                    
                    % Generate observations for this animal
                    % Baseline + Random Animal Variance + Observation Noise
                    animalBaseline = randn * 2; % Random intercept (SD=2)
                    noise = randn(nObsPerAnimal, 1) * 1; % Residual (SD=1)
                    
                    % Combine into sub-table
                    subT = table();
                    subT.Animal_ID = repmat(animalID, nObsPerAnimal, 1);
                    subT.Strain = repmat(strains(s), nObsPerAnimal, 1);
                    subT.Drug = repmat(drugs(d), nObsPerAnimal, 1);
                    subT.Therapy = repmat(therapies(t), nObsPerAnimal, 1);
                    subT.ReactionTime = 100 + animalBaseline + noise; 
                    
                    T = [T; subT]; %#ok<AGROW>
                end
            end
        end
    end
    
    fprintf('   Created table with %d rows (Observations) and %d unique Animals.\n', ...
        height(T), length(unique(T.Animal_ID)));
    disp(head(T));
    fprintf('\n');

    %% 2. Configure Power Analysis
    fprintf('2. Configuring Power Analysis...\n');
    
    % We want to find the power to detect a "Drug" effect of +5.0 units.
    % We must CONTROL for Strain and Therapy (Stratify them), 
    % but SHUFFLE Drug to create the null baseline.
    
    factors = ["Strain", "Drug", "Therapy"];
    targetFactor = "Drug";
    targetLevel = "DrugA";
    
    % Mask: 0=Stratify, 1=Shuffle
    % Strain(0), Drug(1), Therapy(0)
    shuffleMask = [false, true, false]; 
    
    fprintf('   Target Factor: "%s" (Level: %s)\n', targetFactor, targetLevel);
    fprintf('   Effect Sizes:   %s\n', mat2str(EffectSizes));
    fprintf('   Shuffle Mask:  [%d, %d, %d] (Shuffle Drug only)\n', shuffleMask);
    fprintf('\n');

    %% 3. Run Analysis
    fprintf('3. Running Simulation (100 Iterations for speed)...\n');
    
    % Calling the function with verbose=true
    stats = vlt.stats.power.simpleLMEM(T, "ReactionTime", "Animal_ID", ...
        factors, shuffleMask, targetFactor, targetLevel, EffectSizes, ...
        'Simulations', 100, ...         % Low count for demo speed
        'verbose', true, ...            % Print progress
        'useProgressBar', true, ...     % Show GUI bar
        'useInteractionTerms', false);  % Simple additive model
        
    %% 4. Display Results
    fprintf('\n=======================================================\n');
    fprintf('   RESULTS\n');
    fprintf('=======================================================\n');
    fprintf('Formula Used:    %s\n', stats.formula);

    for i = 1:length(stats.effectSize)
        fprintf('Effect Size %.2f -> Power: %.1f%% (Successes: %d/%d)\n', ...
            stats.effectSize(i), stats.power(i)*100, stats.successCount(i), stats.simulations(i));
    end
    fprintf('=======================================================\n');
    
    % Optional: Plot
    if doPlot
        figure;
        if length(EffectSizes) > 1
            % Plot Power Curve
            plot(stats.effectSize, stats.power * 100, '-o', 'LineWidth', 2);
            title('Power Analysis Curve');
            xlabel('Effect Size (Added Signal)');
            ylabel('Power (%)');
            grid on;
            ylim([-5 105]);
        else
            % Plot p-value distribution for single effect size
            histogram(stats.pValues, 20);
            title(['P-Value Distribution (ES=' num2str(stats.effectSize) ', Power = ' num2str(stats.power*100) '%)']);
            xlabel('p-value');
            ylabel('Frequency');
            xline(0.05, 'r--', 'Significance Threshold');
        end
    end

end
