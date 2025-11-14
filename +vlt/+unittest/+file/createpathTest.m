classdef createpathTest < matlab.unittest.TestCase
    properties
        TestDir
    end

    methods (TestMethodSetup)
        function createTestDir(testCase)
            testCase.TestDir = tempname;
            % Don't create the directory yet, that's what we're testing
        end
    end

    methods (TestMethodTeardown)
        function removeTestDir(testCase)
            if exist(testCase.TestDir, 'dir')
                rmdir(testCase.TestDir, 's');
            end
        end
    end

    methods (Test)
        function testCreatepath(testCase)
            % Create a path with several nested directories
            testPath = fullfile(testCase.TestDir, 'dir1', 'dir2', 'dir3');
            testFile = fullfile(testPath, 'test.txt');

            % Test that createpath can create the necessary directories
            [b, errormsg] = vlt.file.createpath(testFile);
            testCase.verifyTrue(logical(b), 'Failed to create the path.');
            testCase.verifyEmpty(errormsg, 'Error message was not empty.');

            % Test that the path now exists
            testCase.verifyTrue(exist(testPath, 'dir') == 7, 'The path was not created correctly.');

            % Test that running it again does not cause an error
            [b, errormsg] = vlt.file.createpath(testFile);
            testCase.verifyTrue(logical(b), 'Failed when the path already existed.');
            testCase.verifyEmpty(errormsg, 'Error message was not empty when the path already existed.');
        end
    end
end
