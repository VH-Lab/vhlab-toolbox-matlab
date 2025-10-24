classdef testisempty_cell < matlab.unittest.TestCase
    % testisempty_cell - tests for vlt.data.isempty_cell
    %
    %

    properties
    end

    methods (Test)

        function test_isempty_cell_mixed(testCase)
            A = {'test', [] ; [] 'more text'};
            B = vlt.data.isempty_cell(A);
            testCase.verifyEqual(logical(B),logical([0 1; 1 0]));
        end

        function test_isempty_cell_all_empty(testCase)
            A = {[], [], []; [], [], []};
            B = vlt.data.isempty_cell(A);
            testCase.verifyEqual(logical(B), logical(ones(2,3)));
        end

        function test_isempty_cell_various_types(testCase)
            A = { 1, 'text', [1 2 3], struct('a',1), [], {}};
            B = vlt.data.isempty_cell(A);
            testCase.verifyEqual(logical(B), logical([0 0 0 0 1 1]));
        end

    end
end
