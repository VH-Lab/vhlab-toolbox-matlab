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
        function testDetectEvents(testCase)
            % Test the detectEvents method

            % Use a local dummy class
            % We need to make sure DummyDetector is on the path or in the package
            % Assuming DummyDetector is created in the same directory as this test

            try
                detector = vlt.unittest.signal.timeSeriesDetectorML.DummyDetector();
            catch
                % Fallback if package path is an issue (e.g. during dev)
                % But for now assume it works if file exists
                error('Could not instantiate DummyDetector. Make sure it is in +vlt/+unittest/+signal/+timeSeriesDetectorML/');
            end

            % Data: [0 0.8 0 0.8 0]
            % Events at indices 2 and 4.
            data = [0; 0.8; 0; 0.8; 0];

            % Test 1: Basic indices
            [events, likelihood] = detector.detectEvents(data, 'threshold', 0.5);
            testCase.verifyEqual(events, [2; 4], 'Failed to detect event indices.');
            testCase.verifyEqual(likelihood, data, 'Likelihood output incorrect.');

            % Test 2: With timestamps
            timestamps = [10; 11; 12; 13; 14];
            [eventsTime, likelihood2] = detector.detectEvents(data, 'threshold', 0.5, 'timestamps', timestamps);
            testCase.verifyEqual(eventsTime, [11; 13], 'Failed to map events to timestamps.');
            testCase.verifyEqual(likelihood2, data, 'Likelihood output incorrect with timestamps.');

            % Test 3: With timestamps but empty events
            dataEmpty = [0; 0; 0];
            timestampsEmpty = [10; 11; 12];
            eventsEmpty = detector.detectEvents(dataEmpty, 'threshold', 0.5, 'timestamps', timestampsEmpty);
            testCase.verifyEmpty(eventsEmpty, 'Should return empty events.');
        end

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

            [observations, TFvalues, newTimeStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2NegativeObservations(...
                t, timeSeriesData, positiveEventTimes, detectorSamples, ...
                'minimumSpacingFromPositive', minSpacing, ...
                'negativeDataSetSize', numNegatives);

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

        function testNegativeShoulderEvents(testCase)
            % Test the negativeShoulderEvents method

            dt = 0.001;
            t = (0:dt:1)';
            timeSeriesData = randn(size(t));
            detectorSamples = 10;

            % Defined positive events
            positiveEventTimes = [0.2, 0.5];

            % Call negativeShoulderEvents with specific options to test logic
            % Default is -0.010 to -0.005 (left) and 0.005 to 0.010 (right)
            % Left: -10 to -5 samples (6 samples)
            % Right: +5 to +10 samples (6 samples)
            % Total 12 per event * 2 events = 24 total.

            [observations, TFvalues, newTimeStamps] = vlt.signal.timeseriesDetectorML.base.negativeShoulderEvents(...
                t, timeSeriesData, positiveEventTimes, detectorSamples);

            % Verify counts
            testCase.verifyEqual(numel(newTimeStamps), 24, 'Default parameters should generate 12 events per positive event.');
            testCase.verifyTrue(all(~TFvalues), 'All TFvalues should be false.');

            % Verify refractory period check
            % Let's create a case where shoulders overlap/impinge
            % Event A at 0.200
            % Event B at 0.206
            % Right shoulder of A: 0.205 to 0.210
            % B is at 0.206.
            % Shoulder A at 0.205 is |0.205 - 0.206| = 0.001 < 0.002. Should be removed.
            % Shoulder A at 0.206 is |0.206 - 0.206| = 0.000 < 0.002. Should be removed.
            % Shoulder A at 0.207 is |0.207 - 0.206| = 0.001 < 0.002. Should be removed.
            % Shoulder A at 0.208 is |0.208 - 0.206| = 0.002 <= 0.002. Should be removed.
            % Shoulder A at 0.209 is |0.209 - 0.206| = 0.003 > 0.002. Kept.

            positiveEventTimesOverlap = [0.200, 0.206];
             [~, ~, newTimeStampsOverlap] = vlt.signal.timeseriesDetectorML.base.negativeShoulderEvents(...
                t, timeSeriesData, positiveEventTimesOverlap, detectorSamples);

            % Check that no timestamp is within 0.002 of any positive event
            for i=1:numel(newTimeStampsOverlap)
                 minDist = min(abs(newTimeStampsOverlap(i) - positiveEventTimesOverlap));
                 testCase.verifyTrue(minDist > 0.002, sprintf('Timestamp %f is too close (%f) to a positive event.', newTimeStampsOverlap(i), minDist));
            end
        end
    end
end