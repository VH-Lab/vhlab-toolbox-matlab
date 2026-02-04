classdef testInjectEffectToTable < matlab.unittest.TestCase
    
    methods (Test)
        
        function testBasicNumericInjection(testCase)
            % SCENARIO: Simple numeric factor, add +10.0 to Group 1.
            
            % 1. Setup
            T = table();
            T.Group = [1; 1; 2; 2];
            T.Y = [10; 20; 10; 20];
            
            targetFactor = "Group";
            targetLevel = 1;
            effectSize = 5.5;
            
            % 2. Run
            T_out = vlt.stats.injectEffectToTable(T, "Y", targetFactor, targetLevel, effectSize);
            
            % 3. Verify Target Group (Group 1 should increase by 5.5)
            % Expected: [15.5; 25.5]
            actualY_G1 = T_out.Y(T_out.Group == 1);
            expectedY_G1 = T.Y(T.Group == 1) + effectSize;
            
            testCase.verifyEqual(actualY_G1, expectedY_G1, ...
                'Signal was not correctly added to the target group.');
            
            % 4. Verify Non-Target Group (Group 2 should be untouched)
            actualY_G2 = T_out.Y(T_out.Group == 2);
            expectedY_G2 = T.Y(T.Group == 2);
            
            testCase.verifyEqual(actualY_G2, expectedY_G2, ...
                'Signal leaked into non-target group.');
        end
        
        function testStringFactorInjection(testCase)
            % SCENARIO: Factor is a string array ("DrugA", "DrugB").
            
            T = table();
            T.Drug = ["DrugA"; "DrugB"; "DrugA"; "DrugC"];
            T.Outcome = [0; 0; 0; 0];
            
            % Inject -20 into DrugA
            T_out = vlt.stats.injectEffectToTable(T, "Outcome", "Drug", "DrugA", -20);
            
            % Verify DrugA rows are -20
            isTarget = (T.Drug == "DrugA");
            testCase.verifyEqual(T_out.Outcome(isTarget), repmat(-20, sum(isTarget), 1), ...
                'Failed to target string labels correctly.');
            
            % Verify others are 0
            testCase.verifyEqual(T_out.Outcome(~isTarget), zeros(sum(~isTarget), 1), ...
                'Non-target strings were modified.');
        end
        
        function testCategoricalFactorInjection(testCase)
            % SCENARIO: Factor is categorical (common in stats tables).
            
            T = table();
            T.Condition = categorical(["Control"; "Treatment"; "Control"]);
            T.Y = [100; 100; 100];
            
            % Inject +50 to Treatment
            % Note: passing string "Treatment" should work against categorical column
            % if equality check handles it, but safer to pass categorical or let Matlab cast.
            % The function uses (T.Col == Level), which works for string-vs-categorical.
            
            T_out = vlt.stats.injectEffectToTable(T, "Y", "Condition", "Treatment", 50);
            
            testCase.verifyEqual(T_out.Y(2), 150, 'Failed to inject into categorical target.');
            testCase.verifyEqual(T_out.Y([1,3]), [100; 100], 'Leaked into categorical control.');
        end
        
        function testNoTargetsWarning(testCase)
            % SCENARIO: User makes a typo in the target level (e.g. "DrugX" doesn't exist).
            % Should issue a warning but return table unmodified.
            
            T = table();
            T.Drug = ["A"; "B"];
            T.Y = [1; 2];
            
            % Verify the specific warning ID
            testCase.verifyWarning(@() ...
                vlt.stats.injectEffectToTable(T, "Y", "Drug", "Drug_Typo", 10), ...
                'injectEffectToTable:NoTargetsFound');
            
            % Verify data is unchanged
            % We suppress warning just for this call to check output
            warning('off', 'injectEffectToTable:NoTargetsFound');
            T_out = vlt.stats.injectEffectToTable(T, "Y", "Drug", "Drug_Typo", 10);
            warning('on', 'injectEffectToTable:NoTargetsFound');
            
            testCase.verifyEqual(T_out.Y, T.Y, 'Table should be unchanged if target not found.');
        end
        
        function testValidationErrors(testCase)
            % SCENARIO: Input validation failures.
            
            T = table();
            T.Group = ["A"; "B"];
            T.Y_Text = ["High"; "Low"]; % Non-numeric observation
            T.Y_Num = [1; 2];
            
            % 1. Missing Column
            testCase.verifyError(@() ...
                vlt.stats.injectEffectToTable(T, "Y_Num", "MissingCol", "A", 10), ...
                'injectEffectToTable:MissingColumn');
                
            % 2. Non-Numeric Observation
            testCase.verifyError(@() ...
                vlt.stats.injectEffectToTable(T, "Y_Text", "Group", "A", 10), ...
                'injectEffectToTable:NonNumericObservation');
        end
        
    end
end