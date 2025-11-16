classdef text2cellstrTest < matlab.unittest.TestCase
    properties
        TestDir
        TestFile
    end

    methods (TestMethodSetup)
        function createTestDir(testCase)
            testCase.TestDir = tempname;
            mkdir(testCase.TestDir);
            testCase.TestFile = fullfile(testCase.TestDir, 'test.txt');
            fid = fopen(testCase.TestFile, 'w');
            fprintf(fid, 'line 1\n');
            fprintf(fid, 'line 2\n');
            fprintf(fid, 'line 3\n');
            fclose(fid);
        end
    end

    methods (TestMethodTeardown)
        function removeTestDir(testCase)
            if isfolder(testCase.TestDir)
                rmdir(testCase.TestDir, 's');
            end
        end
    end

    methods (Test)
        function testText2cellstr_simple(testCase)
            c = vlt.file.text2cellstr(testCase.TestFile);
            expected = { 'line 1', 'line 2', 'line 3' };
            testCase.verifyEqual(c, expected);
        end
    end
end
