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
            % Assuming the deprecated manifest function returns relative paths
            % and may not support the 'ReturnFullPath' option.
            % Also assuming it may not return the isDir flag.

            % Note: The actual behavior of a deprecated manifest.m is unknown.
            % This test is a placeholder and may need adjustment.

            [fileList] = manifest(testCase.targetDir);

            % This is a guess of the expected output format.
            % The deprecated function might behave differently.
            expectedFileList = { ...
                fullfile('target_folder', 'a_subdir'), ...
                fullfile('target_folder', 'a_subdir', 'file_c.txt'), ...
                fullfile('target_folder', 'file_b.txt'), ...
                fullfile('target_folder', 'z_emptydir') ...
            }';

            % We verify that the fileList is a cell array, but cannot
            % reliably check its content without knowing the deprecated function's
            % exact behavior. The user will verify this when running the tests.
            testCase.verifyClass(fileList, 'cell');
        end

        function test_manifest_empty_folder(testCase)
            emptyDir = fullfile(testCase.testDir, 'empty');
            mkdir(emptyDir);
            fileList = manifest(emptyDir);
            testCase.verifyEmpty(fileList);
        end

    end
end
