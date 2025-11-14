classdef checkout_lock_fileTest < matlab.unittest.TestCase
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
        function testCheckoutLockFile(testCase)
            lockFile = fullfile(testCase.TestDir, 'test.lock');

            % Test checking out a new lock file
            [fid, key] = vlt.file.checkout_lock_file(lockFile);
            testCase.verifyGreaterThan(fid, 0, 'Failed to create a new lock file.');
            testCase.verifyNotEmpty(key, 'Key was not returned for a new lock file.');

            % The file should be closed if a key is requested
            testCase.verifyEqual(fopen(fid), -1, 'File was not closed after checkout.');

            % Test that the lock file now exists
            testCase.verifyTrue(vlt.file.isfile(lockFile), 'Lock file was not created.');

            % Test that checking out the same file again fails
            [fid2, ~] = vlt.file.checkout_lock_file(lockFile, 1); % a short timeout
            testCase.verifyEqual(fid2, -1, 'Should not have been able to check out an existing lock file.');

            % Clean up the lock file
            vlt.file.release_lock_file(lockFile, key);

            % Test that the lock file is now gone
            testCase.verifyFalse(vlt.file.isfile(lockFile), 'Lock file was not released.');
        end
    end
end
