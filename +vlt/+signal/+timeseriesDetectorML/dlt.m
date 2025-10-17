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
                    'Plots', 'none', ...
                    'L2Regularization', 0.001);
            end
        end

        function obj = train(obj, observations, TFvalues, X_validation, Y_validation)
            % TRAIN - Train the network using the Deep Learning Toolbox
            %
            %   Reshapes the data and trains the network using trainNetwork.
            %

            X_train = reshape(observations, [obj.DetectorSamples, 1, 1, size(observations, 2)]);
            Y_train = categorical(TFvalues);

            current_options = obj.DLToptions;
            if nargin > 3 && ~isempty(X_validation) && ~isempty(Y_validation)
                X_val_reshaped = reshape(X_validation, [obj.DetectorSamples, 1, 1, size(X_validation,2)]);
                Y_val_cat = categorical(Y_validation);
                current_options.ValidationData = {X_val_reshaped, Y_val_cat};
            end

            obj.Net = trainNetwork(X_train, Y_train, obj.Layers, current_options);
        end

        function [detectLikelihood] = evaluateTimeSeries(obj, timeSeriesTimeStamps, timeSeriesData, options)
            % EVALUATETIMESERIES - Evaluate the network on a time series
            %
            %   Slides the detection window across the time series and uses
            %   the trained network's 'predict' function in batches for efficiency.
            %
            arguments
                obj
                timeSeriesTimeStamps (:,1) double
                timeSeriesData (:,1) double
                options.chunkTime (1,1) double {mustBePositive} = 100
            end

            if isempty(obj.Net)
                error('The network has not been trained. Call the train() method first.');
            end

            dt = timeSeriesTimeStamps(2) - timeSeriesTimeStamps(1);
            chunkSamples = round(options.chunkTime / dt);

            detectLikelihood = zeros(size(timeSeriesData));

            for i = 1:chunkSamples:numel(timeSeriesData)
                chunk_end = min(i + chunkSamples - 1, numel(timeSeriesData));
                chunk_data = timeSeriesData(i:chunk_end);

                if numel(chunk_data) < obj.DetectorSamples
                    continue; % Skip last partial chunk if it's too small
                end

                windows = im2col(chunk_data(:)', [obj.DetectorSamples, 1], 'sliding');
                windows_reshaped = reshape(windows, [obj.DetectorSamples, 1, 1, size(windows, 2)]);

                scores = predict(obj.Net, windows_reshaped);
                likelihoods = scores(:,2)';

                % Calculate the indices for placing the results
                start_idx = i + floor(obj.DetectorSamples/2);
                end_idx = start_idx + numel(likelihoods) - 1;

                detectLikelihood(start_idx:end_idx) = likelihoods;
            end
        end
    end
end