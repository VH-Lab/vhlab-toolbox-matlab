classdef test_findclosest < matlab.unittest.TestCase
    % TEST_FINDCLOSEST - test the vlt.data.findclosest function

    methods(Test)
        function test_simple(testCase)
            arr = [1 2 3 4 5];
            v = 3.1;
            [i, nv] = vlt.data.findclosest(arr, v);
            testCase.verifyEqual(i, 3);
            testCase.verifyEqual(nv, 3);
        end

        function test_empty_array(testCase)
            arr = [];
            v = 10;
            [i, nv] = vlt.data.findclosest(arr, v);
            testCase.verifyEmpty(i);
            testCase.verifyEmpty(nv);
        end

        function test_exact_match(testCase)
            arr = [1 5 10 15];
            v = 10;
            [i, nv] = vlt.data.findclosest(arr, v);
            testCase.verifyEqual(i, 3);
            testCase.verifyEqual(nv, 10);
        end

        function test_negative_numbers(testCase)
            arr = [-10 -5 0 5 10];
            v = -6;
            [i, nv] = vlt.data.findclosest(arr, v);
            testCase.verifyEqual(i, 2);
            testCase.verifyEqual(nv, -5);
        end

        function test_multiple_matches(testCase)
            % Should return the first match
            arr = [1 2 3 2 1];
            v = 1.6;
            [i, nv] = vlt.data.findclosest(arr, v);
            testCase.verifyEqual(i, 2);
            testCase.verifyEqual(nv, 2);
        end

        function test_equidistant(testCase)
            % Should return the first match
            arr = [1 2 4 5];
            v = 3;
            [i, nv] = vlt.data.findclosest(arr, v);
            testCase.verifyEqual(i, 2); % Should be index of 2, as it is equidistant with 4 but appears first
            testCase.verifyEqual(nv, 2);
        end
    end
end
