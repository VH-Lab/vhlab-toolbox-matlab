classdef testNLayer < matlab.unittest.TestCase
    % TESTNLAYER - Unit tests for the vlt.signal.timeseriesDetectorML.NLayer class

    properties
        detectorSamples = 10;
        learningRate = 0.1;
        M = [4 1]; % One hidden layer with 4 nodes, one output node
    end

    methods (Test)
        function testConstructor(testCase)
            nlayer = vlt.signal.timeseriesDetectorML.NLayer(testCase.detectorSamples, testCase.M, testCase.learningRate);

            testCase.verifyEqual(nlayer.detectorSamples, testCase.detectorSamples);
            testCase.verifyEqual(nlayer.M, testCase.M);
            testCase.verifyEqual(nlayer.learningRate, testCase.learningRate);

            % Check number of weight matrices
            testCase.verifyEqual(numel(nlayer.weights), numel(testCase.M));

            % Check dimensions of weight matrices
            % Layer 1: 4 nodes, 10 inputs + 1 bias
            testCase.verifyEqual(size(nlayer.weights{1}), [testCase.M(1), testCase.detectorSamples + 1]);
            % Layer 2: 1 node, 4 inputs + 1 bias
            testCase.verifyEqual(size(nlayer.weights{2}), [testCase.M(2), testCase.M(1) + 1]);
        end

        function testConstructorError(testCase)
            % Test that constructor throws an error if the last layer is not 1
            M_invalid = [4 2];
            testCase.verifyError(@() vlt.signal.timeseriesDetectorML.NLayer(testCase.detectorSamples, M_invalid, testCase.learningRate), ...
                'NLayer:LastLayerError');
        end

        function testTraining(testCase)
            % Test if the network can learn a simple XOR-like problem
            rng('default'); % for reproducibility
            nlayer = vlt.signal.timeseriesDetectorML.NLayer(2, [2 1], 0.5); % 2 inputs, 2 hidden, 1 output

            % Simple XOR problem
            observations = [0 0 1 1; 0 1 0 1];
            TFvalues = [0 1 1 0];

            [nlayer, scores, ~] = nlayer.train(observations, TFvalues, true, 2000);

            % Check if the scores are reasonably close to the target values
            testCase.verifyTrue(scores(1) < 0.2, 'XOR(0,0) should be close to 0');
            testCase.verifyTrue(scores(2) > 0.8, 'XOR(0,1) should be close to 1');
            testCase.verifyTrue(scores(3) > 0.8, 'XOR(1,0) should be close to 1');
            testCase.verifyTrue(scores(4) < 0.2, 'XOR(1,1) should be close to 0');
        end
    end
end