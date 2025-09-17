classdef celloritemTest < matlab.unittest.TestCase
    methods (Test)
        function testCellNoIndex(testCase)
            mycell = {'a', 'b', 'c'};
            item = vlt.data.celloritem(mycell);
            testCase.verifyEqual(item, 'a');
        end

        function testCellWithIndex(testCase)
            mycell = {'a', 'b', 'c'};
            item = vlt.data.celloritem(mycell, 2);
            testCase.verifyEqual(item, 'b');
        end

        function testVarNoIndex(testCase)
            myvar = 'default';
            item = vlt.data.celloritem(myvar);
            testCase.verifyEqual(item, 'default');
        end

        function testVarWithIndex(testCase)
            myvar = 'default';
            item = vlt.data.celloritem(myvar, 2);
            testCase.verifyEqual(item, 'default');
        end

        function testVarWithIndexUseIndex(testCase)
            myarray = [10 20 30];
            item = vlt.data.celloritem(myarray, 2, 1);
            testCase.verifyEqual(item, 20);
        end
    end
end
