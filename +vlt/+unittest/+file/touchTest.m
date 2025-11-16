classdef touchTest < matlab.unittest.TestCase
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
            if isfolder(testCase.TestDir)
                rmdir(testCase.TestDir, 's');
            end
        end
    end

    methods (Test)
        function testTouch_createFile(testCase)
            testFile = fullfile(testCase.TestDir, 'test.txt');
            testCase.verifyFalse(logical(exist(testFile, 'file')));
            vlt.file.touch(testFile);
            testCase.verifyTrue(logical(exist(testFile, 'file')));
        end

        function testTouch_existingFile(testCase)
            testFile = fullfile(testCase.TestDir, 'test.txt');
            vlt.file.touch(testFile); % create it
            testCase.verifyTrue(logical(exist(testFile, 'file')));
            vlt.file.touch(testFile); % touch it again, should do nothing
            testCase.verifyTrue(logical(exist(testFile, 'file')));
        end

        function testTouch_createSubdirectory(testCase)
            testSubDir = fullfile(testCase.TestDir, 'subdir');
            testFile = fullfile(testSubDir, 'test.txt');
            testCase.verifyFalse(logical(exist(testSubDir, 'dir')));
            vlt.file.touch(testFile);
            testCase.verifyTrue(logical(exist(testSubDir, 'dir')));
            testCase.verifyTrue(logical(exist(testFile, 'file')));
        end
    end
end
