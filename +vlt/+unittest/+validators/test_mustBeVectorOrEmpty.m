classdef test_mustBeVectorOrEmpty < matlab.unittest.TestCase
    % TEST_MUSTBEVECTOROREMPTY - test the custom validator vlt.validators.mustBeVectorOrEmpty

    methods (Test)
        function test_vector_inputs(testCase)
            % Test that vectors are accepted
            vlt.validators.mustBeVectorOrEmpty([1 2 3]); % row vector
            vlt.validators.mustBeVectorOrEmpty([1; 2; 3]); % column vector
            testCase.verifyTrue(true); % if we got here without error, the test passes
        end

        function test_empty_input(testCase)
            % Test that an empty array is accepted
            vlt.validators.mustBeVectorOrEmpty([]);
            testCase.verifyTrue(true); % if we got here without error, the test passes
        end

        function test_matrix_input_error(testCase)
            % Test that a matrix input throws the correct error
            a = [1 2; 3 4];
            testCase.verifyError(@() vlt.validators.mustBeVectorOrEmpty(a), 'vlt:validators:mustBeVectorOrEmpty', 'A matrix input did not throw the expected error.');
        end

        function test_cell_input_error(testCase)
            % Test that a cell array input throws an error
            a = {1 2; 3 4};
            testCase.verifyError(@() vlt.validators.mustBeVectorOrEmpty(a), 'vlt:validators:mustBeVectorOrEmpty', 'A cell array input did not throw the expected error.');
        end
    end
end
