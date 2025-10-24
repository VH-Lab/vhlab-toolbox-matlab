classdef teststruct2tabstr < matlab.unittest.TestCase
    methods (Test)
        function testSimpleStruct(testCase)
            % Test a simple struct
            S = struct('field1', 'value1', 'field2', 10);
            expectedStr = sprintf('value1\t[10]');
            actualStr = vlt.data.struct2tabstr(S);
            testCase.verifyEqual(actualStr, expectedStr);
        end

        function testStructArray(testCase)
            % Test an array of structs
            S = [ ...
                struct('field1', 'value1', 'field2', 10); ...
                struct('field1', 'value2', 'field2', 20) ...
            ];
            % The function only processes the first element of a struct array
            expectedStr = sprintf('value1\t[10]');
            actualStr = vlt.data.struct2tabstr(S);
            testCase.verifyEqual(actualStr, expectedStr);
        end
    end
end