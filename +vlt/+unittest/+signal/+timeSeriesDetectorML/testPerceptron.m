classdef testPerceptron < matlab.unittest.TestCase
    % testPerceptron - Unit tests for the vlt.signal.timeseriesDetectorML.perceptron class
    %

    methods (Test)
        function testCreationAndInitialization(testCase)
            % Test that the perceptron object is created with the correct properties
            detectorSamples = 10;
            learningRate = 0.05;
            p = vlt.signal.timeseriesDetectorML.perceptron(detectorSamples, learningRate);

            testCase.verifyEqual(p.detectorSamples, detectorSamples);
            testCase.verifyEqual(p.learningRate, learningRate);
            testCase.verifyEqual(size(p.weights), [detectorSamples + 1, 1]);
        end

        function testTraining(testCase)
            % Test that the training process modifies the weights
            p = vlt.signal.timeseriesDetectorML.perceptron(2, 0.1);
            initialWeights = p.weights;

            % Simple linearly separable data
            observations = [1 1; -1 -1]';
            TFvalues = [true, false];

            p = p.train(observations, TFvalues);

            testCase.verifyNotEqual(p.weights, initialWeights);
        end

        function testEvaluation(testCase)
            % Test the evaluation of a time series after training
            detectorSamples = 3;
            p = vlt.signal.timeseriesDetectorML.perceptron(detectorSamples, 0.1);

            % Define a positive and negative pattern
            pattern_pos = [0.5; 1.0; 0.5];
            pattern_neg = [-0.5; -1.0; -0.5];
            observations = [pattern_pos, pattern_neg];
            TFvalues = [true, false];

            % Train for several epochs to ensure convergence
            for i = 1:20
                p = p.train(observations, TFvalues);
            end

            % Create a time series with the patterns embedded
            timeSeriesData = [zeros(5,1); pattern_pos; zeros(5,1); pattern_neg; zeros(5,1)];

            likelihood = p.evaluateTimeSeries(timeSeriesData);

            % The likelihood should be 1 at the end of the positive pattern
            % and 0 at the end of the negative pattern.
            endOfPosPatternIndex = 5 + length(pattern_pos);
            endOfNegPatternIndex = 5 + length(pattern_pos) + 5 + length(pattern_neg);

            testCase.verifyEqual(likelihood(endOfPosPatternIndex), 1, ...
                'Should detect the positive pattern');
            testCase.verifyEqual(likelihood(endOfNegPatternIndex), 0, ...
                'Should not detect the negative pattern');
        end

        function testReset(testCase)
            % Test the doReset functionality in the train method
            p = vlt.signal.timeseriesDetectorML.perceptron(2, 0.1);
            observations = [1 1; -1 -1]';
            TFvalues = [true, false];

            p_trained = p.train(observations, TFvalues);
            trained_weights = p_trained.weights;

            % Train again with reset flag
            p_reset = p_trained.train(observations, TFvalues, true);

            % The weights should be different from the trained weights
            testCase.verifyNotEqual(p_reset.weights, trained_weights);
        end
    end
end