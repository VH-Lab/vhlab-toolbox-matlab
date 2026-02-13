classdef testPairwiseHedgesG < matlab.unittest.TestCase

    methods (Test)

        function testSingleFactor(testCase)
            % Single factor with 2 levels
            T = table([1; 1; 2; 2], [10; 12; 20; 22], 'VariableNames', {'Group', 'Value'});

            O = vlt.stats.pairwiseHedgesG(T, 'Value', 'Group');

            % Should have 1 row: 1 vs 2
            testCase.verifyEqual(height(O), 1, 'Should have 1 pair');
            testCase.verifyEqual(O.Group{1}, '1 vs 2');
            testCase.verifyEqual(O.DependentVariable{1}, 'Value');

            % Check value: Group 1 (10,12) -> mean 11, var 2.
            % Group 2 (20,22) -> mean 21, var 2.
            % pooled var 2. pooled std sqrt(2) ~ 1.414.
            % d = (11-21)/1.414 = -10/1.414 = -7.07.
            % J = 1 - 3/(4*4-9) = 1 - 3/7 = 4/7 ~ 0.57.
            % g ~ -4.

            expectedG = vlt.stats.hedgesG([10; 12], [20; 22]);
            testCase.verifyEqual(O.HedgesG(1), expectedG, 'AbsTol', 1e-10);
        end

        function testMultiFactor(testCase)
            % Two factors, 2x2 design
            % F1: A, B. F2: X, Y.
            % Groups: AX, AY, BX, BY.
            % 4 groups -> 6 pairs.

            F1 = {'A'; 'A'; 'B'; 'B'};
            F2 = {'X'; 'Y'; 'X'; 'Y'};
            Value = [1; 2; 3; 4]; % dummy values
            % Each group has 1 sample -> HedgesG returns NaN (variance undefined).
            % So let's duplicate rows to allow variance calc.
            F1 = [F1; F1];
            F2 = [F2; F2];
            Value = [Value; Value];

            T = table(F1, F2, Value, 'VariableNames', {'F1', 'F2', 'Data'});

            O = vlt.stats.pairwiseHedgesG(T, 'Data', {'F1', 'F2'});

            testCase.verifyEqual(height(O), 6, 'Should have 6 pairs for 4 groups');

            % Check formatting for specific pair: AX vs AY
            % F1 is A vs A -> A
            % F2 is X vs Y -> X vs Y

            % Find row corresponding to AX vs AY
            % Groups are sorted by findgroups: A,X (1); A,Y (2); B,X (3); B,Y (4).
            % Pair (1,2) corresponds to AX vs AY.
            % O row 1 should be this pair because nchoosek output is sorted (1,2), (1,3)...

            row1 = O(1, :);
            testCase.verifyEqual(row1.F1{1}, 'A', 'Common factor level should be single value');
            testCase.verifyEqual(row1.F2{1}, 'X vs Y', 'Different factor level should be "Val1 vs Val2"');

            % Check pair AX vs BX (1,3)
            % F1: A vs B
            % F2: X vs X -> X
            % This is usually row 2: (1,3).
            row2 = O(2, :);
            testCase.verifyEqual(row2.F1{1}, 'A vs B');
            testCase.verifyEqual(row2.F2{1}, 'X');
        end

        function testStringFactorInput(testCase)
            % Test passing factors as string array
            T = table([1; 1; 2; 2], [10; 12; 20; 22], 'VariableNames', {'Group', 'Value'});
            factors = "Group";
            O = vlt.stats.pairwiseHedgesG(T, 'Value', factors);
            testCase.verifyEqual(height(O), 1);
            testCase.verifyEqual(O.Group{1}, '1 vs 2');
        end

        function testInsufficientGroups(testCase)
            % Only 1 group
            T = table([1; 1], [10; 12], 'VariableNames', {'Group', 'Value'});
            O = vlt.stats.pairwiseHedgesG(T, 'Value', 'Group');
            testCase.verifyEqual(height(O), 0, 'Should return empty table for <2 groups');
        end

        function testNaNDependentVariable(testCase)
            % NaN values in dependent variable should be ignored by hedgesG
            % Groups 1 and 2
            T = table([1; 1; 2; 2], [10; NaN; 20; 22], 'VariableNames', {'Group', 'Value'});
            % Group 1: 10 (and NaN). Group 2: 20, 22.
            % Group 1 has only 1 valid value -> HedgesG returns NaN.

            O = vlt.stats.pairwiseHedgesG(T, 'Value', 'Group');
            testCase.verifyTrue(isnan(O.HedgesG(1)), 'Should result in NaN due to insufficient data after NaN removal');
        end

         function testNumericFactorsFormat(testCase)
            % Numeric factors should be formatted as strings "1 vs 2"
            T = table([10; 10; 20; 20], [1; 2; 3; 4], 'VariableNames', {'NumGroup', 'Value'});
            O = vlt.stats.pairwiseHedgesG(T, 'Value', 'NumGroup');
            testCase.verifyEqual(O.NumGroup{1}, '10 vs 20');
        end
    end
end
