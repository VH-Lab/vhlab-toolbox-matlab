classdef testPermuteReplicates < matlab.unittest.TestCase
    
    methods (Test)
        
        function testBasicDrugShuffle(testCase)
            % SCENARIO: Shuffle Drug (col 2), stratify by Strain (1) and Therapy (3).
            % We verify that Drug labels move, but Strain/Therapy do not.
            
            % 1. Setup Data
            T = testCase.createTestTable();
            factors = ["Strain", "Drug", "Therapy"];
            replicate = "AnimalID";
            obs = "Y";
            
            % Mask: Shuffle Drug (1), keep others (0)
            mask = [false, true, false];
            
            % 2. Run Function
            T_shuffled = vlt.stats.permuteReplicates(T, obs, factors, replicate, mask);
            
            % 3. Verify Table Shape preserved
            testCase.verifyEqual(size(T), size(T_shuffled), ...
                'Output table size should match input.');
            
            % 4. Verify Stratification (Strain/Therapy should NOT change for any animal)
            % Check that Mouse1 is still the same Strain/Therapy in the new table
            testCase.verifyEqual(T_shuffled.Strain, T.Strain, ...
                'Stratifier (Strain) should not change.');
            testCase.verifyEqual(T_shuffled.Therapy, T.Therapy, ...
                'Stratifier (Therapy) should not change.');
            
            % 5. Verify Target Shuffled (Drug labels CAN change)
            % Note: In a random shuffle, it's possible (though unlikely) to get 
            % the same order. We check that the column is valid, not strictly different.
            uniqueDrugsOrig = unique(T.Drug);
            uniqueDrugsNew = unique(T_shuffled.Drug);
            testCase.verifyEqual(uniqueDrugsNew, uniqueDrugsOrig, ...
                'Set of Drug labels should be preserved.');
            
            % 6. Verify Unit Integrity
            % The observations (Y) for "Mouse1" must be identical to the original
            % observations for "Mouse1". Only the Drug label attached to it changes.
            units = unique(T.AnimalID);
            for i = 1:length(units)
                u = units(i);
                y_orig = sort(T.Y(T.AnimalID == u));
                y_new = sort(T_shuffled.Y(T_shuffled.AnimalID == u));
                
                testCase.verifyEqual(y_new, y_orig, ...
                    sprintf('Observations for unit %s were corrupted.', string(u)));
            end
        end
        
        function testStratificationLogic(testCase)
            % SCENARIO: Ensure we never cross stratification boundaries.
            % If we shuffle Drug within Strain, a "C57" mouse should never
            % receive a Drug label that only exists in the "BalbC" group.
            
            % Setup: Create distinct drugs for distinct strains to prove isolation
            T = table();
            % 10 mice
            T.AnimalID = repelem((1:10)', 5, 1); 
            % Mice 1-5 are C57, Mice 6-10 are BalbC
            isC57 = T.AnimalID <= 5;
            T.Strain = strings(height(T), 1);
            T.Strain(isC57) = "C57";
            T.Strain(~isC57) = "BalbC";
            
            % C57s get Drug A/B. BalbCs get Drug Y/Z.
            T.Drug = strings(height(T), 1);
            % Assign initial drugs
            T.Drug(isC57) = "DrugA"; 
            T.Drug(~isC57) = "DrugY";
            
            % Dummy observation
            T.Y = randn(height(T), 1);
            
            % Shuffle Drug, Stratify by Strain
            mask = [false, true]; % Strain=0, Drug=1
            T_new = vlt.stats.permuteReplicates(T, "Y", ["Strain", "Drug"], "AnimalID", mask);
            
            % VERIFY: C57 mice should NEVER have DrugY or DrugZ
            c57_drugs = unique(T_new.Drug(T_new.Strain == "C57"));
            testCase.verifyTrue(all(ismember(c57_drugs, ["DrugA", "DrugB"])), ...
                'Stratification failed: C57 mouse received a BalbC drug.');
        end
        
        function testNaiveShuffle(testCase)
            % SCENARIO: shuffleReplicates = true
            % This should break the link between AnimalID and Y.
            
            T = testCase.createTestTable();
            factors = ["Strain", "Drug", "Therapy"];
            
            % Mask is ignored in naive shuffle, but required by signature
            mask = [false, false, false]; 
            
            T_naive = vlt.stats.permuteReplicates(T, "Y", factors, "AnimalID", mask, ...
                'shuffleReplicates', true);
            
            % Verify: The set of Y values for Mouse1 should (likely) CHANGE.
            % In the standard shuffle, Y values stay with the mouse.
            % In naive shuffle, Mouse1 gets random Ys from other mice.
            
            u = "Mouse1";
            y_orig = sort(T.Y(T.AnimalID == u));
            y_naive = sort(T_naive.Y(T_naive.AnimalID == u));
            
            % Note: There is a tiny statistical chance they match, 
            % but with doubles and reasonable N, they won't.
            testCase.verifyFalse(isequal(y_orig, y_naive), ...
                'Naive shuffle failed to redistribute observations.');
            
            % Verify column integrity (Y column is a permutation of original)
            testCase.verifyEqual(sort(T.Y), sort(T_naive.Y), ...
                'Naive shuffle corrupted the values in Y (should just reorder).');
        end
        
        function testCustomColumnNames(testCase)
            % SCENARIO: Use weird column names to ensure no hardcoded strings.
            
            T = table();
            T.My_Unit_ID = repelem(["A"; "B"; "C"], 4, 1);
            T.Factor_X = repmat(["Low"; "High"; "Low"], 4, 1);
            T.Outcome_Measure = rand(12, 1);
            
            factors = "Factor_X";
            mask = true; % Shuffle Factor_X
            
            T_shuff = vlt.stats.permuteReplicates(T, "Outcome_Measure", ...
                factors, "My_Unit_ID", mask);
            
            testCase.verifyEqual(height(T), height(T_shuff));
            testCase.verifyTrue(all(ismember(T_shuff.Properties.VariableNames, ...
                ["My_Unit_ID", "Factor_X", "Outcome_Measure"])));
        end
        
        function testInputValidation(testCase)
            % SCENARIO: Mask length mismatch
            T = testCase.createTestTable();
            factors = ["Strain", "Drug"];
            mask = [true, false, true]; % Length 3, Factors 2
            
            testCase.verifyError(@() vlt.stats.permuteReplicates(T, "Y", ...
                factors, "AnimalID", mask), ...
                'permuteReplicates:InputMismatch');
        end
        
    end
    
    methods (Access = private)
        function T = createTestTable(~)
            % Helper to create a standard 2x2x2 design
            % 4 Strains, but let's simplify: 2 Strains, 2 Drugs, 2 Therapies.
            % 8 Groups total. 3 Animals per group. 5 Obs per animal.
            % Total N units = 24. Total N rows = 120.
            
            numGroups = 8;
            unitsPerGroup = 3;
            obsPerUnit = 5;
            
            totalUnits = numGroups * unitsPerGroup;
            
            % Generate Unit Level Data
            units = (1:totalUnits)';
            strainList = ["C57"; "BalbC"];
            drugList = ["DrugA"; "DrugB"];
            therList = ["Ther1"; "Ther2"];
            
            % Create a Full Factorial Design for the groups
            [S, D, Th] = ndgrid(strainList, drugList, therList);
            design = table(S(:), D(:), Th(:), 'VariableNames', {'Strain', 'Drug', 'Therapy'});
            
            % Expand to Units (repeat design 3 times)
            unitData = repmat(design, unitsPerGroup, 1);
            unitData.AnimalID = "Mouse" + string(units);
            
            % Expand to Observations (repeat units 5 times)
            % We use expand/join logic or just repelem
            rowIndices = repelem(1:height(unitData), obsPerUnit)';
            T = unitData(rowIndices, :);
            
            % Add Random Observations
            T.Y = randn(height(T), 1);
        end
    end
end
