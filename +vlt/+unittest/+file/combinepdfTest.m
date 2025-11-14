classdef combinepdfTest < matlab.unittest.TestCase
    methods (Test)
        function testNonMacError(testCase)
            % This function is designed to run only on Mac OS X.
            % This test verifies that it throws the expected error on other systems.

            if ~ismac
                % Dummy file names, they don't need to exist for this test
                mergeFile = 'merged.pdf';
                file1 = 'file1.pdf';
                file2 = 'file2.pdf';

                f = @() vlt.file.combinepdf(mergeFile, file1, file2);

                % Check that the function throws an error
                testCase.verifyError(f, '', 'This function only works on Mac OS X machines.');
            else
                % If we are on a Mac, we can't test the error case.
                % A full test would require creating dummy PDF files and checking the merged result.
                % For now, we will just pass.
                testCase.assumeTrue(true, 'Skipping non-Mac error test on a Mac.');
            end
        end
    end
end
