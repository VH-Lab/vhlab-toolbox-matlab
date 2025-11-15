classdef getAllFilesTest < matlab.unittest.TestCase
    properties
        testDir
    end

    methods (TestMethodSetup)
        function createTestEnvironment(testCase)
            testCase.testDir = tempname;
            mkdir(testCase.testDir);
            mkdir(fullfile(testCase.testDir, 'subdir1'));

            % Create test files
            fid = fopen(fullfile(testCase.testDir, 'file1.txt'), 'w');
            fprintf(fid, 'test file 1');
            fclose(fid);

            fid = fopen(fullfile(testCase.testDir, 'file2.m'), 'w');
            fprintf(fid, 'test file 2');
            fclose(fid);

            fid = fopen(fullfile(testCase.testDir, 'subdir1', 'file3.log'), 'w');
            fprintf(fid, 'test file 3');
            fclose(fid);
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
        function testFunctionality(testCase)
            % Test basic file collection
            fileList = vlt.file.getAllFiles(testCase.testDir);

            expectedFiles = { ...
                fullfile(testCase.testDir, 'file1.txt'), ...
                fullfile(testCase.testDir, 'file2.m'), ...
                fullfile(testCase.testDir, 'subdir1', 'file3.log') ...
            };

            % Sort both lists to ensure comparison is order-independent
            testCase.verifyEqual(sort(string(fileList)), sort(string(expectedFiles')));
        end
    end
end
