classdef teststructpartialmatch < matlab.unittest.TestCase
    methods (Test)
        function testMatchingStructs(testCase)
            % Test when struct B is a partial match of struct A
            A = struct('field1', 'value1', 'field2', 10);
            B = struct('field2', 10);

            result = vlt.data.structpartialmatch(A, B);

            testCase.verifyTrue(logical(result));
        end

        function testNonMatchingValue(testCase)
            % Test when a field exists but the value is different
            A = struct('field1', 'value1', 'field2', 10);
            B = struct('field2', 20);

            result = vlt.data.structpartialmatch(A, B);

            testCase.verifyFalse(logical(result));
        end

        function testNonMatchingField(testCase)
            % Test when a field in B is not in A
            A = struct('field1', 'value1', 'field2', 10);
            B = struct('field3', 10);

            result = vlt.data.structpartialmatch(A, B);

            testCase.verifyFalse(logical(result));
        end

        function testIdenticalStructs(testCase)
            % Test when the structs are identical
            A = struct('field1', 'value1', 'field2', 10);
            B = struct('field1', 'value1', 'field2', 10);

            result = vlt.data.structpartialmatch(A, B);

            testCase.verifyTrue(logical(result));
        end
    end
end