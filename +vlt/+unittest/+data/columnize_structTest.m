classdef columnize_structTest < matlab.unittest.TestCase
    methods (Test)
        function testSimpleStruct(testCase)
            my_struct.a = [1 2 3];
            my_struct.b = 'test';
            columnized_struct = vlt.data.columnize_struct(my_struct);
            testCase.verifyFalse(iscolumn(columnized_struct.a));
            testCase.verifyEqual(columnized_struct.a, [1 2 3]);
            testCase.verifyEqual(columnized_struct.b, 'test');
        end

        function testNestedStruct(testCase)
            my_struct.a = [1 2 3];
            my_struct.b.c = [4 5 6];
            my_struct.b.d = [7 8 9];
            columnized_struct = vlt.data.columnize_struct(my_struct);
            testCase.verifyFalse(iscolumn(columnized_struct.a));
            testCase.verifyFalse(iscolumn(columnized_struct.b.c));
            testCase.verifyFalse(iscolumn(columnized_struct.b.d));
        end
    end
end
