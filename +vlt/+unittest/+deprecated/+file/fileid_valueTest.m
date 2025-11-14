classdef fileid_valueTest < matlab.unittest.TestCase

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

        function test_with_numeric_fid(testCase)
            numeric_fid = 5;
            fid = fileid_value(numeric_fid);
            testCase.verifyEqual(fid, numeric_fid);

            numeric_fid = -1;
            fid = fileid_value(numeric_fid);
            testCase.verifyEqual(fid, numeric_fid);
        end

        function test_with_fileobj_closed(testCase)
            fo = fileobj('fullpathfilename', testCase.testFile);
            fid = fileid_value(fo);
            testCase.verifyEqual(fid, -1);
            delete(fo);
        end

        function test_with_fileobj_open(testCase)
            fo = fileobj('fullpathfilename', testCase.testFile);
            fo.fopen('w');

            fid = fileid_value(fo);
            testCase.verifyGreaterThan(fid, 2); % Should be a valid fid

            fo.fclose();
            delete(fo);
        end

    end
end
