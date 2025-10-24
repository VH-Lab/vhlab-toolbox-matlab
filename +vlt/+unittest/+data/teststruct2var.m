classdef teststruct2var < matlab.unittest.TestCase
    methods (Test)
        function testSimpleStruct(testCase)
            % Test a simple struct
            S = struct('field1', 'value1', 'field2', 10);

            vlt.data.struct2var(S);

            testCase.verifyEqual(field1, 'value1');
            testCase.verifyEqual(field2, 10);

            % Clean up the variables
            clear field1 field2;
        end

        function testOverwrite(testCase)
            % Test that it overwrites existing variables
            field1 = 'old_value';
            S = struct('field1', 'new_value');

            vlt.data.struct2var(S);

            testCase.verifyEqual(field1, 'new_value');

            % Clean up
            clear field1;
        end
    end
end