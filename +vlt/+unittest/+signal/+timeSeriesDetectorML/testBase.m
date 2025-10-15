classdef testBase < matlab.unittest.TestCase
    methods (Test)
        function testTimeStamps2Observations(testCase)
            timeSeriesTimeStamps = (0.1:0.1:10)';
            timeSeriesData = (1:100)';
            detectedTimeStamps = [1.0, 5.0, 9.0];
            detectorSamples = 5;

            [observations, newTimeStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                timeSeriesTimeStamps, timeSeriesData, detectedTimeStamps, detectorSamples);

            testCase.verifyEqual(size(observations), [5, 3]);
            testCase.verifyEqual(newTimeStamps, [1.0, 5.0, 9.0], 'AbsTol', 1e-9);
            testCase.verifyEqual(observations(:, 2), (48:52)');
        end

        function testTimeStamps2ObservationsPeakFinding(testCase)
            timeSeriesTimeStamps = (0:0.1:20)';
            timeSeriesData = sin(timeSeriesTimeStamps)';
            peak_time = 1.5; % near pi/2
            [~,peak_idx] = min(abs(timeSeriesTimeStamps-peak_time));
            timeSeriesData(peak_idx) = 2;

            detectedTimeStamps = [1.4];
            detectorSamples = 5;

            [~, newTimeStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                timeSeriesTimeStamps, timeSeriesData, detectedTimeStamps, detectorSamples, 'optimizeForPeak', true, 'peakFindingSamples', 10);

            testCase.verifyEqual(newTimeStamps, timeSeriesTimeStamps(peak_idx), 'AbsTol', 1e-9);
        end

        function testTimeStamps2ObservationsNegativePeakFinding(testCase)
            timeSeriesTimeStamps = (0:0.1:20)';
            timeSeriesData = sin(timeSeriesTimeStamps)';
            neg_peak_time = 4.7; % near 3*pi/2
            [~,neg_peak_idx] = min(abs(timeSeriesTimeStamps-neg_peak_time));
            timeSeriesData(neg_peak_idx) = -2;

            detectedTimeStamps = [4.6];
            detectorSamples = 5;

            [~, newTimeStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                timeSeriesTimeStamps, timeSeriesData, detectedTimeStamps, detectorSamples, 'optimizeForPeak', true, ...
                'peakFindingSamples', 10, 'useNegativeForPeak', true);

            testCase.verifyEqual(newTimeStamps, timeSeriesTimeStamps(neg_peak_idx), 'AbsTol', 1e-9);
        end

        function testTimeStamps2ObservationsEdgeCases(testCase)
            timeSeriesTimeStamps = (0.1:0.1:2.0)';
            timeSeriesData = (1:20)';
            detectedTimeStamps = [0.2, 1.0, 1.9];
            detectorSamples = 5;

            [observations, newTimeStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                timeSeriesTimeStamps, timeSeriesData, detectedTimeStamps, detectorSamples);

            testCase.verifyEqual(size(observations), [5, 1]);
            testCase.verifyEqual(newTimeStamps, 1.0, 'AbsTol', 1e-9);
        end
    end
end