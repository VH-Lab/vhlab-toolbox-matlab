classdef testPerceptron < matlab.unittest.TestCase
    % TESTPERCEPTRON - Unit tests for the vlt.signal.timeseriesDetectorML.perceptron class

    properties
        detectorSamples = 10;
        learningRate = 0.1;
    end

    methods (Test)
        function testConstructor(testCase)
            p = vlt.signal.timeseriesDetectorML.perceptron(testCase.detectorSamples, testCase.learningRate);
            testCase.verifyEqual(p.detectorSamples, testCase.detectorSamples);
            testCase.verifyEqual(p.learningRate, testCase.learningRate);
            testCase.verifyEqual(size(p.weights), [testCase.detectorSamples + 1, 1]);
        end

        function testTraining(testCase)
            p = vlt.signal.timeseriesDetectorML.perceptron(testCase.detectorSamples, testCase.learningRate);

            obs_pos = ones(testCase.detectorSamples, 5);
            tf_pos = true(1,5);
            obs_neg = zeros(testCase.detectorSamples, 5);
            tf_neg = false(1,5);

            observations = [obs_pos, obs_neg];
            TFvalues = [tf_pos, tf_neg];

            [p, scores, ~] = p.train(observations, TFvalues);

            testCase.verifyTrue(all(scores(1:5) > 0.5));
            testCase.verifyTrue(all(scores(6:10) < 0.5));
        end

        function testEvaluation(testCase)
            p = vlt.signal.timeseriesDetectorML.perceptron(testCase.detectorSamples, testCase.learningRate);

            timeSeriesData = zeros(1, 100);
            timeSeriesData(50:50+testCase.detectorSamples-1) = 1;

            likelihood = p.evaluateTimeSeries(timeSeriesData);

            [~, max_idx] = max(likelihood);
            testCase.verifyGreaterThan(max_idx, 40);
            testCase.verifyLessThan(max_idx, 60);
            testCase.verifyGreaterThanOrEqual(max(likelihood), 0.5);
            testCase.verifyLessThanOrEqual(min(likelihood), 0.5);
        end
    end
end