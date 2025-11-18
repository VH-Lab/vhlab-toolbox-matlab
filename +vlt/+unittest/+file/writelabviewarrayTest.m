classdef writelabviewarrayTest < matlab.unittest.TestCase
    % Tests for vlt.file.writelabviewarray

    properties
        tempDir
        testFile
    end

    methods (TestMethodSetup)
        function setupTempDir(testCase)
            % Create a temporary directory for test files
            testCase.tempDir = tempname;
            mkdir(testCase.tempDir);
            testCase.testFile = fullfile(testCase.tempDir, 'test_array.dat');
        end
    end

    methods (TestMethodTeardown)
        function cleanupTempDir(testCase)
            % Clean up the temporary directory and file
            if exist(testCase.tempDir, 'dir')
                rmdir(testCase.tempDir, 's');
            end
        end
    end

    methods (Test)
        function testWriteDoubleArrayBigEndian(testCase)
            % Test writing a 2x3 matrix of doubles in big-endian format

            % Data to write
            A = [1.1, 2.2, 3.3; 4.4, 5.5, 6.6];
            [rows, cols] = size(A);

            % Write the file using the function under test
            vlt.file.writelabviewarray(testCase.testFile, A, 'double', 'b');

            % Verify the file was written correctly by reading it back
            fid = fopen(testCase.testFile, 'r', 'b'); % Open in big-endian
            testCase.assertGreaterThan(fid, 0, 'Test file could not be opened for reading.');

            % Read dimensions (LabVIEW stores them as [cols rows])
            dims = fread(fid, 2, '*int32'); % LabVIEW uses 32-bit integers for dimensions
            testCase.verifyEqual(dims, int32([cols; rows]), 'The dimensions were not written correctly.');

            % Read data
            data = fread(fid, [cols, rows], '*double');
            data = data'; % Transpose back to MATLAB's row-major order

            fclose(fid);

            % Verify the data content
            testCase.verifyEqual(data, A, 'AbsTol', 1e-9, 'The matrix data was not written correctly.');
        end

        function testWriteInt16ArrayLittleEndian(testCase)
            % Test writing a 3x2 matrix of int16 in little-endian format

            A = int16([10, 20; 30, 40; 50, 60]);
            [rows, cols] = size(A);

            vlt.file.writelabviewarray(testCase.testFile, A, 'int16', 'l');

            fid = fopen(testCase.testFile, 'r', 'l'); % Open in little-endian
            testCase.assertGreaterThan(fid, 0, 'Test file could not be opened for reading.');

            dims = fread(fid, 2, '*int32');
            testCase.verifyEqual(dims, int32([cols; rows]), 'The dimensions were not written correctly.');

            data = fread(fid, [cols, rows], '*int16');
            data = data';

            fclose(fid);

            testCase.verifyEqual(data, A, 'The int16 matrix data was not written correctly.');
        end

        function testUnwritableFile(testCase)
            % Test that the function errors when the file cannot be written to

            % On most systems, creating a file in the root directory will fail
            % without administrator privileges.
            unwritableFile = '/cannot_write_here.dat';

            testCase.verifyError(@() vlt.file.writelabviewarray(unwritableFile, [1,2,3], 'double'), ...
                '', 'Should throw a specific file IO error for an unwritable file location.');
        end
    end
end
