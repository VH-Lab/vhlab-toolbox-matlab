classdef readlabviewarrayTest < matlab.unittest.TestCase
    properties
        TestFile
        TestData = [1 2 3; 4 5 6];
    end

    methods (TestMethodSetup)
        function createTestFile(testCase)
            % Create a temporary file for testing
            testCase.TestFile = [tempname '.dat'];
            fid = fopen(testCase.TestFile, 'w', 'b');
            if fid == -1
                error('Could not create test file.');
            end

            % Write dimensions (LabView format)
            dims = fliplr(size(testCase.TestData));
            fwrite(fid, dims, 'int');

            % Write data (column-major)
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
            % Test the vlt.file.readlabviewarray function

            output = vlt.file.readlabviewarray(testCase.TestFile, 'double', 'b');

            testCase.verifyEqual(output, testCase.TestData, 'AbsTol', 1e-9);
        end

        function testReadLabViewArray_LittleEndian(testCase)
            % Create a little-endian file for testing
            fclose('all');
            delete(testCase.TestFile);

            fid = fopen(testCase.TestFile, 'w', 'l');
            if fid == -1
                error('Could not create test file.');
            end

            dims = fliplr(size(testCase.TestData));
            fwrite(fid, dims, 'int');
            fwrite(fid, testCase.TestData', 'double');
            fclose(fid);

            % Test with little-endian format
            output = vlt.file.readlabviewarray(testCase.TestFile, 'double', 'l');
            testCase.verifyEqual(output, testCase.TestData, 'AbsTol', 1e-9);
        end
    end
end
