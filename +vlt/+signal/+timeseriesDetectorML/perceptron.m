classdef perceptron < vlt.signal.timeseriesDetectorML.base
    % PERCEPTRON - A perceptron-based time series detector

    properties
        learningRate (1,1) double {mustBePositive} = 0.1;
        weights (:,1) double
    end

    methods
        function obj = perceptron(detectorSamples, learningRate)
            if nargin > 0
                obj.detectorSamples = detectorSamples;
                if nargin > 1
                    obj.learningRate = learningRate;
                end
                obj = obj.initialize();
            end
        end

        function obj = initialize(obj)
            obj.weights = (rand(obj.detectorSamples + 1, 1) - 0.5) / 10;
        end

        function [obj, scores, errorEachIteration] = train(obj, observation, TFvalues, doReset, numIterations, falsePositivePenalty)
            if nargin < 4, doReset = false; end
            if nargin < 5, numIterations = 100; end
            if nargin < 6, falsePositivePenalty = 1; end

            if doReset
                obj = obj.initialize();
            end

            X = [ones(1, size(observation, 2)); observation];
            y = double(TFvalues(:)');

            errorEachIteration = zeros(1, numIterations);

            for iter = 1:numIterations
                scores = obj.weights' * X;
                predictions = 1 ./ (1 + exp(-scores)); % Sigmoid activation
                errors = y - predictions;

                fp_indices = (errors < 0);
                errors(fp_indices) = errors(fp_indices) * falsePositivePenalty;

                obj.weights = obj.weights + obj.learningRate * X * errors';

                errorEachIteration(iter) = mean(errors.^2);
            end
            scores = 1 ./ (1 + exp(-(obj.weights' * X))); % Final scores as likelihoods
        end

        function [detectLikelihood] = evaluateTimeSeries(obj, timeSeriesData)
            detectLikelihood = zeros(size(timeSeriesData));
            for i = 1:numel(timeSeriesData) - obj.detectorSamples + 1
                obs = timeSeriesData(i:i+obj.detectorSamples-1);
                obs_with_bias = [1; obs(:)];
                score = obj.weights' * obs_with_bias;

                center_index = i + floor(obj.detectorSamples/2);
                detectLikelihood(center_index) = 1 ./ (1 + exp(-score)); % Sigmoid activation
            end
        end
    end
end