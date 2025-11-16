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
        function testSearchReplaceFiles_Shell_documentsBug(testCase)
            % This test documents a bug in the source function.
            % The function attempts to call the 'system' command with a cell array,
            % which is not allowed. This test verifies that the expected error is thrown.
            testFile = fullfile(testCase.TestDir, 'test.txt');
            vlt.file.str2text(testFile, 'some content');

            searchString = 'original';
            replaceString = 'new';

            errID = 'MATLAB:oss:system:InvalidCommandArg';
            testCase.verifyError(@() vlt.file.searchreplacefiles_shell({testFile}, searchString, replaceString), errID);
        end
    end
end
