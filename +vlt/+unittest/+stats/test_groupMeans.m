classdef test_groupMeans < matlab.unittest.TestCase
    methods (Test)
        function testSimpleMean(testCase)
            % Test simple mean calculation with one factor
            % Using char array input
            T = table(['A';'A';'B';'B'], [1;2;3;4], 'VariableNames', {'F1', 'Y'});
            O = vlt.stats.groupMeans(T, 'Y', 'F1');

            % Expected output: A -> mean(1,2)=1.5, B -> mean(3,4)=3.5
            expectedMean = [1.5; 3.5];

            testCase.verifyEqual(O.Mean_Y, expectedMean);
            % Convert to string to compare robustly against char/cellstr differences
            testCase.verifyEqual(string(O.F1), ["A";"B"]);
        end

        function testMultiFactor(testCase)
             % Test with multiple factors using string arrays
             F1 = ["A"; "A"; "B"; "B"];
             F2 = [1; 1; 2; 2];
             Data = [10; 20; 30; 40];
             T = table(F1, F2, Data);

             O = vlt.stats.groupMeans(T, 'Data', ["F1", "F2"]);

             % Row 1: A, 1, 10
             % Row 2: A, 1, 20 -> Group (A,1) mean 15
             % Row 3: B, 2, 30
             % Row 4: B, 2, 40 -> Group (B,2) mean 35

             testCase.verifyEqual(height(O), 2);
             testCase.verifyEqual(O.Mean_Data, [15; 35]);
             testCase.verifyEqual(O.F1, ["A"; "B"]);
             testCase.verifyEqual(O.F2, [1; 2]);
        end

        function testEmpty(testCase)
            % Test with empty table
            T = table([], [], 'VariableNames', {'A', 'Y'});
            O = vlt.stats.groupMeans(T, 'Y', 'A');
            testCase.verifyEmpty(O);
            % Verify column names exist and are in correct order
            expectedCols = {'A', 'Mean_Y'};
            testCase.verifyEqual(O.Properties.VariableNames, expectedCols);
        end

        function testCellStrFactors(testCase)
            % Test with cell array of character vectors for factors
            F1 = {'A'; 'A'; 'B'; 'B'};
            Y = [1; 2; 3; 4];
            T = table(F1, Y);
            % Passing factors as cell array
            O = vlt.stats.groupMeans(T, 'Y', {'F1'});

            expectedMean = [1.5; 3.5];
            testCase.verifyEqual(O.Mean_Y, expectedMean);
            testCase.verifyEqual(O.F1, {'A'; 'B'});
        end
    end
end
