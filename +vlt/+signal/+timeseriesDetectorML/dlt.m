classdef dlt
    % DLT - Deep Learning Toolbox-based time series detector
    %

    properties
        Layers
        DLToptions
        Net
        DetectorSamples (1,1) uint64 {mustBePositive} = 50;
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
                    'L2Regularization', 0.001);
            end
        end

        function obj = train(obj, observations, TFvalues, X_validation, Y_validation)
            % TRAIN - Train the network using the Deep Learning Toolbox
            %
            %   Reshapes the data and trains the network using trainNetwork.
            %

            % Reshape observations for imageInputLayer: [height, width, channels, numObservations]
            % Our observations are [detectorSamples, numObservations]
            X_train = reshape(observations, [obj.DetectorSamples, 1, 1, size(observations, 2)]);

            % Convert boolean TFvalues to a categorical array
            Y_train = categorical(TFvalues);

            current_options = obj.DLToptions;
            if nargin > 3 && ~isempty(X_validation) && ~isempty(Y_validation)
                X_val_reshaped = reshape(X_validation, [obj.DetectorSamples, 1, 1, size(X_validation,2)]);
                Y_val_cat = categorical(Y_validation);
                current_options.ValidationData = {X_val_reshaped, Y_val_cat};
            end

            obj.Net = trainNetwork(X_train, Y_train, obj.Layers, current_options);
        end

        function [detectLikelihood] = evaluateTimeSeries(obj, timeSeriesData)
            % EVALUATETIMESERIES - Evaluate the network on a time series
            %
            %   Slides the detection window across the time series and uses
            %   the trained network's 'predict' function.
            %

            if isempty(obj.Net)
                error('The network has not been trained. Call the train() method first.');
            end

            detectLikelihood = zeros(size(timeSeriesData));

            for i = 1:numel(timeSeriesData) - obj.DetectorSamples + 1
                obs = timeSeriesData(i:i+obj.DetectorSamples-1);

                % Reshape for prediction
                obs_reshaped = reshape(obs, [obj.DetectorSamples, 1, 1]);

                % Predict returns scores for each class
                scores = predict(obj.Net, obs_reshaped);

                center_index = i + floor(obj.DetectorSamples/2);
                % The second column corresponds to the 'true' or 'positive' class
                detectLikelihood(center_index) = scores(2);
            end
        end
    end
end