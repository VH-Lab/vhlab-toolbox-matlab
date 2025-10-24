classdef teststructfullfields < matlab.unittest.TestCase
    methods (Test)
        function testAllFieldsPresent(testCase)
            % Test when all requested fields are already in the struct
            S = struct('field1', 'value1', 'field2', 10);
            fields = {'field1', 'field2'};

            S_full = vlt.data.structfullfields(S, fields);

            testCase.verifyEqual(S_full, S);
        end

        function testMissingFields(testCase)
            % Test when some requested fields are missing
            S = struct('field1', 'value1');
            fields = {'field1', 'field2'};

            S_full = vlt.data.structfullfields(S, fields);

            expected = struct('field1', 'value1', 'field2', []);
            testCase.verifyEqual(S_full, expected);
        end

        function testEmptyStructInput(testCase)
            % Test when the input struct is empty
            S = struct();
            fields = {'field1', 'field2'};

            S_full = vlt.data.structfullfields(S, fields);

            expected = struct('field1', [], 'field2', []);
            testCase.verifyEqual(S_full, expected);
        end

        function testEmptyFieldsList(testCase)
            % Test when the list of fields is empty
            S = struct('field1', 'value1');
            fields = {};

            S_full = vlt.data.structfullfields(S, fields);

            % Should return an empty struct with no fields
            testCase.verifyTrue(isstruct(S_full) && isempty(fieldnames(S_full)));
        end
    end
end