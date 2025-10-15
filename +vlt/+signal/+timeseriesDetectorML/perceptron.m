classdef perceptron < vlt.signal.timeseriesDetectorML.base
    % vlt.signal.timeseriesDetectorML.perceptron - A perceptron-based time series detector
    %

    properties
        learningRate (1,1) double {mustBePositive} = 0.1; % The learning rate for the perceptron
        weights      (:,1) double;                         % The weights for the perceptron
    end

    methods
        function obj = perceptron(detectorSamples, learningRate)
            % PERCEPTRON - Create a new Perceptron detector
            %
            %   obj = vlt.signal.timeseriesDetectorML.perceptron(detectorSamples, learningRate)
            %
            %   Creates a new Perceptron detector with the given number of detector samples
            %   and learning rate.
            %
            if nargin > 0
                obj.detectorSamples = detectorSamples;
            end
            if nargin > 1
                obj.learningRate = learningRate;
            end
            obj = obj.initialize();
        end

        function obj = initialize(obj)
            % INITIALIZE - Initialize the learning parameters
            %
            %   obj = initialize(obj)
            %
            %   Initializes or re-initializes the learning parameters of the detector.
            %
            obj.weights = (rand(obj.detectorSamples + 1, 1) * 2) - 1; % Initialize weights between -1 and 1, +1 for bias
        end

        function [obj, scores, errorEachIteration] = train(obj, observation, TFvalues, doReset, numIterations, falsePositivePenalty)
            % TRAIN - Train the detector
            %
            arguments
                obj
                observation (:,:) double
                TFvalues (1,:) logical
                doReset (1,1) logical = false
                numIterations (1,1) uint64 = 100
                falsePositivePenalty (1,1) double = 1
            end

            if doReset
                obj = obj.initialize();
            end

            numObservations = size(observation, 2);
            errorEachIteration = zeros(1, numIterations);
            all_inputs = [observation; ones(1, numObservations)]; % Add bias term to all observations

            for iter = 1:numIterations
                scores = double(all_inputs' * obj.weights > 0)';
                errors = double(TFvalues) - scores;

                errorEachIteration(iter) = mean(errors.^2);

                for i = 1:numObservations
                    if errors(i) ~= 0
                        penalty = 1;
                        if errors(i) < 0 % This is a false positive (expected 0, got 1)
                            penalty = falsePositivePenalty;
                        end
                        obj.weights = obj.weights + penalty * obj.learningRate * errors(i) * all_inputs(:, i);
                    end
                end
            end

            % Final scores after all iterations
            scores = double(all_inputs' * obj.weights > 0)';
        end

        function [detectLikelihood] = evaluateTimeSeries(obj, timeSeriesData)
            % EVALUATETIMESERIES - Evaluate the likelihood of a pattern at each time step
            %
            if isrow(timeSeriesData)
                timeSeriesData = timeSeriesData'; % Ensure it's a column vector
            end

            numSamples = length(timeSeriesData);
            detectLikelihood = zeros(1, numSamples);

            for i = obj.detectorSamples:numSamples
                inputVector = [timeSeriesData(i - obj.detectorSamples + 1:i); 1]; % Add bias term
                detectLikelihood(i) = double(inputVector' * obj.weights > 0);
            end
        end
    end
end