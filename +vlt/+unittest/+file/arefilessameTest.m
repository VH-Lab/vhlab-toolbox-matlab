classdef arefilessameTest < matlab.unittest.TestCase
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
        function testArefilessame(testCase)
            % Create test files
            file1 = fullfile(testCase.TestDir, 'file1.txt');
            file2 = fullfile(testCase.TestDir, 'file2.txt');
            file3 = fullfile(testCase.TestDir, 'file3.txt');

            content1 = 'This is the content of file1 and file2.';
            content2 = 'This is the content of file3.';

            fid = fopen(file1, 'w');
            fwrite(fid, content1);
            fclose(fid);

            fid = fopen(file2, 'w');
            fwrite(fid, content1);
            fclose(fid);

            fid = fopen(file3, 'w');
            fwrite(fid, content2);
            fclose(fid);

            % Test that identical files are identified as the same
            b = vlt.file.arefilessame(file1, file2);
            testCase.verifyTrue(logical(b), 'Failed to identify identical files as the same.');

            % Test that different files are identified as different
            b = vlt.file.arefilessame(file1, file3);
            testCase.verifyFalse(logical(b), 'Failed to identify different files as different.');
        end
    end
end
