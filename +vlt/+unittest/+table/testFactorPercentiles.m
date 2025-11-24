classdef testFactorPercentiles < matlab.unittest.TestCase
    % vlt.unittest.table.testFactorPercentiles - Tests for vlt.table.factorPercentiles

    methods (Test)

        function testBasicSingleFactor(testCase)
            % Test with a single grouping factor
            Group = {'A'; 'A'; 'A'; 'B'; 'B'};
            Value = [10; 20; 30; 5; 15];
            T = table(Group, Value);

            T_out = vlt.table.factorPercentiles(T, 'Value', "Group");

            expectedColName = 'Value_Group_PERCENTILE';
            testCase.verifyTrue(ismember(expectedColName, T_out.Properties.VariableNames));

            % Check Group A: 10, 20, 30 -> ranks 1, 2, 3 -> /3 -> 33.3, 66.6, 100
            actualA = T_out.(expectedColName)(strcmp(T_out.Group, 'A'));
            expectedA = [1/3; 2/3; 3/3] * 100;
            testCase.verifyEqual(actualA, expectedA, 'AbsTol', 1e-6);

            % Check Group B: 5, 15 -> ranks 1, 2 -> /2 -> 50, 100
            actualB = T_out.(expectedColName)(strcmp(T_out.Group, 'B'));
            expectedB = [0.5; 1.0] * 100;
            testCase.verifyEqual(actualB, expectedB, 'AbsTol', 1e-6);
        end

        function testTwoFactors(testCase)
            % Test with two grouping factors
            F1 = ["X"; "X"; "X"; "Y"; "Y"];
            F2 = ["1"; "1"; "2"; "1"; "1"];
            % Groups: (X,1)->2 items, (X,2)->1 item, (Y,1)->2 items
            Val = [1; 2; 100; 10; 20];
            T = table(F1, F2, Val);

            T_out = vlt.table.factorPercentiles(T, 'Val', ["F1", "F2"]);

            colName = 'Val_F1_F2_PERCENTILE';

            % (X, 1): vals [1, 2] -> 50, 100
            maskX1 = (T.F1 == "X" & T.F2 == "1");
            testCase.verifyEqual(T_out.(colName)(maskX1), [50; 100], 'AbsTol', 1e-6);

            % (X, 2): vals [100] -> 100
            maskX2 = (T.F1 == "X" & T.F2 == "2");
            testCase.verifyEqual(T_out.(colName)(maskX2), [100], 'AbsTol', 1e-6);

            % (Y, 1): vals [10, 20] -> 50, 100
            maskY1 = (T.F1 == "Y" & T.F2 == "1");
            testCase.verifyEqual(T_out.(colName)(maskY1), [50; 100], 'AbsTol', 1e-6);
        end

        function testTies(testCase)
            % Test handling of tied values
            Group = {'G'; 'G'; 'G'};
            Value = [10; 10; 20]; % Ranks: 1.5, 1.5, 3
            T = table(Group, Value);

            T_out = vlt.table.factorPercentiles(T, 'Value', "Group");

            % 1.5/3 = 0.5 -> 50%
            % 3/3 = 1.0 -> 100%
            expected = [50; 50; 100];
            testCase.verifyEqual(T_out.Value_Group_PERCENTILE, expected, 'AbsTol', 1e-6);
        end

        function testNaNs(testCase)
            % Test with NaN values in data
            Group = {'A'; 'A'; 'A'};
            Value = [10; NaN; 20]; % Ranks: 1, NaN, 2. N=2.
            % 10 -> rank 1 -> 1/2 = 50%
            % 20 -> rank 2 -> 2/2 = 100%
            T = table(Group, Value);

            T_out = vlt.table.factorPercentiles(T, 'Value', "Group");

            output = T_out.Value_Group_PERCENTILE;
            testCase.verifyEqual(output(1), 50, 'AbsTol', 1e-6);
            testCase.verifyTrue(isnan(output(2)));
            testCase.verifyEqual(output(3), 100, 'AbsTol', 1e-6);
        end

        function testEmptyTable(testCase)
            % Test with empty table
            T = table([], [], 'VariableNames', {'A', 'B'});
            T_out = vlt.table.factorPercentiles(T, 'B', "A");
            testCase.verifyTrue(isempty(T_out));
            testCase.verifyTrue(ismember('B_A_PERCENTILE', T_out.Properties.VariableNames));
        end

        function testErrorVariableNotFound(testCase)
            T = table([1;2], [3;4], 'VariableNames', {'A', 'B'});
            testCase.verifyError(@() vlt.table.factorPercentiles(T, 'Z', "A"), ...
                'vlt:table:factorPercentiles:VariableNotFound');
        end

        function testErrorFactorNotFound(testCase)
            T = table([1;2], [3;4], 'VariableNames', {'A', 'B'});
            testCase.verifyError(@() vlt.table.factorPercentiles(T, 'B', "Z"), ...
                'vlt:table:factorPercentiles:FactorNotFound');
        end

        function testErrorDataNotNumeric(testCase)
             T = table({'a';'b'}, [3;4], 'VariableNames', {'A', 'B'});
             testCase.verifyError(@() vlt.table.factorPercentiles(T, 'A', "B"), ...
                'vlt:table:factorPercentiles:DataNotNumeric');
        end
    end
end
