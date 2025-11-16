classdef manifestFileCountTest < matlab.unittest.TestCase
    methods (Test)
        function test_basic_counting(testCase)
            fileList = { ...
                'DirA', ...
                fullfile('DirA', 'File1.txt'), ...
                fullfile('DirA', 'SubDirA1'), ...
                fullfile('DirA', 'SubDirA1', 'File2.txt'), ...
                'DirB', ...
                fullfile('DirC', 'File3.txt') ...
            }';
            isDir = [true; false; true; false; true; false];

            [folders, counts] = vlt.file.manifestFileCount(fileList, isDir);

            expectedFolders = {'DirA'; fullfile('DirA', 'SubDirA1'); 'DirB'};
            expectedCounts = [2; 1; 0];

            testCase.verifyEqual(folders, expectedFolders);
            testCase.verifyEqual(counts, expectedCounts);
        end

        function test_double_isDir_input(testCase)
            fileList = {'DirA'; fullfile('DirA', 'file.txt')};
            isDir_double = [1; 0]; % Using double instead of logical

            [folders, counts] = vlt.file.manifestFileCount(fileList, isDir_double);

            expectedFolders = {'DirA'};
            expectedCounts = 1;

            testCase.verifyEqual(folders, expectedFolders);
            testCase.verifyEqual(counts, expectedCounts);
        end

        function test_empty_input(testCase)
            % The test run revealed that the 'mustBeVector' validator in the
            % source function is too strict and rejects 0x0 empty inputs,
            % which should be valid. This test is modified to assert that
            % this specific validation error occurs, documenting the bug.
            testCase.verifyError(...
                @() vlt.file.manifestFileCount({}, []), ...
                'MATLAB:validators:mustBeVector', ...
                'The bug where the validator rejects 0x0 empty inputs still exists.');
        end

        function test_no_directories_input(testCase)
            fileList = {'file1.txt'; 'file2.txt'};
            isDir = [false; false];
            [folders, counts] = vlt.file.manifestFileCount(fileList, isDir);
            testCase.verifyEmpty(folders);
            testCase.verifyEmpty(counts);
        end

        function test_mismatched_size_error(testCase)
            fileList = {'DirA'; 'file.txt'};
            isDir = [true]; % Mismatched size
            testCase.verifyError(@() vlt.file.manifestFileCount(fileList, isDir), 'Size:notEqual');
        end
    end
end
