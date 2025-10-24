classdef teststructdiff < matlab.unittest.TestCase
    methods (Test)
        function testSimpleDiff(testCase)
            % Test a simple difference between two structs
            S1 = struct('field1', 'value1', 'field2', 10);
            S2 = struct('field1', 'value1', 'field2', 20);

            D = vlt.data.structdiff(S1, S2);

            expected = struct('field2', {{10, 20}});

            testCase.verifyEqual(D, expected);
        end

        function testNoDiff(testCase)
            % Test when there is no difference
            S1 = struct('field1', 'value1', 'field2', 10);
            S2 = struct('field1', 'value1', 'field2', 10);

            D = vlt.data.structdiff(S1, S2);

            testCase.verifyTrue(isstruct(D) && isempty(fieldnames(D)));
        end

        function testMissingFields(testCase)
            % Test when fields are missing from one of the structs
            S1 = struct('field1', 'value1', 'field2', 10);
            S2 = struct('field1', 'value1');

            D = vlt.data.structdiff(S1, S2);

            % Note: This function doesn't handle missing fields, it will error
            % We will test that it errors as expected
            testCase.verifyError(@() vlt.data.structdiff(S1, S2), 'MATLAB:nonExistentField');
        end
    end
end