classdef textfile2charTest < matlab.unittest.TestCase
    properties
        TestDir
        TestFile
        TestContent
    end

    methods (TestMethodSetup)
        function createTestDir(testCase)
            testCase.TestDir = tempname;
            mkdir(testCase.TestDir);
            testCase.TestFile = fullfile(testCase.TestDir, 'test.txt');
            testCase.TestContent = sprintf('line 1\nline 2\nline 3');
            fid = fopen(testCase.TestFile, 'w');
            fprintf(fid, '%s', testCase.TestContent);
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
        function testTextfile2char_simple(testCase)
            c = textfile2char(testCase.TestFile);
            testCase.verifyEqual(c, testCase.TestContent);
        end
    end
end
