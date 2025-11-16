classdef writelabviewarrayTest < matlab.unittest.TestCase
    % Tests for the deprecated writelabviewarray function

    properties
        tempDir
        testFile
    end

    methods (TestMethodSetup)
        function setupTempDir(testCase)
            % Create a temporary directory for test files
            testCase.tempDir = tempname;
            mkdir(testCase.tempDir);
            testCase.testFile = fullfile(testCase.tempDir, 'test_array_deprecated.dat');
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

            A = [1.1, 2.2, 3.3; 4.4, 5.5, 6.6];
            [rows, cols] = size(A);

            % Important: Call the deprecated function, not vlt.file.writelabviewarray
            writelabviewarray(testCase.testFile, A, 'double', 'b');

            % Verify the file was written correctly
            fid = fopen(testCase.testFile, 'r', 'b');
            testCase.assertGreaterThan(fid, 0, 'Test file could not be opened.');

            dims = fread(fid, 2, '*int32');
            testCase.verifyEqual(dims, [cols; rows], 'Dimensions were not written correctly.');

            data = fread(fid, [cols, rows], '*double');
            data = data';

            fclose(fid);

            testCase.verifyEqual(data, A, 'AbsTol', 1e-9, 'Matrix data was not written correctly.');
        end

        function testWriteInt16ArrayLittleEndian(testCase)
            % Test writing a 3x2 matrix of int16 in little-endian format

            A = int16([10, 20; 30, 40; 50, 60]);
            [rows, cols] = size(A);

            writelabviewarray(testCase.testFile, A, 'int16', 'l');

            fid = fopen(testCase.testFile, 'r', 'l');
            testCase.assertGreaterThan(fid, 0, 'Test file could not be opened.');

            dims = fread(fid, 2, '*int32');
            testCase.verifyEqual(dims, [cols; rows], 'Dimensions were not written correctly.');

            data = fread(fid, [cols, rows], '*int16');
            data = data';

            fclose(fid);

            testCase.verifyEqual(data, A, 'The int16 matrix data was not written correctly.');
        end

        function testUnwritableFile(testCase)
            % Test that the function errors when the file cannot be written to
            unwritableFile = '/cannot_write_here.dat';

            testCase.verifyError(@() writelabviewarray(unwritableFile, [1,2,3], 'double'), ...
                'MATLAB:FileIO:OpenFile', 'Should throw a specific file IO error for an unwritable file location.');
        end
    end
end
