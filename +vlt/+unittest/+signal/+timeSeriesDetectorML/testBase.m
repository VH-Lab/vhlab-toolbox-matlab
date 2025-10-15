classdef testBase < matlab.unittest.TestCase
    % testBase - Unit tests for the vlt.signal.timeseriesDetectorML.base class
    %

    methods (Test)
        function testTimeStamps2Observations(testCase)
            % Test the basic functionality of timeStamps2Observations
            timeSeriesData = (1:100)';
            detectedTimeStamps = [10, 50, 90];
            detectorSamples = 5;

            [observations, newTimeStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                timeSeriesData, detectedTimeStamps, detectorSamples);

            testCase.verifyEqual(size(observations), [5, 3]);
            testCase.verifyEqual(newTimeStamps, [10, 50, 90]);
            testCase.verifyEqual(observations(:, 2), (48:52)');
        end

        function testTimeStamps2ObservationsPeakFinding(testCase)
            % Test the peak finding functionality
            timeSeriesData = sin(0:0.1:20)'; % A simple sine wave
            % Place a peak near sample 16 (pi/2)
            timeSeriesData(16) = 2;
            detectedTimeStamps = [15];
            detectorSamples = 5;

            [~, newTimeStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                timeSeriesData, detectedTimeStamps, detectorSamples, 'optimizeForPeak', true, 'peakFindingSamples', 10);

            testCase.verifyEqual(newTimeStamps, [16]);
        end

        function testTimeStamps2ObservationsNegativePeakFinding(testCase)
            % Test the negative peak finding functionality
            timeSeriesData = sin(0:0.1:20)'; % A simple sine wave
            % Place a negative peak near sample 47 (3*pi/2)
            timeSeriesData(47) = -2;
            detectedTimeStamps = [45];
            detectorSamples = 5;

            [~, newTimeStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                timeSeriesData, detectedTimeStamps, detectorSamples, 'optimizeForPeak', true, ...
                'peakFindingSamples', 10, 'useNegativeForPeak', true);

            testCase.verifyEqual(newTimeStamps, [47]);
        end

        function testTimeStamps2ObservationsEdgeCases(testCase)
            % Test edge cases where the window is out of bounds
            timeSeriesData = (1:20)';
            detectedTimeStamps = [2, 10, 19];
            detectorSamples = 5;

            [observations, newTimeStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                timeSeriesData, detectedTimeStamps, detectorSamples);

            % Expect only the middle observation to be valid
            testCase.verifyEqual(size(observations), [5, 1]);
            testCase.verifyEqual(newTimeStamps, [10]);
        end

    end
end