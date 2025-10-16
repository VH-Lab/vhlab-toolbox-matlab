classdef NLayer < vlt.signal.timeseriesDetectorML.base
    % NLAYER - An N-layer neural network for time series detection

    properties
        learningRate (1,1) double {mustBePositive} = 0.1;
        M (1,:) {mustBeInteger, mustBePositive}
        weights cell
    end

    methods
        function obj = NLayer(detectorSamples, M, learningRate)
            if nargin > 0
                obj.detectorSamples = detectorSamples;
                obj.M = M;
                if nargin > 2
                    obj.learningRate = learningRate;
                end

                if obj.M(end) ~= 1
                    error('NLayer:LastLayerError', 'The last layer must have exactly one output node (M(end) must be 1).');
                end

                obj = obj.initialize();
            end
        end

        function obj = initialize(obj)
            num_layers = numel(obj.M);
            obj.weights = cell(1, num_layers);
            layer_inputs = obj.detectorSamples;

            for i = 1:num_layers
                obj.weights{i} = (rand(obj.M(i), layer_inputs + 1) - 0.5) / 10;
                layer_inputs = obj.M(i);
            end
        end

        function [obj, scores, errorEachIteration] = train(obj, observation, TFvalues, doReset, numIterations, falsePositivePenalty)
            if nargin < 4, doReset = false; end
            if nargin < 5, numIterations = 100; end
            if nargin < 6, falsePositivePenalty = 1; end

            if doReset
                obj = obj.initialize();
            end

            num_layers = numel(obj.M);
            y = double(TFvalues(:)');
            errorEachIteration = zeros(1, numIterations);

            for iter = 1:numIterations
                % Vectorized forward and backward pass

                % Forward pass
                activations = cell(1, num_layers + 1);
                activations{1} = observation;

                for L = 1:num_layers
                    input_with_bias = [ones(1, size(activations{L}, 2)); activations{L}];
                    z = obj.weights{L} * input_with_bias;
                    activations{L+1} = 1 ./ (1 + exp(-z)); % Sigmoid activation
                end

                % Error calculation
                predictions = activations{end};
                errors = y - predictions;

                fp_indices = (errors < 0);
                errors(fp_indices) = errors(fp_indices) * falsePositivePenalty;

                % Backward pass (backpropagation)
                deltas = cell(1, num_layers);

                g_prime_output = predictions .* (1 - predictions);
                deltas{num_layers} = errors .* g_prime_output;

                for L = num_layers-1:-1:1
                    g_prime = activations{L+1} .* (1 - activations{L+1});
                    deltas{L} = (obj.weights{L+1}(:, 2:end)' * deltas{L+1}) .* g_prime;
                end

                % Update weights
                for L = 1:num_layers
                    input_with_bias = [ones(1, size(activations{L}, 2)); activations{L}];
                    obj.weights{L} = obj.weights{L} + obj.learningRate * (deltas{L} * input_with_bias');
                end

                errorEachIteration(iter) = mean(errors.^2);
            end

            % Final scores
            final_activations = cell(1, num_layers+1);
            final_activations{1} = observation;
            for L = 1:num_layers
                input_with_bias = [ones(1, size(final_activations{L}, 2)); final_activations{L}];
                z = obj.weights{L} * input_with_bias;
                final_activations{L+1} = 1 ./ (1 + exp(-z));
            end
            scores = final_activations{end};
        end

        function [detectLikelihood] = evaluateTimeSeries(obj, timeSeriesData)
            num_layers = numel(obj.M);
            detectLikelihood = zeros(size(timeSeriesData));

            for i = 1:numel(timeSeriesData) - obj.detectorSamples + 1
                obs = timeSeriesData(i:i+obj.detectorSamples-1);

                activation = obs(:);
                for L = 1:num_layers
                    input_with_bias = [1; activation];
                    z = obj.weights{L} * input_with_bias;
                    activation = 1 ./ (1 + exp(-z)); % Sigmoid
                end

                center_index = i + floor(obj.detectorSamples/2);
                detectLikelihood(center_index) = activation;
            end
        end
    end
end