classdef filenamesearchreplaceTest < matlab.unittest.TestCase

    properties
        testDir,
        outDir
    end

    methods(TestMethodSetup)
        function createTestDir(testCase)
            testCase.testDir = tempname;
            mkdir(testCase.testDir);
            testCase.outDir = tempname;
            mkdir(testCase.outDir);
        end
    end

    methods(TestMethodTeardown)
        function removeTestDir(testCase)
            if exist(testCase.testDir,'dir')
                rmdir(testCase.testDir,'s');
            end
            if exist(testCase.outDir,'dir')
                rmdir(testCase.outDir,'s');
            end
        end
    end

    methods(Test)

        function test_simple_rename(testCase)
            old_filename = fullfile(testCase.testDir, 'test.txt');
            fclose(fopen(old_filename, 'w'));

            vlt.file.filenamesearchreplace(testCase.testDir, {'test'}, {'renamed'});

            new_filename = fullfile(testCase.testDir, 'renamed.txt');

            testCase.verifyTrue(exist(new_filename, 'file')==2);
            testCase.verifyTrue(exist(old_filename, 'file')==2); % original should still exist
        end

        function test_delete_original(testCase)
            old_filename = fullfile(testCase.testDir, 'test.txt');
            fclose(fopen(old_filename, 'w'));

            vlt.file.filenamesearchreplace(testCase.testDir, {'test'}, {'renamed'}, 'deleteOriginals', 1);

            new_filename = fullfile(testCase.testDir, 'renamed.txt');

            testCase.verifyTrue(exist(new_filename, 'file')==2);
            testCase.verifyFalse(exist(old_filename, 'file')==2); % original should be deleted
        end

        function test_output_dir(testCase)
            old_filename = fullfile(testCase.testDir, 'test.txt');
            fclose(fopen(old_filename, 'w'));

            vlt.file.filenamesearchreplace(testCase.testDir, {'test'}, {'renamed'}, ...
                'useOutputDir', 1, 'OutputDirPath', testCase.outDir, 'OutputDir', 'new');

            new_filename = fullfile(testCase.outDir, 'new', 'renamed.txt');

            testCase.verifyTrue(exist(new_filename, 'file')==2);
            testCase.verifyTrue(exist(old_filename, 'file')==2); % original should still exist
        end

        function test_recursive(testCase)
            subDir = fullfile(testCase.testDir, 'sub');
            mkdir(subDir);
            old_filename = fullfile(subDir, 'test.txt');
            fclose(fopen(old_filename, 'w'));

            vlt.file.filenamesearchreplace(testCase.testDir, {'test'}, {'renamed'}, 'recursive', 1);

            new_filename = fullfile(subDir, 'renamed.txt');

            testCase.verifyTrue(exist(new_filename, 'file')==2);
            testCase.verifyTrue(exist(old_filename, 'file')==2);
        end

        function test_noop(testCase)
            old_filename = fullfile(testCase.testDir, 'test.txt');
            fclose(fopen(old_filename, 'w'));

            vlt.file.filenamesearchreplace(testCase.testDir, {'test'}, {'renamed'}, 'noOp', 1);

            new_filename = fullfile(testCase.testDir, 'renamed.txt');

            testCase.verifyFalse(exist(new_filename, 'file')==2);
            testCase.verifyTrue(exist(old_filename, 'file')==2);
        end

    end
end
