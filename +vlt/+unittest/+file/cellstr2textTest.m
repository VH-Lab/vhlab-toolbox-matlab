classdef cellstr2textTest < matlab.unittest.TestCase
    properties
        TestDir
    end

    methods (TestMethodSetup)
        function createTestDir(testCase)
            testCase.TestDir = tempname;
            mkdir(testCase.TestDir);
        end
    end

    methods (TestMethodTeardown)
        function removeTestDir(testCase)
            rmdir(testCase.TestDir, 's');
        end
    end

    methods (Test)
        function testCellstr2text(testCase)
            testFile = fullfile(testCase.TestDir, 'test.txt');
            testStrings = {'This is the first line.', 'This is the second line.', 'This is the third line.'};

            vlt.file.cellstr2text(testFile, testStrings);

            content = fileread(testFile);
            expectedContent = [testStrings{1} newline() testStrings{2} newline() testStrings{3} newline()];

            testCase.verifyEqual(content, expectedContent, 'File content is not as expected.');
        end
    end
end
