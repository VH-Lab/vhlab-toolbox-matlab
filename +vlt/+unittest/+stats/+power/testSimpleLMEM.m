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