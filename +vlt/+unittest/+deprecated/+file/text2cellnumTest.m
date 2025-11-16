classdef text2cellnumTest < matlab.unittest.TestCase
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
            fprintf(fid, '1\n');
            fprintf(fid, '2 3\n');
            fprintf(fid, '4 5 6\n');
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
        function testText2cellnum_simple(testCase)
            c = text2cellnum(testCase.TestFile);
            expected = { [1], [2 3], [4 5 6] };
            testCase.verifyEqual(c, expected);
        end
    end
end
