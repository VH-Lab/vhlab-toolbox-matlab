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

        function [obj, scores] = train(obj, observation, TFvalues, doReset)
            % TRAIN - Train the detector
            %
            %   [obj, scores] = train(obj, observation, TFvalues, doReset)
            %
            %   Trains the detector with training data.
            %
            arguments
                obj
                observation (:,:) double
                TFvalues (1,:) logical
                doReset (1,1) logical = false
            end

            if doReset
                obj = obj.initialize();
            end

            numObservations = size(observation, 2);
            scores = zeros(1, numObservations);

            for i = 1:numObservations
                inputVector = [observation(:, i); 1]; % Add bias term
                actual_output = double(inputVector' * obj.weights > 0);
                scores(i) = actual_output;
                expected_output = double(TFvalues(i));
                error = expected_output - actual_output;
                obj.weights = obj.weights + obj.learningRate * error * inputVector;
            end
        end

        function [detectLikelihood] = evaluateTimeSeries(obj, timeSeriesData)
            % EVALUATETIMESERIES - Evaluate the likelihood of a pattern at each time step
            %
            %   [detectLikelihood] = evaluateTimeSeries(obj, timeSeriesData)
            %
            %   Inputs:
            %     obj - The detector object.
            %     timeSeriesData - A 1-D time series vector.
            %
            %   Outputs:
            %     detectLikelihood - The likelihood of the pattern at each time step.
            %

            numSamples = length(timeSeriesData);
            detectLikelihood = zeros(1, numSamples);

            for i = obj.detectorSamples:numSamples
                inputVector = [timeSeriesData(i - obj.detectorSamples + 1:i)'; 1]; % Add bias term
                detectLikelihood(i) = double(inputVector' * obj.weights > 0);
            end
        end
    end
end