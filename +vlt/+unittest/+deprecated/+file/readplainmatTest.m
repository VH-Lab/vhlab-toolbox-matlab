classdef readplainmatTest < matlab.unittest.TestCase
    properties
        TestFile
        TestData = magic(5);
    end

    methods (TestMethodSetup)
        function createTestFile(testCase)
            testCase.TestFile = [tempname '.mat'];
            fid = fopen(testCase.TestFile, 'w');
            if fid == -1
                error('Could not create test file.');
            end
            writeplainmat(fid, testCase.TestData);
            fclose(fid);
        end
    end

    methods (TestMethodTeardown)
        function deleteTestFile(testCase)
            delete(testCase.TestFile);
        end
    end

    methods (Test)
        function testReadPlainMat(testCase)
            fid = fopen(testCase.TestFile, 'r');
            testCase.addTeardown(@() fclose(fid));

            output = readplainmat(fid);

            testCase.verifyEqual(output, testCase.TestData);
        end
    end
end
