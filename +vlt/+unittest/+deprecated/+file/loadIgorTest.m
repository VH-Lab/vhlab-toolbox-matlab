classdef loadIgorTest < matlab.unittest.TestCase

    methods (Test)

        function test_loadIgor_no_file(testCase)
            % This test verifies that loadIgor throws an error when the file does not exist.
            non_existent_file = 'non_existent_igor_file.bin';
            testCase.verifyError(@() loadIgor(non_existent_file), '', 'Expected an error for a non-existent file.');
        end

        function test_loadIgor_wrong_nargin(testCase)
            % This test verifies that loadIgor throws an error for the wrong number of input arguments.
            testCase.verifyError(@() loadIgor('dummy_file.bin', 1), '', 'Expected an error for 2 input arguments.');
        end

        % Note to user: A full test of loadIgor requires a sample Igor binary file.
        % The current tests only verify basic error handling.

    end

end
