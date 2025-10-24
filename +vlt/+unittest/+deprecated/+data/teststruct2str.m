classdef teststruct2str < matlab.unittest.TestCase
    methods (Test)
        function testSimpleStruct(testCase)
            % Test a simple struct
            S = struct('field1', 'value1', 'field2', 10);
            expectedStr = sprintf('value1 : 10');
            actualStr = struct2str(S);
            testCase.verifyEqual(actualStr, expectedStr);
        end

        function testStructWithCell(testCase)
            % Test a struct with a cell, which should now be handled correctly
            S = struct('field1', {{'a', 'b'}});
            expectedStr = '{''a'' ''b''}';
            actualStr = struct2str(S);
            testCase.verifyEqual(actualStr, expectedStr);
        end

        function testStructWithNumericArray(testCase)
            % Test a struct with a numeric array
            S = struct('field1', [1 2 3]);
            expectedStr = '1  2  3';
            actualStr = struct2str(S);
            testCase.verifyEqual(actualStr, expectedStr);
        end
    end
end