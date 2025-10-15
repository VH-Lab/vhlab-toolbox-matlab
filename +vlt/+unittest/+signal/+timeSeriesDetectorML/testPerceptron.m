classdef testPerceptron < matlab.unittest.TestCase
    % testPerceptron - Unit tests for the vlt.signal.timeseriesDetectorML.perceptron class
    %

    methods (Test)
        function testCreationAndInitialization(testCase)
            % Test that the perceptron object is created with the correct properties
            detectorSamples = 10;
            learningRate = 0.05;
            p = vlt.signal.timeseriesDetectorML.perceptron(detectorSamples, learningRate);

            testCase.verifyEqual(p.detectorSamples, uint64(detectorSamples));
            testCase.verifyEqual(p.learningRate, learningRate);
            testCase.verifyEqual(size(p.weights), [detectorSamples + 1, 1]);
        end

        function testTraining(testCase)
            % Test that the training process modifies the weights and returns error history
            p = vlt.signal.timeseriesDetectorML.perceptron(2, 0.1);
            p.weights = zeros(size(p.weights)); % Ensure a deterministic starting point
            initialWeights = p.weights;

            observations = [1 1; -1 -1]';
            TFvalues = [true, false];
            numIterations = 50;

            [p, ~, errorHistory] = p.train(observations, TFvalues, false, numIterations);

            testCase.verifyNotEqual(p.weights, initialWeights);
            testCase.verifyEqual(size(errorHistory), [1, numIterations]);
            % Error should be 0 at the end for this separable data
            testCase.verifyEqual(errorHistory(end), 0);
        end

        function testEvaluation(testCase)
            % Test the evaluation of a time series after training
            detectorSamples = 3;
            p = vlt.signal.timeseriesDetectorML.perceptron(detectorSamples, 0.1);

            pattern_pos = [0.5; 1.0; 0.5];
            pattern_neg = [-0.5; -1.0; -0.5];
            observations = [pattern_pos, pattern_neg];
            TFvalues = [true, false];

            p = p.train(observations, TFvalues, false, 100);

            % Create a time series with the patterns embedded
            timeSeriesData = [zeros(5,1); pattern_pos; zeros(5,1); pattern_neg; zeros(5,1)];

            likelihood = p.evaluateTimeSeries(timeSeriesData);

            % The likelihood should be 1 at the center of the positive pattern
            % and 0 at the center of the negative pattern.
            halfWindow = floor(detectorSamples/2);
            centerOfPosPatternIndex = 5 + halfWindow;
            centerOfNegPatternIndex = 5 + length(pattern_pos) + 5 + halfWindow;

            testCase.verifyEqual(likelihood(centerOfPosPatternIndex), 1, ...
                'Should detect the positive pattern');
            testCase.verifyEqual(likelihood(centerOfNegPatternIndex), 0, ...
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

        function testFalsePositivePenalty(testCase)
            % Test that the false positive penalty is applied correctly
            observation = [-1; -1]; % Input that will cause an error
            initial_weights = [1; 1; 1]; % Weights that will cause a false positive
            tf = false; % The correct answer is 0
            penalty = 5;

            % Case 1: No penalty
            p1 = vlt.signal.timeseriesDetectorML.perceptron(2, 0.1);
            p1.weights = initial_weights;
            p1_trained = p1.train(observation, tf, false, 1, 1); % Penalty of 1

            % Case 2: With penalty
            p2 = vlt.signal.timeseriesDetectorML.perceptron(2, 0.1);
            p2.weights = initial_weights;
            p2_trained = p2.train(observation, tf, false, 1, penalty);

            % Calculate the exact weight change vectors
            weight_change_1 = p1_trained.weights - p1.weights;
            weight_change_2 = p2_trained.weights - p2.weights;

            % The weight change vector with the penalty should be exactly
            % 'penalty' times the unpenalized one.
            testCase.verifyEqual(weight_change_2, penalty * weight_change_1, 'AbsTol', 1e-9);
        end
    end
end