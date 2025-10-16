classdef testBase < matlab.unittest.TestCase
    properties
        t_vec = (0:0.001:1-0.001)';
        d_vec = randn(1000,1);
        detectorSamples = 5;
    end
    methods (Test)
        function testTimeStamps2Observations(testCase)
            stamps = [0.5];
            [obs, tf] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testCase.d_vec, stamps, testCase.detectorSamples, true);
            testCase.verifyEqual(size(obs), [testCase.detectorSamples, 1]);
            testCase.verifyTrue(tf);
        end

        function testJitter(testCase)
            stamps = [0.5];
            jitter_stamps = vlt.signal.timeseriesDetectorML.base.jitterPositiveObservations(stamps, testCase.t_vec, 'jitterRange', 0.002);
            testCase.verifyEqual(numel(jitter_stamps), 4);
        end

        function testShoulders(testCase)
            stamps = [0.5];
            shoulder_stamps = vlt.signal.timeseriesDetectorML.base.shoulderNegativeObservations(stamps, testCase.t_vec, 'shoulderRangeStart', 0.010, 'shoulderRangeStop', 0.012);
            testCase.verifyEqual(numel(shoulder_stamps), 6);
        end

        function testDetectIndividualEvents(testCase)
            detectorOutput = zeros(1, numel(testCase.t_vec));
            detectorOutput(20:30) = 1;
            detectorOutput(70:80) = 1;
            [eventTimes, ~] = vlt.signal.timeseriesDetectorML.base.detectIndividualEvents(testCase.t_vec, detectorOutput, 'threshold', 0.5, 'refractoryPeriod', 0.020);
            testCase.verifyEqual(numel(eventTimes), 2);
            testCase.verifyEqual(eventTimes(1), testCase.t_vec(25), 'AbsTol', 1e-9);
            testCase.verifyEqual(eventTimes(2), testCase.t_vec(75), 'AbsTol', 1e-9);
        end
    end
end