classdef filebackupTest < matlab.unittest.TestCase

    properties
        testDir
    end

    methods(TestMethodSetup)
        function createTestDir(testCase)
            testCase.testDir = tempname;
            mkdir(testCase.testDir);
        end
    end

    methods(TestMethodTeardown)
        function removeTestDir(testCase)
            if exist(testCase.testDir,'dir')
                rmdir(testCase.testDir,'s');
            end
        end
    end

    methods(Test)

        function test_basic_backup(testCase)
            fname = fullfile(testCase.testDir, 'test.txt');
            fclose(fopen(fname, 'w')); % create empty file

            backupname = filebackup(fname);

            [~, name, ext] = fileparts(fname);
            expected_backupname = fullfile(testCase.testDir, [name '_bkup001' ext]);

            testCase.verifyEqual(backupname, expected_backupname);
            testCase.verifyTrue(exist(expected_backupname, 'file')==2);
            testCase.verifyTrue(exist(fname, 'file')==2); % Original should still exist
        end

        function test_delete_orig(testCase)
            fname = fullfile(testCase.testDir, 'test.txt');
            fclose(fopen(fname, 'w'));

            backupname = filebackup(fname, 'DeleteOrig', 1);

            [~, name, ext] = fileparts(fname);
            expected_backupname = fullfile(testCase.testDir, [name '_bkup001' ext]);

            testCase.verifyEqual(backupname, expected_backupname);
            testCase.verifyTrue(exist(expected_backupname, 'file')==2);
            testCase.verifyFalse(exist(fname, 'file')==2); % Original should be deleted
        end

        function test_multiple_backups(testCase)
            fname = fullfile(testCase.testDir, 'test.txt');
            fclose(fopen(fname, 'w'));

            backup1 = filebackup(fname);
            backup2 = filebackup(fname);

            [~, name, ext] = fileparts(fname);
            expected_backup1 = fullfile(testCase.testDir, [name '_bkup001' ext]);
            expected_backup2 = fullfile(testCase.testDir, [name '_bkup002' ext]);

            testCase.verifyEqual(backup1, expected_backup1);
            testCase.verifyEqual(backup2, expected_backup2);
            testCase.verifyTrue(exist(expected_backup1, 'file')==2);
            testCase.verifyTrue(exist(expected_backup2, 'file')==2);
        end

        function test_custom_digits(testCase)
            fname = fullfile(testCase.testDir, 'test.txt');
            fclose(fopen(fname, 'w'));

            backupname = filebackup(fname, 'Digits', 5);

            [~, name, ext] = fileparts(fname);
            expected_backupname = fullfile(testCase.testDir, [name '_bkup00001' ext]);

            testCase.verifyEqual(backupname, expected_backupname);
            testCase.verifyTrue(exist(expected_backupname, 'file')==2);
        end

        function test_error_if_digits_exceeded(testCase)
            fname = fullfile(testCase.testDir, 'test.txt');
            [~,name,ext] = fileparts(fname);
            fclose(fopen(fname, 'w'));

            % create 9 backup files
            for i=1:9
                fclose(fopen(fullfile(testCase.testDir, [name '_bkup' sprintf('%01d',i) ext]),'w'));
            end

            testCase.verifyError(@() filebackup(fname, 'Digits', 1, 'ErrorIfDigitsExceeded', 1), '');
        end

        function test_no_error_if_digits_exceeded(testCase)
            fname = fullfile(testCase.testDir, 'test.txt');
            [~,name,ext] = fileparts(fname);
            fclose(fopen(fname, 'w'));

            % create 9 backup files to exceed digit count
            for i=1:9
                fclose(fopen(fullfile(testCase.testDir, [name '_bkup' sprintf('%01d',i) ext]),'w'));
            end

            backupname = filebackup(fname, 'Digits', 1, 'ErrorIfDigitsExceeded', 0);
            testCase.verifyEmpty(backupname);
        end

    end
end
