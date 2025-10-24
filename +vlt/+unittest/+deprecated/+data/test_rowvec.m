classdef test_rowvec < matlab.unittest.TestCase
    % TEST_ROWVEC - tests for the rowvec function

    methods (Test)

        function test_rowvec_basic(testCase)
            % Test case 1: Column vector
            testCase.verifyEqual(rowvec([1; 2; 3]), [1 2 3]);

            % Test case 2: Row vector (should be unchanged)
            testCase.verifyEqual(rowvec([1 2 3]), [1 2 3]);

            % Test case 3: Matrix
            testCase.verifyEqual(rowvec([1 2; 3 4]), [1 3 2 4]);

            % Test case 4: Empty matrix
            testCase.verifyTrue(isempty(rowvec([])));
        end

    end; % methods (Test)

end
