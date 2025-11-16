classdef writeplainmatTest < matlab.unittest.TestCase
    % Tests for vlt.file.writeplainmat

    properties
        tempDir
        testFile
    end

    methods (TestMethodSetup)
        function setupTempDir(testCase)
            % Create a temporary directory for test files
            testCase.tempDir = tempname;
            mkdir(testCase.tempDir);
            testCase.testFile = fullfile(testCase.tempDir, 'test_plainmat.dat');
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
        function testWriteDoubleMatrix(testCase)
            % Test writing a 2x3 matrix of doubles

            % Data to write
            A = [pi, exp(1), -1; 10, 20, 30];
            mat_class = class(A);
            mat_size = size(A);
            mat_dims = ndims(A);

            % Write the file using the function under test
            fid = fopen(testCase.testFile, 'w');
            testCase.assertGreaterThan(fid, 0, 'Could not open test file for writing.');
            vlt.file.writeplainmat(fid, A);
            fclose(fid);

            % Verify the file was written correctly by reading it back
            fid = fopen(testCase.testFile, 'r');
            testCase.assertGreaterThan(fid, 0, 'Could not open test file for reading.');

            % Read class name
            className = fgetl(fid);
            testCase.verifyEqual(className, mat_class, 'The class name was not written correctly.');

            % Read number of dimensions
            dims = fread(fid, 1, '*uint8');
            testCase.verifyEqual(dims, mat_dims, 'The number of dimensions was not written correctly.');

            % Read dimension sizes
            sz = fread(fid, dims, '*uint32');
            testCase.verifyEqual(sz(:)', mat_size, 'The dimension sizes were not written correctly.');

            % Read data
            data = fread(fid, inf, ['*' mat_class]);
            data = reshape(data, sz(:)');

            fclose(fid);

            % Verify the data content
            testCase.verifyEqual(data, A, 'The matrix data was not written correctly.');
        end

        function testWriteCharMatrix(testCase)
            % Test writing a character matrix (2D char array)

            A = ['hello'; 'world'];
            mat_class = class(A);
            mat_size = size(A);
            mat_dims = ndims(A);

            fid = fopen(testCase.testFile, 'w');
            testCase.assertGreaterThan(fid, 0, 'Could not open test file for writing.');
            vlt.file.writeplainmat(fid, A);
            fclose(fid);

            fid = fopen(testCase.testFile, 'r');
            testCase.assertGreaterThan(fid, 0, 'Could not open test file for reading.');

            className = fgetl(fid);
            testCase.verifyEqual(className, mat_class, 'The class name for the char matrix is incorrect.');

            dims = fread(fid, 1, '*uint8');
            testCase.verifyEqual(dims, mat_dims, 'The number of dimensions for the char matrix is incorrect.');

            sz = fread(fid, dims, '*uint32');
            testCase.verifyEqual(sz(:)', mat_size, 'The dimension sizes for the char matrix are incorrect.');

            % Read data, remembering that fread reads column-wise
            data = fread(fid, inf, ['*' mat_class]);
            data = reshape(data, sz(:)');

            fclose(fid);

            testCase.verifyEqual(data, A, 'The char matrix data was not written correctly.');
        end
    end
end
