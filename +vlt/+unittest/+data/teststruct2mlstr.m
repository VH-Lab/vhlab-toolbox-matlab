classdef teststruct2mlstr < matlab.unittest.TestCase
    methods (Test)
        function testSimpleStruct(testCase)
            % Test a simple struct
            S = struct('field1', 'value1', 'field2', 10);
            expectedStr = ['<STRUCT size=[1 1]  fields={ ''field1'', ''field2'' } data=' sprintf('\n') ...
                           '     <<''value1''><[10]>>' sprintf('\n') ...
                           '/STRUCT>'];
            actualStr = vlt.data.struct2mlstr(S);
            testCase.verifyEqual(actualStr, expectedStr);
        end

        function testStructWithCell(testCase)
            % Test a struct with a cell
            S = struct('field1', {{'a', 'b'}});
            innerStr = ['<CELL size=[1 2] data=' sprintf('\n') ...
                        '          <''a''>' sprintf('\n') ...
                        '          <''b''>' sprintf('\n') ...
                        '     /CELL>'];
            expectedStr = ['<STRUCT size=[1 1]  fields={ ''field1'' } data=' sprintf('\n') ...
                           '     <<' innerStr '>>' sprintf('\n') ...
                           '/STRUCT>'];
            actualStr = vlt.data.struct2mlstr(S);
            testCase.verifyEqual(actualStr, expectedStr);
        end
    end
end