classdef test_uniq < matlab.unittest.TestCase
    methods(Test)
        function test_simple_uniq(testCase)
            % Test with a simple case of repeated elements
            x = [1 1 2 2 3 3];
            y = uniq(x);
            testCase.verifyEqual(y, [1 2 3]);
        end

        function test_no_repeated_elements(testCase)
            % Test with no repeated elements
            x = [1 2 3 4 5];
            y = uniq(x);
            testCase.verifyEqual(y, [1 2 3 4 5]);
        end

        function test_all_repeated_elements(testCase)
            % Test with all elements being the same
            x = [5 5 5 5 5];
            y = uniq(x);
            testCase.verifyEqual(y, 5);
        end

        function test_mixed_elements(testCase)
            % Test with a mix of repeated and non-repeated elements
            x = [1 2 2 3 4 4 4 5];
            y = uniq(x);
            testCase.verifyEqual(y, [1 2 3 4 5]);
        end
    end
end
