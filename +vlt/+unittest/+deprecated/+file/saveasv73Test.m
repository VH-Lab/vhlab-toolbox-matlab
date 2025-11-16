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
            % Test saving a simple variable
            testFile = fullfile(testCase.TestDir, 'test.mat');
            testData = struct('a', 1, 'b', [2 3 4]);

            saveasv73(testFile, 'testData', testData);

            loadedData = load(testFile);
            testCase.verifyEqual(loadedData.testData, testData);

            % Verify the file is in v7.3 format
            S = whos('-file', testFile);
            testCase.verifyEqual(S.class, 'struct');
        end
    end
end
