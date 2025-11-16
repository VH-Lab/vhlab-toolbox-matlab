classdef relativeFilenameTest < matlab.unittest.TestCase
    properties
        baseDir
    end

    methods (TestMethodSetup)
        function createTestEnvironment(testCase)
            % Create a temporary directory structure for testing
            % /<tempdir>/base/
            % /<tempdir>/base/docs/
            % /<tempdir>/base/docs/folder1/folder2/
            % /<tempdir>/base/docs/myfolder/
            % /<tempdir>/base/docs/otherfolder/
            % /<tempdir>/base/another_root/

            testCase.baseDir = fullfile(tempdir, 'relativeFilenameTestBase');
            if exist(testCase.baseDir, 'dir'), rmdir(testCase.baseDir, 's'); end

            mkdir(fullfile(testCase.baseDir, 'docs', 'folder1', 'folder2'));
            mkdir(fullfile(testCase.baseDir, 'docs', 'myfolder'));
            mkdir(fullfile(testCase.baseDir, 'docs', 'otherfolder'));
            mkdir(fullfile(testCase.baseDir, 'another_root'));

            % Create dummy files to make paths valid filenames
            fclose(fopen(fullfile(testCase.baseDir, 'docs', 'myfolder', 'myfile.txt'), 'w'));
            fclose(fopen(fullfile(testCase.baseDir, 'another_root', 'myfile.txt'), 'w'));
            fclose(fopen(fullfile(testCase.baseDir, 'docs', 'otherfolder', 'myfile.txt'), 'w'));
            fclose(fopen(fullfile(testCase.baseDir, 'docs', 'myfile.txt'), 'w'));
        end
    end

    methods (TestMethodTeardown)
        function cleanupTestEnvironment(testCase)
            if exist(testCase.baseDir, 'dir'), rmdir(testCase.baseDir, 's'); end
        end
    end

    methods (Test)
        function testSubdirectory(testCase)
            abs_path = fullfile(testCase.baseDir, 'docs');
            abs_filename = fullfile(testCase.baseDir, 'docs', 'myfolder', 'myfile.txt');
            expected = ['myfolder' filesep 'myfile.txt'];
            actual = vlt.file.relativeFilename(abs_path, abs_filename);
            testCase.verifyEqual(actual, expected);
        end

        function testSiblingDirectory(testCase)
            abs_path = fullfile(testCase.baseDir, 'docs');
            abs_filename = fullfile(testCase.baseDir, 'another_root', 'myfile.txt');
            expected = ['..' filesep 'another_root' filesep 'myfile.txt'];
            actual = vlt.file.relativeFilename(abs_path, abs_filename);
            testCase.verifyEqual(actual, expected);
        end

        function testDeepSiblingDirectory(testCase)
            abs_path = fullfile(testCase.baseDir, 'docs', 'folder1', 'folder2');
            abs_filename = fullfile(testCase.baseDir, 'docs', 'otherfolder', 'myfile.txt');
            expected = ['..' filesep '..' filesep 'otherfolder' filesep 'myfile.txt'];
            actual = vlt.file.relativeFilename(abs_path, abs_filename);
            testCase.verifyEqual(actual, expected);
        end

        function testSameDirectory(testCase)
            abs_path = fullfile(testCase.baseDir, 'docs');
            abs_filename = fullfile(testCase.baseDir, 'docs', 'myfile.txt');
            expected = 'myfile.txt';
            actual = vlt.file.relativeFilename(abs_path, abs_filename);
            testCase.verifyEqual(actual, expected);
        end

        function testCustomFileSeparator(testCase)
            % This test is designed to work on any OS by creating a path structure
            % and then replacing the native filesep with a custom one for the function call.

            abs_path_native = fullfile(testCase.baseDir, 'docs');
            abs_filename_native = fullfile(testCase.baseDir, 'docs', 'myfolder', 'myfile.txt');

            % Use a custom separator. Forward slash is a good choice as it's not the filesep on Windows.
            % If on Unix, use backslash.
            if ispc
                custom_sep = '/';
            else
                custom_sep = '\';
            end

            abs_path_custom = strrep(abs_path_native, filesep, custom_sep);
            abs_filename_custom = strrep(abs_filename_native, filesep, custom_sep);

            expected = ['myfolder' custom_sep 'myfile.txt'];
            actual = vlt.file.relativeFilename(abs_path_custom, abs_filename_custom, custom_sep);
            testCase.verifyEqual(actual, expected);
        end
    end
end
