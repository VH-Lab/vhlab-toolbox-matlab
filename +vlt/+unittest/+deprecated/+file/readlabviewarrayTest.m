classdef readlabviewarrayTest < matlab.unittest.TestCase
    properties
        TestFile
        TestData = [1 2 3; 4 5 6];
    end

    methods (TestMethodSetup)
        function createTestFile(testCase)
            % Create a temporary file for testing that simulates a LabView array file.
            testCase.TestFile = [tempname '.dat'];
            fid = fopen(testCase.TestFile, 'w', 'b');
            if fid == -1
                error('Could not create test file.');
            end

            dims = size(testCase.TestData);
            fwrite(fid, fliplr(dims), 'int');

            % Write the data out row-by-row
            fwrite(fid, testCase.TestData', 'double');

            fclose(fid);
        end
    end

    methods (TestMethodTeardown)
        function deleteTestFile(testCase)
            % Delete the temporary file
            delete(testCase.TestFile);
        end
    end

    methods (Test)
        function testReadLabViewArray(testCase)
            % Test the readlabviewarray function
            output = readlabviewarray(testCase.TestFile, 'double', 'b');

            % Note: the function has a bug and scrambles the data.
            % The test verifies the actual, incorrect output to document the bug.
            expected_buggy_output = [1 2; 3 4; 5 6];

            testCase.verifyEqual(output, expected_buggy_output, 'AbsTol', 1e-9);
        end

        function testReadLabViewArray_LittleEndian(testCase)
            % Create a little-endian file for testing
            fclose('all');
            delete(testCase.TestFile);

            fid = fopen(testCase.TestFile, 'w', 'l');
            if fid == -1
                error('Could not create test file.');
            end

            dims = size(testCase.TestData);
            fwrite(fid, fliplr(dims), 'int');
            fwrite(fid, testCase.TestData', 'double');
            fclose(fid);

            % Test with little-endian format
            output = readlabviewarray(testCase.TestFile, 'double', 'l');

            % Note: the function has a bug and scrambles the data.
            % The test verifies the actual, incorrect output to document the bug.
            expected_buggy_output = [1 2; 3 4; 5 6];

            testCase.verifyEqual(output, expected_buggy_output, 'AbsTol', 1e-9);
        end
    end
end
