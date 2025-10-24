classdef teststruct2tabstr < matlab.unittest.TestCase
    methods (Test)
        function testSimpleStruct(testCase)
            % Test a simple struct
            S = struct('field1', 'value1', 'field2', 10);
            expectedStr = sprintf('field1\tfield2\n''value1''\t[10]');
            actualStr = vlt.data.struct2tabstr(S);
            testCase.verifyEqual(actualStr, expectedStr);
        end

        function testStructArray(testCase)
            % Test an array of structs
            S = [ ...
                struct('field1', 'value1', 'field2', 10); ...
                struct('field1', 'value2', 'field2', 20) ...
            ];
            expectedStr = sprintf('field1\tfield2\n''value1''\t[10]\n''value2''\t[20]');
            actualStr = vlt.data.struct2tabstr(S);
            testCase.verifyEqual(actualStr, expectedStr);
        end
    end
end