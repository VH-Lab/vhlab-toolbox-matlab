classdef (Abstract) base
    % vlt.signal.timeseriesDetectorML.base - Abstract base class for time series machine learning detectors
    %

    properties
        detectorSamples (1,1) uint64 {mustBePositive} = 1; % The number of samples to be considered for the detection
    end

    methods (Abstract)
        % TRAIN - Train the detector
        %
        %   [obj, scores, errorEachIteration] = train(obj, observation, TFvalues, doReset, numIterations, falsePositivePenalty)
        %
        %   Trains the detector with training data.
        %
        %   Inputs:
        %     obj - The detector object.
        %     observation - A matrix of training data (one column per observation).
        %     TFvalues - A boolean vector indicating if the observation is a match.
        %     doReset - (Optional) If true, re-initializes the learned parameters. Default false.
        %     numIterations - (Optional) The number of training iterations. Default 100.
        %     falsePositivePenalty - (Optional) The penalty to apply to false positive errors. Default 1.
        %
        %   Outputs:
        %     obj - The trained detector object.
        %     scores - The scores from the training.
        %     errorEachIteration - The mean squared error for each iteration.
        %
        [obj, scores, errorEachIteration] = train(obj, observation, TFvalues, doReset, numIterations, falsePositivePenalty)

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
        [detectLikelihood] = evaluateTimeSeries(obj, timeSeriesData)

        % INITIALIZE - Initialize the learning parameters
        %
        %   obj = initialize(obj)
        %
        %   Initializes or re-initializes the learning parameters of the detector.
        %
        obj = initialize(obj)
    end

    methods (Static)
        function [observations, newTimeStamps] = timeStamps2Observations(timeSeriesTimeStamps, timeSeriesData, detectedTimeStamps, detectorSamples, options)
            % TIMESTAMPS2OBSERVATIONS - convert timestamps to observations for training/evaluation
            %
            arguments
                timeSeriesTimeStamps (:,1) double
                timeSeriesData (:,1) double
                detectedTimeStamps (1,:) double
                detectorSamples (1,1) uint64
                options.optimizeForPeak (1,1) logical = false
                options.peakFindingSamples (1,1) uint64 = 10
                options.useNegativeForPeak (1,1) logical = false
            end

            newTimeStamps = detectedTimeStamps;
            numTimeStamps = numel(newTimeStamps);
            observations = zeros(detectorSamples, numTimeStamps);

            halfWindow = floor(double(options.peakFindingSamples)/2);

            for i = 1:numTimeStamps
                [~, initial_idx] = min(abs(timeSeriesTimeStamps - newTimeStamps(i)));

                final_idx = initial_idx;

                if options.optimizeForPeak
                    searchStart = max(1, initial_idx - halfWindow);
                    searchEnd = min(length(timeSeriesData), initial_idx + halfWindow);

                    if options.useNegativeForPeak
                        [~, peakOffset] = min(timeSeriesData(searchStart:searchEnd));
                    else
                        [~, peakOffset] = max(timeSeriesData(searchStart:searchEnd));
                    end
                    final_idx = searchStart + peakOffset - 1;
                    newTimeStamps(i) = timeSeriesTimeStamps(final_idx);
                end

                obsStart = final_idx - floor(double(detectorSamples)/2);
                obsEnd = obsStart + double(detectorSamples) - 1;

                if obsStart >= 1 && obsEnd <= length(timeSeriesData)
                    observations(:, i) = timeSeriesData(obsStart:obsEnd);
                else
                    observations(:, i) = NaN;
                end
            end
            validCols = ~any(isnan(observations), 1);
            observations = observations(:, validCols);
            newTimeStamps = newTimeStamps(validCols);
        end

        function [observations, TFvalues] = markObservations(timeSeriesTimeStamps, timeSeriesData, options)
            % MARKOBSERVATIONS - Interactively mark positive and negative observations in a time series
            %
            arguments
                timeSeriesTimeStamps (:,1) double
                timeSeriesData (:,1) double
                options.detectorSamples (1,1) uint64 = 25
                options.positiveTimeStamps (1,:) double = []
                options.negativeTimeStamps (1,:) double = []
                options.optimizeForPeak (1,1) logical = false
                options.peakFindingSamples (1,1) uint64 = 10
                options.useNegativeForPeak (1,1) logical = false
            end

            h_fig = figure('Name', 'Mark Observations', 'NumberTitle', 'off', 'Position', [100, 100, 1000, 800]);
            h_ax = subplot(3,1,[1 2]);
            plot(h_ax, timeSeriesTimeStamps, timeSeriesData, 'k-');
            hold on;

            marker_data = struct('timestamp', {}, 'value', {}, 'type', {}, 'handle', {});

            for i = 1:numel(options.positiveTimeStamps)
                addMarker(options.positiveTimeStamps(i), true);
            end
            for i = 1:numel(options.negativeTimeStamps)
                addMarker(options.negativeTimeStamps(i), false);
            end

            controls = [];
            controls(end+1) = uicontrol('Style', 'pushbutton', 'String', 'Zoom', 'Position', [20, 50, 100, 30], 'Callback', @(~,~) zoom(h_fig, 'on'));
            controls(end+1) = uicontrol('Style', 'pushbutton', 'String', 'Pan', 'Position', [130, 50, 100, 30], 'Callback', @(~,~) pan(h_fig, 'on'));
            controls(end+1) = uicontrol('Style', 'pushbutton', 'String', 'Mark Positive', 'Position', [20, 10, 100, 30], 'Callback', @(~,~) markPoints(true));
            controls(end+1) = uicontrol('Style', 'pushbutton', 'String', 'Mark Negative', 'Position', [130, 10, 100, 30], 'Callback', @(~,~) markPoints(false));
            controls(end+1) = uicontrol('Style', 'pushbutton', 'String', 'Delete Examples', 'Position', [240, 10, 100, 30], 'Callback', @(~,~) deletePoints());
            controls(end+1) = uicontrol('Style', 'pushbutton', 'String', 'Done', 'Position', [400, 30, 100, 30], 'Callback', @(~,~) uiresume(h_fig));

            uiwait(h_fig);

            pos_stamps = [marker_data([marker_data.type]).timestamp];
            neg_stamps = [marker_data(~[marker_data.type]).timestamp];

            [pos_obs, ~] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(timeSeriesTimeStamps, timeSeriesData, pos_stamps, options.detectorSamples, 'optimizeForPeak', options.optimizeForPeak, 'peakFindingSamples', options.peakFindingSamples, 'useNegativeForPeak', options.useNegativeForPeak);
            [neg_obs, ~] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(timeSeriesTimeStamps, timeSeriesData, neg_stamps, options.detectorSamples, 'optimizeForPeak', options.optimizeForPeak, 'peakFindingSamples', options.peakFindingSamples, 'useNegativeForPeak', options.useNegativeForPeak);

            observations = [pos_obs, neg_obs];
            TFvalues = [true(1, size(pos_obs, 2)), false(1, size(neg_obs, 2))];

            if ishandle(h_fig)
                close(h_fig);
            end

            function addMarker(timestamp, is_positive)
                [~,idx] = min(abs(timeSeriesTimeStamps - timestamp));
                data_val = timeSeriesData(idx);
                if is_positive
                    h = plot(h_ax, timeSeriesTimeStamps(idx), data_val, 'gs', 'MarkerFaceColor', 'g');
                else
                    h = plot(h_ax, timeSeriesTimeStamps(idx), data_val, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
                end
                new_entry = struct('timestamp', timeSeriesTimeStamps(idx), 'value', data_val, 'type', is_positive, 'handle', h);
                marker_data(end+1) = new_entry;
            end

            function markPoints(is_positive)
                set(controls, 'Enable', 'off');
                title(h_ax, 'Click points, press Enter when done.');
                [x, ~] = ginput;
                if isempty(x), title(h_ax, ''); set(controls, 'Enable', 'on'); return; end
                for k=1:numel(x)
                    addMarker(x(k), is_positive);
                end
                title(h_ax, '');
                set(controls, 'Enable', 'on');
            end

            function deletePoints()
                set(controls, 'Enable', 'off');
                title(h_ax, 'Click markers to delete, press Enter when done.');
                [x,y] = ginput;
                if isempty(x), title(h_ax, ''); set(controls, 'Enable', 'on'); return; end

                for k=1:numel(x)
                    if isempty(marker_data), continue; end

                    timestamps = [marker_data.timestamp];
                    datavals = [marker_data.value];

                    x_range = diff(xlim(h_ax));
                    y_range = diff(ylim(h_ax));

                    dist_sq = ((timestamps - x(k))/x_range).^2 + ((datavals - y(k))/y_range).^2;

                    [~, closest_idx] = min(dist_sq);

                    delete(marker_data(closest_idx).handle);
                    marker_data(closest_idx) = [];
                end
                title(h_ax, '');
                set(controls, 'Enable', 'on');
            end
        end
    end
end