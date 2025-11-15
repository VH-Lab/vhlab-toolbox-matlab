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

            [folders, counts] = manifestFileCount(fileList, isDir);

            expectedFolders = {'DirA'; fullfile('DirA', 'SubDirA1'); 'DirB'};
            expectedCounts = [2; 1; 0];

            testCase.verifyEqual(folders, expectedFolders);
            testCase.verifyEqual(counts, expectedCounts);
        end

        function test_double_isDir_input(testCase)
            fileList = {'DirA'; fullfile('DirA', 'file.txt')};
            isDir_double = [1; 0]; % Using double instead of logical

            [folders, counts] = manifestFileCount(fileList, isDir_double);

            expectedFolders = {'DirA'};
            expectedCounts = 1;

            testCase.verifyEqual(folders, expectedFolders);
            testCase.verifyEqual(counts, expectedCounts);
        end

        function test_empty_input(testCase)
            [folders, counts] = manifestFileCount({}, []);
            testCase.verifyEmpty(folders);
            testCase.verifyEmpty(counts);
        end

        function test_no_directories_input(testCase)
            fileList = {'file1.txt'; 'file2.txt'};
            isDir = [false; false];
            [folders, counts] = manifestFileCount(fileList, isDir);
            testCase.verifyEmpty(folders);
            testCase.verifyEmpty(counts);
        end

        function test_mismatched_size_error(testCase)
            fileList = {'DirA'; 'file.txt'};
            isDir = [true]; % Mismatched size
            % Deprecated function might throw a different or no error,
            % so we just check that it errors out.
            testCase.verifyError(@() manifestFileCount(fileList, isDir), '');
        end
    end
end
