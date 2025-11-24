classdef fullfilenameTest < matlab.unittest.TestCase

    properties
        testDir
        originalDir
    end

    methods(TestMethodSetup)
        function setup(testCase)
            testCase.originalDir = pwd;
            testCase.testDir = tempname;
            mkdir(testCase.testDir);
            try
                cd(testCase.testDir);
            catch
                % If cd fails, ensure we don't leave the system in an inconsistent state
                % and fail the test gracefully or try to recover
                error('Could not change to temporary directory.');
            end
        end
    end

    methods(TestMethodTeardown)
        function teardown(testCase)
            try
                cd(testCase.originalDir);
            catch
                % If originalDir is gone (e.g. it was a temp dir itself), fall back to a safe location
                if ispc
                    cd(getenv('USERPROFILE'));
                else
                    cd(getenv('HOME'));
                end
            end

            if exist(testCase.testDir, 'dir')
                try
                    rmdir(testCase.testDir, 's');
                catch
                    % Ignore cleanup errors if we can't remove the dir
                end
            end
        end
    end

    methods(Test)

        function test_simple_filename(testCase)
            fname = 'myfile.txt';
            expected_fullname = fullfile(pwd, fname);

            fullname = fullfilename(fname);

            testCase.verifyEqual(fullname, expected_fullname);
        end

        function test_relative_path_bug(testCase)
            fname = fullfile('subdir', 'myfile.txt');
            % Due to the bug (not capturing 'ext' from fileparts),
            % the extension is dropped.
            expected_fullname = fullfile(pwd, 'subdir', 'myfile');

            fullname = fullfilename(fname);

            testCase.verifyEqual(fullname, expected_fullname, ...
                'This test documents a known bug where the extension is dropped.');
        end

        function test_full_path(testCase)
            % This test assumes that a path starting with the root directory
            % is considered a full path by `isfilepathroot`.
            fname = fullfile(filesep, 'path', 'to', 'myfile.txt');

            fullname = fullfilename(fname);

            testCase.verifyEqual(fullname, fname);
        end

        function test_usewhich_with_existing_file(testCase)
            fname = 'existingfile.txt';
            fclose(fopen(fname, 'w')); % create the file

            expected_fullname = which(fname); % which provides the full path

            fullname = fullfilename(fname, 1);

            testCase.verifyEqual(fullname, expected_fullname);
        end

        function test_usewhich_false(testCase)
            fname = 'anotherfile.txt';
            % File does not exist, so 'which' would be empty.
            % The function should fall back to prepending pwd.
            expected_fullname = fullfile(pwd, fname);

            fullname = fullfilename(fname, 0);

            testCase.verifyEqual(fullname, expected_fullname);
        end

    end
end
