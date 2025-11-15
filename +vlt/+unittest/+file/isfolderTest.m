classdef isfolderTest < matlab.unittest.TestCase
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
        function testIsFolderFunctionality(testCase)
            % 1. Test with an existing directory
            testCase.verifyTrue(logical(vlt.file.isfolder(testCase.testSubDir)), 'Should return true for a directory.');

            % 2. Test with an existing file
            testCase.verifyFalse(logical(vlt.file.isfolder(testCase.testFile)), 'Should return false for a file.');

            % 3. Test with a non-existent directory
            nonExistentDir = fullfile(testCase.testDir, 'nonexistent');
            testCase.verifyFalse(logical(vlt.file.isfolder(nonExistentDir)), 'Should return false for a non-existent directory.');

            % 4. Test with the parent directory itself
            testCase.verifyTrue(logical(vlt.file.isfolder(testCase.testDir)), 'Should return true for the parent directory path.');
        end
    end
end
