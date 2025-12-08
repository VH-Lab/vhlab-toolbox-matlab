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

        function testTimeStamps2NegativeObservations(testCase)
            % Test the timeStamps2NegativeObservations method

            % Setup test data
            dt = 0.001;
            t = (0:dt:10)';
            timeSeriesData = sin(2*pi*10*t); % Dummy signal
            detectorSamples = 100;

            % Define some "known" positive events
            positiveEventTimes = [1.0, 2.0, 3.0, 4.0, 5.0];

            % Constraints
            minSpacing = 0.1; % 100ms
            numNegatives = 50;

            options.minimumSpacingFromPositive = minSpacing;
            options.negativeDataSetSize = numNegatives;

            [observations, TFvalues, newTimeStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2NegativeObservations(...
                t, timeSeriesData, positiveEventTimes, detectorSamples, options);

            % Verify output dimensions
            testCase.verifySize(observations, [detectorSamples, numNegatives], 'Observations matrix has incorrect size.');
            testCase.verifySize(TFvalues, [1, numNegatives], 'TFvalues has incorrect size.');
            testCase.verifySize(newTimeStamps, [1, numNegatives], 'newTimeStamps has incorrect size.');

            % Verify all TFvalues are false
            testCase.verifyTrue(all(~TFvalues), 'All TFvalues should be false.');

            % Verify minimum spacing constraint
            for i = 1:numel(newTimeStamps)
                distToPositives = abs(positiveEventTimes - newTimeStamps(i));
                minDist = min(distToPositives);
                testCase.verifyTrue(minDist >= minSpacing, ...
                    sprintf('Negative example at %f is too close (%f) to a positive event.', newTimeStamps(i), minDist));
            end

            % Verify that observations are actually from the data
            % Just check one random one
            idx = randi(numNegatives);
            ts = newTimeStamps(idx);
            [~, t_idx] = min(abs(t - ts));
            expected_start = t_idx - floor(detectorSamples/2);
            expected_end = expected_start + detectorSamples - 1;

            if expected_start >= 1 && expected_end <= numel(timeSeriesData)
                expected_obs = timeSeriesData(expected_start:expected_end);
                testCase.verifyEqual(observations(:, idx), expected_obs, 'Extracted observation does not match data.');
            end
        end

        function testTimeStamps2NegativeObservationsDefaults(testCase)
            % Test default behavior
             % Setup test data
            dt = 0.001;
            t = (0:dt:1)';
            timeSeriesData = randn(size(t));
            detectorSamples = 10;
            positiveEventTimes = [0.2, 0.5];

            % Call without options struct (using default arguments)
            % But since arguments are in a name-value block, we pass empty options or just rely on defaults if we didn't pass options?
            % The function signature is `options.negativeDataSetSize (1,1) double = []`.
            % So we can pass specific name-value pairs or rely on defaults.

            [observations, ~, newTimeStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2NegativeObservations(...
                t, timeSeriesData, positiveEventTimes, detectorSamples);

            % Default size should be 2 * numel(positiveEventTimes) = 4
            expectedSize = 2 * numel(positiveEventTimes);
            testCase.verifyEqual(size(observations, 2), expectedSize, 'Default negative data set size should be 2 * numPositives.');
        end
    end
end