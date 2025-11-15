classdef findfiletypeTest < matlab.unittest.TestCase

    properties
        testDir
    end

    methods(TestMethodSetup)
        function createTestDir(testCase)
            testCase.testDir = tempname;
            mkdir(testCase.testDir);

            % Create test files
            fclose(fopen(fullfile(testCase.testDir, 'file1.txt'), 'w'));
            fclose(fopen(fullfile(testCase.testDir, 'file2.TXT'), 'w'));

            subDir = fullfile(testCase.testDir, 'sub');
            mkdir(subDir);
            fclose(fopen(fullfile(subDir, 'file3.txt'), 'w'));
            fclose(fopen(fullfile(subDir, 'anotherfile.dat'), 'w'));

            mkdir(fullfile(testCase.testDir, 'emptySubDir'));
        end
    end

    methods(TestMethodTeardown)
        function removeTestDir(testCase)
            if exist(testCase.testDir,'dir')
                rmdir(testCase.testDir,'s');
            end
        end
    end

    methods(Test)

        function test_find_files_recursive(testCase)
            expected_files = { ...
                fullfile(testCase.testDir, 'file1.txt'), ...
                fullfile(testCase.testDir, 'file2.TXT'), ...
                fullfile(testCase.testDir, 'sub', 'file3.txt') ...
            };

            filenames = vlt.file.findfiletype(testCase.testDir, 'txt');

            % sort both lists to ensure order doesn't matter
            testCase.verifyEqual(sort(filenames), sort(expected_files));
        end

        function test_no_matching_files(testCase)
            filenames = vlt.file.findfiletype(testCase.testDir, 'nonexistent');
            testCase.verifyEmpty(filenames);
        end

        function test_empty_directory(testCase)
             filenames = vlt.file.findfiletype(fullfile(testCase.testDir, 'emptySubDir'), 'txt');
             testCase.verifyEmpty(filenames);
        end

        function test_case_insensitivity(testCase)
            expected_files = { ...
                fullfile(testCase.testDir, 'file1.txt'), ...
                fullfile(testCase.testDir, 'file2.TXT'), ...
                fullfile(testCase.testDir, 'sub', 'file3.txt') ...
            };

            filenames = vlt.file.findfiletype(testCase.testDir, 'TXT');
            testCase.verifyEqual(sort(filenames), sort(expected_files));
        end

    end
end
