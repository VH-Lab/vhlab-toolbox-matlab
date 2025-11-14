classdef addlineTest < matlab.unittest.TestCase
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
        function testAddline(testCase)
            % Test adding a line to a new file
            testFile = fullfile(testCase.TestDir, 'test.txt');
            message1 = 'This is the first line.';
            [b, errormsg] = vlt.file.addline(testFile, message1);
            testCase.verifyTrue(logical(b), 'Failed to add line to new file.');
            testCase.verifyEmpty(errormsg, 'Error message was not empty.');

            content = fileread(testFile);
            expectedContent = [message1 newline()];
            testCase.verifyEqual(content, expectedContent, 'File content is not as expected after adding first line.');

            % Test adding a line to an existing file
            message2 = 'This is the second line.';
            [b, errormsg] = vlt.file.addline(testFile, message2);
            testCase.verifyTrue(logical(b), 'Failed to add line to existing file.');
            testCase.verifyEmpty(errormsg, 'Error message was not empty.');

            content = fileread(testFile);
            expectedContent = [message1 newline() message2 newline()];
            testCase.verifyEqual(content, expectedContent, 'File content is not as expected after adding second line.');
        end
    end
end
