classdef filediffTest < matlab.unittest.TestCase

    properties
        testDir
        file1
        file2
    end

    methods(TestMethodSetup)
        function createTestFiles(testCase)
            testCase.testDir = tempname;
            mkdir(testCase.testDir);
            testCase.file1 = fullfile(testCase.testDir, 'file1.txt');
            testCase.file2 = fullfile(testCase.testDir, 'file2.txt');
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

        function test_identical_files(testCase)
            content = sprintf('line 1\nline 2\n');

            fid = fopen(testCase.file1, 'w');
            fprintf(fid, content);
            fclose(fid);

            fid = fopen(testCase.file2, 'w');
            fprintf(fid, content);
            fclose(fid);

            [b, d] = vlt.file.filediff(testCase.file1, testCase.file2);

            % Note: doc says b is 1 if files differ, but code returns true if they are the same.
            % Testing for code's behavior.
            testCase.verifyTrue(b);
            testCase.verifyEmpty(d);
        end

        function test_different_files(testCase)
            content1 = sprintf('line 1\nline 2\n');
            content2 = sprintf('line 1\nline 3\n');

            fid = fopen(testCase.file1, 'w');
            fprintf(fid, content1);
            fclose(fid);

            fid = fopen(testCase.file2, 'w');
            fprintf(fid, content2);
            fclose(fid);

            [b, d] = vlt.file.filediff(testCase.file1, testCase.file2);

            % Note: doc says b is 1 if files differ, but code returns false if they differ.
            % Testing for code's behavior.
            testCase.verifyFalse(b);
            testCase.verifyNotEmpty(d);
        end

        function test_one_file_empty(testCase)
            content1 = sprintf('line 1\nline 2\n');
            content2 = '';

            fid = fopen(testCase.file1, 'w');
            fprintf(fid, content1);
            fclose(fid);

            fid = fopen(testCase.file2, 'w');
            fprintf(fid, content2);
            fclose(fid);

            [b, d] = vlt.file.filediff(testCase.file1, testCase.file2);

            testCase.verifyFalse(b);
            testCase.verifyNotEmpty(d);
        end

    end
end
