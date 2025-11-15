classdef isfileTest < matlab.unittest.TestCase
    properties
        testDir
        testFile
        testSubDir
    end

    methods (TestMethodSetup)
        function createTestEnvironment(testCase)
            testCase.testDir = tempname;
            mkdir(testCase.testDir);

            % Create a test file
            testCase.testFile = fullfile(testCase.testDir, 'testfile.txt');
            fid = fopen(testCase.testFile, 'w');
            fprintf(fid, 'this is a test file');
            fclose(fid);

            % Create a subdirectory
            testCase.testSubDir = fullfile(testCase.testDir, 'subdir');
            mkdir(testCase.testSubDir);
        end
    end

    methods (TestMethodTeardown)
        function cleanupTestEnvironment(testCase)
            if exist(testCase.testDir, 'dir')
                rmdir(testCase.testDir, 's');
            end
        end
    end

    methods (Test)
        function testIsFileFunctionality(testCase)
            % 1. Test with an existing file
            testCase.verifyTrue(logical(vlt.file.isfile(testCase.testFile)), 'Should return true for an existing file.');

            % 2. Test with an existing directory
            testCase.verifyFalse(logical(vlt.file.isfile(testCase.testSubDir)), 'Should return false for a directory.');

            % 3. Test with a non-existent file
            nonExistentFile = fullfile(testCase.testDir, 'nonexistent.txt');
            testCase.verifyFalse(logical(vlt.file.isfile(nonExistentFile)), 'Should return false for a non-existent file.');

            % 4. Test with the directory itself
            testCase.verifyFalse(logical(vlt.file.isfile(testCase.testDir)), 'Should return false for the parent directory path.');
        end
    end
end
