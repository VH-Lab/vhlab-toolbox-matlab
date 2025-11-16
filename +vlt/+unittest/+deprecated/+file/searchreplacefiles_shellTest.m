classdef searchreplacefiles_shellTest < matlab.unittest.TestCase
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
        function testSearchReplaceFiles_Shell(testCase)
            testFile = fullfile(testCase.TestDir, 'test.txt');
            originalContent = 'This is the original content.';
            str2text(testFile, originalContent);

            searchString = 'original';
            replaceString = 'new';

            searchreplacefiles_shell({testFile}, searchString, replaceString);

            newContent = fileread(testFile);
            expectedContent = 'This is the new content.';
            testCase.verifyEqual(strtrim(newContent), expectedContent);
        end
    end
end
