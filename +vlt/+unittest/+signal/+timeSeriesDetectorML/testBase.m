classdef testBase < matlab.unittest.TestCase
    % TESTBASE - test for vlt.signal.timeseriesDetectorML.base

    properties
        tempDir
    end

    methods (TestMethodSetup)
        function createTempDir(testCase)
            % Create a temporary directory for test files
            testCase.tempDir = tempname;
            mkdir(testCase.tempDir);

            % Create parameters.json
            params.timeseriesDetectorMLClassName = 'vlt.signal.timeseriesDetectorML.conv1dNet';
            params.creatorInputArgs(1).name = 'detectorSamples';
            params.creatorInputArgs(1).value = 10;

            jsonTxt = jsonencode(params);
            fid = fopen(fullfile(testCase.tempDir, 'parameters.json'), 'w');
            fprintf(fid, '%s', jsonTxt);
            fclose(fid);

            % Create positive example files
            positiveExamples = rand(10, 5);
            save(fullfile(testCase.tempDir, 'data_positive_01.mat'), 'positiveExamples');
            positiveExamples = rand(10, 3);
            save(fullfile(testCase.tempDir, 'data_positive_02.mat'), 'positiveExamples');

            % Create negative example files
            negativeExamples = rand(10, 8);
            save(fullfile(testCase.tempDir, 'data_negative_01.mat'), 'negativeExamples');
            negativeExamples = rand(10, 4);
            save(fullfile(testCase.tempDir, 'data_negative_02.mat'), 'negativeExamples');
        end
    end

    methods (TestMethodTeardown)
        function removeTempDir(testCase)
            % Remove the temporary directory and its contents
            rmdir(testCase.tempDir, 's');
        end
    end

    methods (Test)
        function testBuildFromDirectory(testCase)
            % Test the buildTimeseriesDetectorMLFromDirectory method
            detector = vlt.signal.timeseriesDetectorML.base.buildTimeseriesDetectorMLFromDirectory(testCase.tempDir);

            % Verify that the detector is of the correct class
            testCase.verifyClass(detector, 'vlt.signal.timeseriesDetectorML.conv1dNet');

            % Verify that some training has occurred (very basic check)
            % A more thorough test would require a mock object or deeper inspection
            testCase.verifyNotEmpty(detector.Net, 'The network should be trained.');
        end
    end
end
