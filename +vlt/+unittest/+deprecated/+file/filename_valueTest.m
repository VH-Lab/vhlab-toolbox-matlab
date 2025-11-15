classdef filename_valueTest < matlab.unittest.TestCase

    properties
        testDir
        testFile
    end

    methods(TestMethodSetup)
        function setup(testCase)
            testCase.testDir = tempname;
            mkdir(testCase.testDir);
            testCase.testFile = fullfile(testCase.testDir, 'testfile.bin');
        end
    end

    methods(TestMethodTeardown)
        function teardown(testCase)
            if exist(testCase.testDir, 'dir')
                rmdir(testCase.testDir, 's');
            end
        end
    end

    methods(Test)

        function test_with_char_array(testCase)
            filename_in = 'path/to/my/file.txt';
            filename_out = filename_value(filename_in);
            testCase.verifyEqual(filename_out, filename_in);
            testCase.verifyClass(filename_out, 'char');
        end

        function test_with_string_object(testCase)
            filename_in = "path/to/my/file.txt";
            filename_out = filename_value(filename_in);
            testCase.verifyEqual(filename_out, char(filename_in));
            testCase.verifyClass(filename_out, 'char');
        end

        function test_with_modern_fileobj(testCase)
            % This test relies on the modern `vlt.file.fileobj` being on the path
            fo = vlt.file.fileobj('fullpathfilename', testCase.testFile);
            filename_out = filename_value(fo);
            testCase.verifyEqual(filename_out, testCase.testFile);
            delete(fo);
        end

        function test_with_deprecated_fileobj(testCase)
            fo = fileobj('fullpathfilename', testCase.testFile);
            filename_out = filename_value(fo);
            testCase.verifyEqual(filename_out, testCase.testFile);
            delete(fo);
        end

    end
end
