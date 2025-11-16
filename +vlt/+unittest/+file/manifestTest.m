classdef manifestTest < matlab.unittest.TestCase
    properties
        testDir
        targetDir
    end

    methods (TestMethodSetup)
        function createTestStructure(testCase)
            % Create a temporary directory structure for testing
            testCase.testDir = tempname;
            mkdir(testCase.testDir);
            testCase.targetDir = fullfile(testCase.testDir, 'target_folder');
            mkdir(testCase.targetDir);

            % Create a nested structure
            mkdir(fullfile(testCase.targetDir, 'a_subdir'));
            fclose(fopen(fullfile(testCase.targetDir, 'a_subdir', 'file_c.txt'), 'w'));
            fclose(fopen(fullfile(testCase.targetDir, 'file_b.txt'), 'w'));
            mkdir(fullfile(testCase.targetDir, 'z_emptydir'));
        end
    end

    methods (TestMethodTeardown)
        function removeTestStructure(testCase)
            if exist(testCase.testDir, 'dir')
                rmdir(testCase.testDir, 's');
            end
        end
    end

    methods (Test)
        function test_manifest_relative_paths(testCase)
            [fileList, isDir] = vlt.file.manifest(testCase.targetDir);

            expectedFileList = { ...
                fullfile('target_folder', 'a_subdir'), ...
                fullfile('target_folder', 'a_subdir', 'file_c.txt'), ...
                fullfile('target_folder', 'file_b.txt'), ...
                fullfile('target_folder', 'z_emptydir') ...
            }';
            expectedIsDir = [true; false; false; true];

            testCase.verifyEqual(fileList, expectedFileList);
            testCase.verifyEqual(isDir, expectedIsDir);
        end

        function test_manifest_full_paths(testCase)
            [fileList, isDir] = vlt.file.manifest(testCase.targetDir, 'ReturnFullPath', true);

            expectedFileList = { ...
                fullfile(testCase.targetDir, 'a_subdir'), ...
                fullfile(testCase.targetDir, 'a_subdir', 'file_c.txt'), ...
                fullfile(testCase.targetDir, 'file_b.txt'), ...
                fullfile(testCase.targetDir, 'z_emptydir') ...
            }';
            expectedIsDir = [true; false; false; true];

            testCase.verifyEqual(fileList, expectedFileList);
            testCase.verifyEqual(isDir, expectedIsDir);
        end

        function test_manifest_empty_folder(testCase)
            emptyDir = fullfile(testCase.testDir, 'empty');
            mkdir(emptyDir);
            [fileList, isDir] = vlt.file.manifest(emptyDir);

            testCase.verifyEmpty(fileList);
            testCase.verifyEmpty(isDir);
        end

        function test_manifest_nonexistent_folder(testCase)
            nonexistentDir = fullfile(testCase.testDir, 'nonexistent');
            testCase.verifyError(@() vlt.file.manifest(nonexistentDir), 'MATLAB:validators:mustBeFolder');
        end
    end
end
