classdef teststruct2namevaluepair < matlab.unittest.TestCase
    methods (Test)
        function testSimpleStruct(testCase)
            % Test a simple struct
            S = struct('field1', 'value1', 'field2', 10);
            [names, values] = struct2namevaluepair(S);

            expected_names = {'field1'; 'field2'};
            expected_values = {'value1'; 10};

            testCase.verifyEqual(names, expected_names);
            testCase.verifyEqual(values, expected_values);
        end

        function testEmptyStruct(testCase)
            % Test an empty struct
            S = struct();
            [names, values] = struct2namevaluepair(S);

            testCase.verifyTrue(isempty(names));
            testCase.verifyTrue(isempty(values));
        end
    end
end