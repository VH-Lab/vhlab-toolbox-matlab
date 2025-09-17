classdef assignTest < matlab.unittest.TestCase
    methods (Test)
        function testAssignNameValue(testCase)
            [a,b] = helper_test_assign();
            testCase.verifyEqual(a, 5);
            testCase.verifyEqual(b, 10);
        end

        function testAssignStruct(testCase)
             [c,d] = helper_test_assign_struct();
             testCase.verifyEqual(c, 15);
             testCase.verifyEqual(d, 20);
        end

        function testAssignCell(testCase)
             [e,f] = helper_test_assign_cell();
             testCase.verifyEqual(e, 25);
             testCase.verifyEqual(f, 30);
        end
    end
end

function [a,b] = helper_test_assign()
    a = 1;
    b = 2;
    vlt.data.assign('a', 5, 'b', 10);
end

function [c,d] = helper_test_assign_struct()
    c = 3;
    d = 4;
    my_struct = struct('c', 15, 'd', 20);
    vlt.data.assign(my_struct);
end

function [e,f] = helper_test_assign_cell()
    e = 5;
    f = 6;
    my_cell = {'e', 25, 'f', 30};
    vlt.data.assign(my_cell);
end
