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
        function [observations, TFvalues, newTimeStamps, exampleLabels] = timeStamps2Observations(timeSeriesTimeStamps, timeSeriesData, detectedTimeStamps, detectorSamples, options)
            % TIMESTAMPS2OBSERVATIONS - Convert timestamps to observations with data augmentation
            %
            arguments
                timeSeriesTimeStamps (:,1) double, timeSeriesData (:,1) double, detectedTimeStamps (1,:) double
                detectorSamples (1,1) uint64, options.examplesArePositives (1,1) logical = true
                options.jitterPositive (1,1) logical = true, options.jitterRange (1,1) double {mustBePositive} = 0.002
                options.makeShoulderNegatives (1,1) logical = true, options.shoulderRangeStart (1,1) double {mustBePositive} = 0.010
                options.shoulderRangeStop (1,1) double {mustBePositive} = 0.050, options.optimizeForPeak (1,1) logical = false
                options.peakFindingSamples (1,1) uint64 = 10, options.useNegativeForPeak (1,1) logical = false
            end

            dt = timeSeriesTimeStamps(2) - timeSeriesTimeStamps(1);
            final_stamps = [];
            final_tf = [];
            final_labels = {};

            if options.examplesArePositives
                % Step 1: Start with original positive events and correct their peaks if requested
                corrected_stamps = detectedTimeStamps;
                if options.optimizeForPeak
                    for i = 1:numel(corrected_stamps)
                        [~, idx] = min(abs(timeSeriesTimeStamps - corrected_stamps(i)));
                        searchStart = max(1, idx - floor(double(options.peakFindingSamples)/2));
                        searchEnd = min(length(timeSeriesData), idx + floor(double(options.peakFindingSamples)/2));
                        if options.useNegativeForPeak, [~, peakOffset] = min(timeSeriesData(searchStart:searchEnd));
                        else, [~, peakOffset] = max(timeSeriesData(searchStart:searchEnd));
                        end
                        corrected_stamps(i) = timeSeriesTimeStamps(searchStart + peakOffset - 1);
                    end
                end
                final_stamps = [final_stamps, corrected_stamps];
                final_tf = [final_tf, true(1, numel(corrected_stamps))];
                final_labels = [final_labels, repmat({"originalPositive"}, 1, numel(corrected_stamps))];

                % Step 2: Add jitter relative to the corrected stamps
                if options.jitterPositive
                    jitter_shifts = -options.jitterRange:dt:options.jitterRange;
                    jitter_shifts(jitter_shifts==0) = [];
                    jittered_stamps = repmat(corrected_stamps(:), 1, numel(jitter_shifts)) + repmat(jitter_shifts, numel(corrected_stamps), 1);
                    final_stamps = [final_stamps, jittered_stamps(:)'];
                    final_tf = [final_tf, true(1, numel(jittered_stamps))];
                    final_labels = [final_labels, repmat({"jitterPositive"}, 1, numel(jittered_stamps))];
                end

                % Step 3: Add shoulder negatives relative to the corrected stamps
                if options.makeShoulderNegatives
                    shoulder_shifts = [-options.shoulderRangeStop:dt:-options.shoulderRangeStart, options.shoulderRangeStart:dt:options.shoulderRangeStop];
                    shoulder_stamps = repmat(corrected_stamps(:), 1, numel(shoulder_shifts)) + repmat(shoulder_shifts, numel(corrected_stamps), 1);
                    final_stamps = [final_stamps, shoulder_stamps(:)'];
                    final_tf = [final_tf, false(1, numel(shoulder_stamps))];
                    final_labels = [final_labels, repmat({"shoulderNegative"}, 1, numel(shoulder_stamps))];
                end
            else % examples are negative
                final_stamps = [final_stamps, detectedTimeStamps];
                final_tf = [final_tf, false(1, numel(detectedTimeStamps))];
                final_labels = [final_labels, repmat({"originalNegative"}, 1, numel(detectedTimeStamps))];
            end

            % Create observations
            observations = zeros(detectorSamples, numel(final_stamps));
            for i = 1:numel(final_stamps)
                [~, idx] = min(abs(timeSeriesTimeStamps - final_stamps(i)));
                obsStart = idx - floor(double(detectorSamples)/2);
                obsEnd = obsStart + double(detectorSamples) - 1;
                if obsStart >= 1 && obsEnd <= length(timeSeriesData)
                    observations(:, i) = timeSeriesData(obsStart:obsEnd);
                else
                    observations(:, i) = NaN;
                end
            end

            validCols = ~any(isnan(observations), 1);
            observations = observations(:, validCols);
            newTimeStamps = final_stamps(validCols);
            TFvalues = final_tf(validCols);
            exampleLabels = final_labels(validCols);
        end

        function [observations, TFvalues, newTimeStamps, exampleLabels] = markObservations(timeSeriesTimeStamps, timeSeriesData, options)
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

            [pos_obs, pos_tf, pos_new_stamps, pos_labels] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(timeSeriesTimeStamps, timeSeriesData, pos_stamps, options.detectorSamples, 'examplesArePositives', true, 'optimizeForPeak', options.optimizeForPeak, 'peakFindingSamples', options.peakFindingSamples, 'useNegativeForPeak', options.useNegativeForPeak, 'jitterPositive', true, 'makeShoulderNegatives', true);
            [neg_obs, neg_tf, neg_new_stamps, neg_labels] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(timeSeriesTimeStamps, timeSeriesData, neg_stamps, options.detectorSamples, 'examplesArePositives', false, 'jitterPositive', false, 'makeShoulderNegatives', false);

            observations = [pos_obs, neg_obs];
            TFvalues = [pos_tf, neg_tf];
            newTimeStamps = [pos_new_stamps, neg_new_stamps];
            exampleLabels = [pos_labels, neg_labels];

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