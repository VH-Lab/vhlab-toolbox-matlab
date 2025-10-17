classdef dlt
    % DLT - Deep Learning Toolbox-based time series detector
    %

    properties
        Layers
        DLToptions
        Net
        DetectorSamples (1,1) double {mustBeInteger, mustBePositive} = 50;
    end

    methods
        function obj = dlt(detectorSamples, layers, options)
            % DLT - Create a new Deep Learning Toolbox detector
            %
            %   OBJ = vlt.signal.timeseriesDetectorML.dlt(DETECTORSAMPLES, LAYERS, OPTIONS)
            %
            %   Creates a new detector using a user-provided network architecture
            %   (LAYERS) and training options (OPTIONS) from the Deep Learning Toolbox.
            %   If LAYERS or OPTIONS are not provided, it uses default values suitable
            %   for 1D time series classification.
            %

            if nargin > 0
                obj.DetectorSamples = detectorSamples;
            end

            if nargin > 1 && ~isempty(layers)
                obj.Layers = layers;
            else
                obj.Layers = [
                    imageInputLayer([obj.DetectorSamples 1 1], 'Normalization', 'none')
                    convolution2dLayer([5 1], 8, 'Padding', 'same')
                    reluLayer
                    maxPooling2dLayer([2 1], 'Stride', [2 1])
                    convolution2dLayer([3 1], 16, 'Padding', 'same')
                    reluLayer
                    fullyConnectedLayer(2)
                    softmaxLayer
                    classificationLayer
                ];
            end

            if nargin > 2 && ~isempty(options)
                obj.DLToptions = options;
            else
                obj.DLToptions = trainingOptions('adam', ...
                    'InitialLearnRate', 0.001, ...
                    'MaxEpochs', 10, ...
                    'MiniBatchSize', 128, ...
                    'Shuffle', 'every-epoch', ...
                    'Verbose', false, ...
                    'Plots', 'none', ...
                    'L2Regularization', 0.001);
            end
        end

        function obj = train(obj, observations, TFvalues)
            % TRAIN - Train the network using the Deep Learning Toolbox
            %
            %   Reshapes the data and trains the network using trainNetwork.
            %

            X_train = reshape(observations, [obj.DetectorSamples, 1, 1, size(observations, 2)]);
            Y_train = categorical(TFvalues);

            % The DLToptions property should be set with validation data before calling train
            current_options = obj.DLToptions;

            obj.Net = trainNetwork(X_train, Y_train, obj.Layers, current_options);
        end

        function [detectLikelihood] = evaluateTimeSeries(obj, timeSeriesData)
            % EVALUATETIMESERIES - Evaluate the network on a time series
            %
            %   Uses a batched approach for efficient prediction.
            %

            if isempty(obj.Net)
                error('The network has not been trained. Call the train() method first.');
            end

            V = timeSeriesData(:);
            L = length(V);
            windowSize = obj.DetectorSamples;
            numWindows = L - windowSize + 1;

            % Create sliding windows
            batchData2D = zeros(windowSize, numWindows);
            for i = 1:numWindows
                batchData2D(:, i) = V(i : i + windowSize - 1);
            end

            % Reshape to 4D for the image layer: [Height, Width, Channels, Batch]
            batchData4D = reshape(batchData2D, [windowSize, 1, 1, numWindows]);

            % Run prediction on the entire batch
            predictions = predict(obj.Net, batchData4D);

            % The predict function returns scores for each class. The second column
            % corresponds to the 'true' or 'positive' class.
            likelihoods = predictions(:,2)';

            % Pad the output to match the original time series length
            padding_start = floor(windowSize/2);
            padding_end = L - numel(likelihoods) - padding_start;
            detectLikelihood = padarray(likelihoods, [0, padding_start], 0, 'pre');
            detectLikelihood = padarray(detectLikelihood, [0, padding_end], 0, 'post')';
        end
    end
end