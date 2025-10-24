classdef teststructfullfields < matlab.unittest.TestCase
    methods (Test)
        function testSimpleStruct(testCase)
            % Test a simple struct with no nested fields
            S = struct('field1', 'value1', 'field2', 10);

            fn = structfullfields(S);

            expected = {'field1'; 'field2'};
            testCase.verifyEqual(sort(fn), sort(expected));
        end

        function testNestedStruct(testCase)
            % Test a struct with nested fields
            S = struct('field1', struct('subfield1', 5), 'field2', 10);

            fn = structfullfields(S);

            expected = {'field1'; 'field1.subfield1'; 'field2'};
            testCase.verifyEqual(sort(fn), sort(expected));
        end

        function testEmptyStruct(testCase)
            % Test an empty struct
            S = struct();

            fn = structfullfields(S);

            testCase.verifyTrue(isempty(fn));
        end
    end
end