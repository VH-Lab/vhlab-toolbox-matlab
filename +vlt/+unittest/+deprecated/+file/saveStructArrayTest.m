classdef saveStructArrayTest < matlab.unittest.TestCase
    properties
        TestDir
    end

    methods (TestMethodSetup)
        function createFixture(testCase)
            testCase.TestDir = tempname;
            mkdir(testCase.TestDir);
        end
    end

    methods (TestMethodTeardown)
        function deleteFixture(testCase)
            rmdir(testCase.TestDir, 's');
        end
    end

    methods (Test)
        function testSaveStructArray(testCase)
            testFile = fullfile(testCase.TestDir, 'test.txt');
            testStructArray = struct('a', {1, 2}, 'b', {'hello', 'world'});

            saveStructArray(testFile, testStructArray);

            % Read the file back and verify contents
            fid = fopen(testFile, 'r');
            cleanup = onCleanup(@() fclose(fid));

            header = fgetl(fid);
            line1 = fgetl(fid);
            line2 = fgetl(fid);

            testCase.verifyEqual(header, sprintf('a\tb'));
            testCase.verifyEqual(line1, sprintf('1\thello'));
            testCase.verifyEqual(line2, sprintf('2\tworld'));
        end
    end
end
