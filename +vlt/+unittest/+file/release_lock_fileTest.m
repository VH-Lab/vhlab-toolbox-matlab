classdef release_lock_fileTest < matlab.unittest.TestCase
    properties
        TestFile
        TestKey
    end

    methods (TestMethodSetup)
        function createTestLockFile(testCase)
            testCase.TestFile = [tempname '.lock'];
            [~, testCase.TestKey] = vlt.file.checkout_lock_file(testCase.TestFile);
        end
    end

    methods (TestMethodTeardown)
        function deleteTestLockFile(testCase)
            if exist(testCase.TestFile, 'file')
                delete(testCase.TestFile);
            end
        end
    end

    methods (Test)
        function testReleaseWithCorrectKey(testCase)
            released = vlt.file.release_lock_file(testCase.TestFile, testCase.TestKey);
            testCase.verifyTrue(logical(released));
            testCase.verifyFalse(logical(exist(testCase.TestFile, 'file')));
        end

        function testReleaseWithIncorrectKey(testCase)
            released = vlt.file.release_lock_file(testCase.TestFile, 'incorrect_key');
            testCase.verifyFalse(logical(released));
            testCase.verifyTrue(logical(exist(testCase.TestFile, 'file')));
        end

        function testReleaseNonExistentFile(testCase)
            delete(testCase.TestFile);
            released = vlt.file.release_lock_file(testCase.TestFile, testCase.TestKey);
            testCase.verifyTrue(logical(released));
        end

        function testReleaseWithFid(testCase)
            fid = fopen(testCase.TestFile, 'r');
            % The vlt.file.release_lock_file function closes the fid, so we don't need to
            % add a teardown for it.
            released = vlt.file.release_lock_file(fid, testCase.TestKey);
            testCase.verifyTrue(logical(released));
            testCase.verifyFalse(logical(exist(testCase.TestFile, 'file')));
        end
    end
end
