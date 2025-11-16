classdef str2textTest < matlab.unittest.TestCase
    properties
        TestDir
    end

    methods (TestMethodSetup)
        function createFixture(testCase)
            testCase.TestDir = tempname;
            mkdir(testCase.TestDir);
        end
    end

    methods (TestMethodTeardown)
        function deleteFixture(testCase)
            rmdir(testCase.TestDir, 's');
        end
    end

    methods (Test)
        function testStr2Text(testCase)
            testFile = fullfile(testCase.TestDir, 'test.txt');
            testString = 'Hello, world!';

            vlt.file.str2text(testFile, testString);

            readString = fileread(testFile);
            % fileread can add a newline, so we trim whitespace
            testCase.verifyEqual(strtrim(readString), testString);
        end
    end
end
