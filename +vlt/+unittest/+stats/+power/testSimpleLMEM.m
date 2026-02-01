classdef testSimpleLMEM < matlab.unittest.TestCase
    
    methods (Test)
        
        function testHighPowerScenario(testCase)
            % SCENARIO: Massive effect size. Power should be 1.0 (100%).
            % This verifies the whole pipeline: Shuffle -> Inject -> Fit -> Detect.
            
            % 1. Setup Data (Small N to keep fitlme fast)
            T = testCase.createTestTable(20); % 20 animals
            
            % 2. Run Analysis
            % Shuffle Drug (Index 2). Inject +100 (Massive).
            % 10 simulations is enough to prove it works for a massive effect.
            stats = vlt.stats.power.simpleLMEM(T, "Y", "AnimalID", ...
                ["Strain", "Drug"], [false, true], "Drug", "DrugB", 100, ...
                'Simulations', 10, 'verbose', false, 'useProgressBar', false);
            
            % 3. Verify
            testCase.verifyEqual(stats.power, 1.0, ...
                'With effect size 100, power should be 100%.');
            testCase.verifyEqual(stats.simulations, 10);
            testCase.verifyEqual(stats.effectSize, 100);
        end
        
        function testIllegalMaskError(testCase)
            % SCENARIO: User tries to test "Drug" but forgets to shuffle it.
            % The function must block this to prevent scientific error.
            
            T = testCase.createTestTable(10);
            
            % Mask: [0, 0] (Strain Fixed, Drug Fixed)
            % Target: "Drug"
            mask = [false, false];
            
            testCase.verifyError(@() ...
                vlt.stats.power.simpleLMEM(T, "Y", "AnimalID", ...
                ["Strain", "Drug"], mask, "Drug", "DrugB", 5), ...
                'simpleLMEM:IllegalMask');
        end
        
        function testFormulaConstruction(testCase)
            % SCENARIO: Verify that options.useInteractionTerms changes the formula.
            
            T = testCase.createTestTable(6);
            
            % 1. Default (Main Effects only: A + B)
            stats = vlt.stats.power.simpleLMEM(T, "Y", "AnimalID", ...
                ["Strain", "Drug"], [false, true], "Drug", "DrugB", 0, ...
                'Simulations', 2, 'useInteractionTerms', false, 'verbose', false);
            
            testCase.verifyTrue(contains(stats.formula, 'Strain + Drug'), ...
                'Default formula should use + (Main Effects).');
            testCase.verifyFalse(contains(stats.formula, 'Strain * Drug'), ...
                'Default formula should NOT use * (Interactions).');
                
            % 2. Interactions (A * B)
            statsInt = vlt.stats.power.simpleLMEM(T, "Y", "AnimalID", ...
                ["Strain", "Drug"], [false, true], "Drug", "DrugB", 0, ...
                'Simulations', 2, 'useInteractionTerms', true, 'verbose', false);
            
            testCase.verifyTrue(contains(statsInt.formula, 'Strain * Drug'), ...
                'Interaction formula should use *.');
        end
        
        function testConstantTermOption(testCase)
            % SCENARIO: Verify useConstantTerm toggles '1' vs '-1'.
            
            T = testCase.createTestTable(6);
            
            % No Constant
            stats = vlt.stats.power.simpleLMEM(T, "Y", "AnimalID", ...
                ["Strain", "Drug"], [false, true], "Drug", "DrugB", 0, ...
                'Simulations', 1, 'useConstantTerm', false, 'verbose', false);
            
            testCase.verifyTrue(contains(stats.formula, '-1 +'), ...
                'Formula should contain -1 when useConstantTerm is false.');
        end
        
        function testTargetNotFound(testCase)
            % SCENARIO: TargetFactor name is a typo.
            T = testCase.createTestTable(10);
            
            testCase.verifyError(@() ...
                vlt.stats.power.simpleLMEM(T, "Y", "AnimalID", ...
                ["Strain", "Drug"], [false, true], "NonExistentFactor", "A", 5), ...
                'simpleLMEM:TargetNotFound');
        end
        
        function testAutoDetectObservation(testCase)
            % SCENARIO: User omits Observation argument. Function should find "Y".
            
            T = testCase.createTestTable(6);
            
            % Call with Observation="" (Empty String) triggers auto-detect
            % We need to use the named argument syntax for this test if we skip the positional one,
            % but the function signature has Observation as 2nd positional.
            % So we pass "" to trigger logic.
            
            stats = vlt.stats.power.simpleLMEM(T, "", "AnimalID", ...
                ["Strain", "Drug"], [false, true], "Drug", "DrugB", 10, ...
                'Simulations', 2, 'verbose', false);
            
            % Formula should now start with "Y ~"
            testCase.verifyTrue(startsWith(stats.formula, 'Y ~'), ...
                'Auto-detect failed to identify column Y.');
        end

        function testArrayEffectSize(testCase)
            % SCENARIO: Provide multiple effect sizes. Check output shapes.
            T = testCase.createTestTable(10);

            effectSizes = [0, 10, 100];
            sims = 5;
            stats = vlt.stats.power.simpleLMEM(T, "Y", "AnimalID", ...
                ["Strain", "Drug"], [false, true], "Drug", "DrugB", effectSizes, ...
                'Simulations', sims, 'verbose', false, 'useProgressBar', false);

            testCase.verifySize(stats.power, [1, 3], 'Power should be a 1x3 vector.');
            testCase.verifySize(stats.pValues, [sims, 3], 'pValues should be Simulations x 3.');
            testCase.verifySize(stats.successCount, [1, 3]);
            testCase.verifySize(stats.simulations, [1, 3]);

            % Power should likely increase (or stay same for 0 vs small, but definitely 100 should be high)
            % Since N is small and data random, just check last one is high
            testCase.verifyGreaterThanOrEqual(stats.power(3), stats.power(1), ...
                'Power for EffectSize=100 should be >= Power for EffectSize=0');
        end

        function testUseLog(testCase)
            % SCENARIO: Use Log transformation.
            % We use positive data.
            T = testCase.createTestTable(10);
            T.Y = abs(T.Y) + 1; % Ensure positive

            % Just verify it runs without error and produces results
            stats = vlt.stats.power.simpleLMEM(T, "Y", "AnimalID", ...
                ["Strain", "Drug"], [false, true], "Drug", "DrugB", 5, ...
                'Simulations', 2, 'useLog', true, 'verbose', false);

            testCase.verifyTrue(isstruct(stats));
        end

        function testUseRanks(testCase)
            % SCENARIO: Use Rank transformation.
            T = testCase.createTestTable(10);

            stats = vlt.stats.power.simpleLMEM(T, "Y", "AnimalID", ...
                ["Strain", "Drug"], [false, true], "Drug", "DrugB", 5, ...
                'Simulations', 2, 'useRanks', true, 'verbose', false);

             testCase.verifyTrue(isstruct(stats));
        end

        function testUseParallel(testCase)
            % SCENARIO: Verify useParallel true/false both run.
            T = testCase.createTestTable(6);

            % Serial
            statsSerial = vlt.stats.power.simpleLMEM(T, "Y", "AnimalID", ...
                ["Strain", "Drug"], [false, true], "Drug", "DrugB", 5, ...
                'Simulations', 2, 'useParallel', false, 'verbose', false);
            testCase.verifyTrue(isstruct(statsSerial));

            % Parallel (Default)
            % Since we are in an environment where we might not want to wait for pool startup if not already running,
            % this test effectively checks syntax validity of parfor block.
            statsParallel = vlt.stats.power.simpleLMEM(T, "Y", "AnimalID", ...
                ["Strain", "Drug"], [false, true], "Drug", "DrugB", 5, ...
                'Simulations', 2, 'useParallel', true, 'verbose', false);
            testCase.verifyTrue(isstruct(statsParallel));
        end
        
    end
    
    methods (Access = private)
        function T = createTestTable(~, numAnimals)
            % Create a simple balanced design
            % 2 Strains x 2 Drugs
            
            units = (1:numAnimals)';
            strainList = repmat(["C57"; "BalbC"], numAnimals/2, 1);
            drugList = repmat(["DrugA"; "DrugB"], numAnimals/2, 1);
            
            % Shuffle lists to ensure random assignment
            strainList = strainList(randperm(numAnimals));
            drugList = drugList(randperm(numAnimals));
            
            % Create Unit Table
            T_units = table(units, strainList, drugList, ...
                'VariableNames', {'AnimalID', 'Strain', 'Drug'});
            
            % Expand to 5 observations per animal
            T = table();
            for i = 1:height(T_units)
                subT = repmat(T_units(i,:), 5, 1);
                subT.Y = randn(5, 1) + 10; % Random noise + baseline
                T = [T; subT]; %#ok<AGROW>
            end
            
            % Ensure types
            T.AnimalID = string(T.AnimalID);
        end
    end
end