classdef testCelloritem < matlab.unittest.TestCase

    methods (Test)

        function testCellInput(testCase)
            % Test case: Input is a cell array, index is specified
            c = {'a', 'b', 'c'};

            % Test with a valid index
            item = celloritem(c, 2);
            testCase.verifyEqual(item, 'b');

            % Test with the default index
            item = celloritem(c);
            testCase.verifyEqual(item, 'a');
        end

        function testNonCellInput(testCase)
            % Test case: Input is not a cell array

            % useindexforvar is false (default)
            d = [1 2 3];
            item = celloritem(d, 2);
            testCase.verifyEqual(item, d);

            % useindexforvar is true
            item = celloritem(d, 2, 1);
            testCase.verifyEqual(item, 2);
        end

        function testStringInput(testCase)
            % Test case: Input is a string

            % useindexforvar is false (default)
            s = 'hello';
            item = celloritem(s, 2);
            testCase.verifyEqual(item, s);

            % useindexforvar is true
            item = celloritem(s, 2, 1);
            testCase.verifyEqual(item, 'e');
        end
    end
end