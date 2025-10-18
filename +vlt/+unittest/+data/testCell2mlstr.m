classdef testCell2mlstr < matlab.unittest.TestCase
    methods (Test)
        function testSimpleCell(testCase)
            % Test a simple cell array with mixed data types
            A = {'test', 5, [3 4 5]};
            expectedStr = ['<CELL size=[1 3] data=' sprintf('\n') ...
                           '     <''test''>' sprintf('\n') ...
                           '     <[5]>' sprintf('\n') ...
                           '     <[3 4 5]>' sprintf('\n') ...
                           '/CELL>'];
            actualStr = vlt.data.cell2mlstr(A);
            testCase.verifyEqual(actualStr, expectedStr);
        end

        function testNestedCell(testCase)
            % Test a nested cell array
            B = {'nested', {'a', 1}};
            % Note: the indentation and nested structure needs to be precise
            innerStr = ['<CELL size=[1 2] indent=5 data=' sprintf('\n') ...
                        '          <''a''>' sprintf('\n') ...
                        '          <[1]>' sprintf('\n') ...
                        '     /CELL>'];
            expectedStr = ['<CELL size=[1 2] data=' sprintf('\n') ...
                           '     <''nested''>' sprintf('\n') ...
                           '     <' innerStr '>' sprintf('\n') ...
                           '/CELL>'];
            actualStr = vlt.data.cell2mlstr(B);
            testCase.verifyEqual(actualStr, expectedStr);
        end

        function testCellWithStruct(testCase)
            % Test a cell array containing a structure
            S = struct('field1', 'value1', 'field2', 10);
            C = {S, 'another_element'};

            % Generate the expected struct string separately
            structStr = vlt.data.struct2mlstr(S, 'indent', 5);

            expectedStr = ['<CELL size=[1 2] data=' sprintf('\n') ...
                           '     <' structStr '>' sprintf('\n') ...
                           '     <''another_element''>' sprintf('\n') ...
                           '/CELL>'];

            actualStr = vlt.data.cell2mlstr(C);
            testCase.verifyEqual(actualStr, expectedStr);
        end
    end
end