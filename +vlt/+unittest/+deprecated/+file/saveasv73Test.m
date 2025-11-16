classdef saveasv73Test < matlab.unittest.TestCase
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
        function testSaveAsV73(testCase)
            % This function resaves an existing file in v7.3 format

            % 1. Create a file in the default format
            testFile = fullfile(testCase.TestDir, 'test.mat');
            testData = struct('a', 1, 'b', [2 3 4]);
            save(testFile, 'testData'); % save variable 'testData'

            % 2. Run the function to convert it
            saveasv73(testFile);

            % 3. Load the data back and verify it's the same
            loadedData = load(testFile);
            testCase.verifyEqual(loadedData.testData, testData);

            % 4. Verify the backup file was created
            [parentdir,fname,ext] = fileparts(testFile);
            backupFile = fullfile(parentdir, [fname '_old' ext]);
            testCase.verifyTrue(exist(backupFile, 'file') == 2);
        end
    end
end
