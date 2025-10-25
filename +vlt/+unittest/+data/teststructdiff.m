classdef teststructdiff < matlab.unittest.TestCase
    methods (Test)
        function testSimpleDiff(testCase)
            % Test a simple difference between two structs, should return false (0)
            S1 = struct('field1', 'value1', 'field2', 10);
            S2 = struct('field1', 'value1', 'field2', 20);

            D = vlt.data.structdiff(S1, S2);

            testCase.verifyFalse(logical(D));
        end

        function testNoDiff(testCase)
            % Test when there is no difference, should return true (1)
            S1 = struct('field1', 'value1', 'field2', 10);
            S2 = struct('field1', 'value1', 'field2', 10);

            D = vlt.data.structdiff(S1, S2);

            testCase.verifyTrue(logical(D));
        end

        function testMissingFields(testCase)
            % Test when fields are missing from one of the structs, should return false (0)
            S1 = struct('field1', 'value1', 'field2', 10);
            S2 = struct('field1', 'value1');

            D = vlt.data.structdiff(S1, S2);

            testCase.verifyFalse(logical(D));
        end

        function testAsymmetricBehavior(testCase)
            % Test that the function ignores extra fields in the second struct
            S1 = struct('field1', 'value1');
            S2 = struct('field1', 'value1', 'field2', 10);

            D = vlt.data.structdiff(S1, S2);

            testCase.verifyTrue(logical(D));
        end
    end
end