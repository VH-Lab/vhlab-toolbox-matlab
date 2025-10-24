classdef test_sortorder < matlab.unittest.TestCase
    methods (Test)
        function test_sortorder_ascending(testCase)
            A = [3 1 2];
            expected_order = [2 3 1];
            testCase.verifyEqual(sortorder(A), expected_order);
        end

        function test_sortorder_descending(testCase)
            A = [3 1 2];
            expected_order = [1 3 2];
            testCase.verifyEqual(sortorder(A, 'descend'), expected_order);
        end

        function test_sortorder_cell_strings(testCase)
            A = {'c', 'a', 'b'};
            expected_order = [2 3 1];
            testCase.verifyEqual(sortorder(A), expected_order);
        end

        function test_sortorder_already_sorted(testCase)
            A = [1 2 3];
            expected_order = [1 2 3];
            testCase.verifyEqual(sortorder(A), expected_order);
        end

        function test_sortorder_with_duplicates(testCase)
            A = [3 1 2 1];
            [~, expected_order] = sort(A);
            testCase.verifyEqual(sortorder(A), expected_order);
        end
    end
end
