classdef testBase < matlab.unittest.TestCase
    % TESTBASE - Unit tests for the vlt.signal.timeseriesDetectorML.base class
    %
    properties
        t_vec = (0:0.001:1-0.001)';
        d_vec = randn(1000,1);
        detectorSamples = 5;
    end

    methods (Test)
        function testTimeStamps2Observations(testCase)
            % Test basic conversion of a single timestamp to an observation
            stamps = [0.5];
            [obs, tf] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testCase.d_vec, stamps, testCase.detectorSamples, true);

            % Verify output size and type
            testCase.verifyEqual(size(obs), [testCase.detectorSamples, 1]);
            testCase.verifyTrue(tf);

            % Verify correct data window is extracted
            [~,idx] = min(abs(testCase.t_vec - 0.5));
            start_idx = idx - floor(testCase.detectorSamples/2);
            expected_obs = testCase.d_vec(start_idx:start_idx+testCase.detectorSamples-1);
            testCase.verifyEqual(obs, expected_obs);
        end

        function testJitter(testCase)
            % Test the jitter function to ensure it produces the correct number of stamps
            stamps = [0.5];
            jitter_range = 0.002;
            dt = testCase.t_vec(2)-testCase.t_vec(1);
            expected_num_jitters = numel(-jitter_range:dt:jitter_range) - 1; % subtract 1 for the zero shift

            jittered_stamps = vlt.signal.timeseriesDetectorML.base.jitterPositiveObservations(...
                stamps, testCase.t_vec, 'jitterRange', jitter_range);

            testCase.verifyEqual(numel(jittered_stamps), expected_num_jitters);

            % Ensure all jittered stamps are within the specified range
            testCase.verifyTrue(all(abs(jittered_stamps - stamps) <= jitter_range + 1e-9));
        end

        function testShoulders(testCase)
            % Test the shoulder function for generating negative examples
            stamps = [0.5];
            start_range = 0.010;
            stop_range = 0.012;
            dt = testCase.t_vec(2)-testCase.t_vec(1);
            expected_num_shoulders = numel(-stop_range:dt:-start_range) + numel(start_range:dt:stop_range);

            shoulder_stamps = vlt.signal.timeseriesDetectorML.base.shoulderNegativeObservations(...
                stamps, testCase.t_vec, 'shoulderRangeStart', start_range, 'shoulderRangeStop', stop_range);

            testCase.verifyEqual(numel(shoulder_stamps), expected_num_shoulders);

            distances = abs(shoulder_stamps - stamps);
            % Ensure all shoulder stamps are within the specified range
            testCase.verifyTrue(all(distances >= start_range - 1e-9 & distances <= stop_range + 1e-9));
        end

        function testDetectIndividualEvents(testCase)
            % Test the event detection logic, including Gaussian blur, peak finding, and refractory period

            % 1. Create a clear test signal with wider peaks
            detectorOutput = zeros(1, numel(testCase.t_vec));

            peak1_indices = 248:252; % 5ms wide peak
            peak2_indices = 258:262; % 5ms wide peak
            peak3_indices = 748:752; % 5ms wide peak

            detectorOutput(peak1_indices) = 1.0; % Strongest peak
            detectorOutput(peak2_indices) = 0.8; % Weaker peak, should be ignored by refractory logic
            detectorOutput(peak3_indices) = 0.9; % Second event

            % 2. Define parameters
            gaussianSigmaTime = 0.003; % 3ms sigma
            refractoryPeriod = 0.020; % 20ms
            threshold = 0.5;

            % 3. Run the actual function
            [eventTimes, ~] = vlt.signal.timeseriesDetectorML.base.detectIndividualEvents(...
                testCase.t_vec, detectorOutput, ...
                'gaussianSigmaTime', gaussianSigmaTime, ...
                'threshold', threshold, ...
                'refractoryPeriod', refractoryPeriod);

            % 4. Define expected outcome
            % We expect 2 events
            testCase.verifyEqual(numel(eventTimes), 2, 'Incorrect number of events detected.');

            % Check that one event is near 0.25s and the other near 0.75s
            testCase.verifyTrue(any(abs(eventTimes - 0.25) < 0.005), 'No event detected near 0.25s');
            testCase.verifyTrue(any(abs(eventTimes - 0.75) < 0.005), 'No event detected near 0.75s');
        end
    end
end