classdef base
    % vlt.signal.timeseriesDetectorML.base -  base class for time series machine learning detectors
    %
    % This class provides a framework for building machine learning-based detectors for time series data.
    % It defines the interface for training, evaluation, and initialization, and provides static helper
    % methods for data preparation and event detection.
    %

    properties
        detectorSamples (1,1) double {mustBeInteger, mustBePositive} = 1; % The number of samples to be considered for the detection
    end

    methods
        [obj, scores, errorEachIteration] = train(obj, observation, TFvalues)
        % TRAIN - Train the detector
        %
        %   [OBJ, SCORES, ERROR] = TRAIN(OBJ, OBSERVATIONS, TFVALUES)
        %
        %   Trains the detector using the provided observations and truth values.
        %
        %   Inputs:
        %   OBJ - The detector object.
        %   OBSERVATIONS - Matrix of training examples (samples x examples).
        %   TFVALUES - Boolean vector of truth values (true for positive examples, false for negative).
        %
        %   Outputs:
        %   OBJ - The trained detector object.
        %   SCORES - Training scores.
        %   ERROR - Training error history.
        %

        [detectLikelihood] = evaluateTimeSeries(obj, timeSeriesData)
        % EVALUATETIMESERIES - Evaluate the detector on a time series
        %
        %   [LIKELIHOOD] = EVALUATETIMESERIES(OBJ, TIMESERIESDATA)
        %
        %   Evaluates the detector on the given time series data.
        %
        %   Inputs:
        %   OBJ - The detector object.
        %   TIMESERIESDATA - The time series data vector.
        %
        %   Outputs:
        %   LIKELIHOOD - Vector of likelihood scores (0 to 1) for each sample.
        %

    end

    methods
        function [detectedEvents, likelihood] = detectEvents(obj, timeSeriesData, options)
            % DETECTEVENTS - Detect events in a time series
            %
            %   [DETECTEDEVENTS, LIKELIHOOD] = DETECTEVENTS(OBJ, TIMESERIESDATA, OPTIONS)
            %
            %   Detects events by finding threshold crossings in the likelihood signal
            %   and identifying the peak likelihood within each suprathreshold interval.
            %   The peak is defined as the maximum value in the interval. If multiple
            %   points share the maximum value, the center point (or left of center)
            %   is selected.
            %
            %   Inputs:
            %   OBJ - The detector object.
            %   TIMESERIESDATA - The time series data vector.
            %   OPTIONS - Name-value arguments:
            %       'threshold' (double, default 0.5) - Detection threshold.
            %       'timestamps' (double, default []) - Optional time vector. If provided,
            %                                           returns event times instead of indices.
            %
            %   Outputs:
            %   DETECTEDEVENTS - Vector of sample indices (or times) where events were detected.
            %   LIKELIHOOD - The likelihood signal computed by the detector.
            %
            arguments
                obj
                timeSeriesData (:,1) double
                options.threshold (1,1) double = 0.5
                options.timestamps (:,1) double = []
            end

            likelihood = obj.evaluateTimeSeries(timeSeriesData);

            up_crossings = vlt.signal.threshold_crossings(likelihood, options.threshold);
            down_crossings = 1 + find(likelihood(1:end-1) >= options.threshold & likelihood(2:end) < options.threshold);

            % Filter crossings to ensure valid epochs
            if ~isempty(down_crossings) && ~isempty(up_crossings)
                if down_crossings(1) < up_crossings(1)
                    down_crossings(1) = [];
                end
            end

            % Match pairs
            n_events = min(numel(up_crossings), numel(down_crossings));
            up_crossings = up_crossings(1:n_events);
            down_crossings = down_crossings(1:n_events);

            detectedEvents = zeros(1, n_events);

            for i = 1:n_events
                idx_start = up_crossings(i);
                idx_end = down_crossings(i) - 1;

                segment = likelihood(idx_start:idx_end);
                max_val = max(segment);
                max_indices = find(segment == max_val);

                % Pick center
                center_idx = ceil(numel(max_indices) / 2);
                peak_offset = max_indices(center_idx);

                detectedEvents(i) = idx_start + peak_offset - 1;
            end

            if ~isempty(options.timestamps)
                detectedEvents = options.timestamps(detectedEvents);
            end
        end
    end

    methods (Static)
        function [observations, TFvalues, newTimeStamps] = timeStamps2Observations(timeSeriesTimeStamps, timeSeriesData, detectedTimeStamps, detectorSamples, examplesArePositives, options)
            % TIMESTAMPS2OBSERVATIONS - Extract observations from time series based on timestamps
            %
            %   [OBSERVATIONS, TFVALUES, NEWTIMESTAMPS] = TIMESTAMPS2OBSERVATIONS(TIMESERIESTIMESTAMPS, TIMESERIESDATA, DETECTEDTIMESTAMPS, DETECTORSAMPLES, EXAMPLESAREPOSITIVES, OPTIONS)
            %
            %   Extracts windows of data centered around specific timestamps. Can optionally optimize the
            %   timestamps to align with local peaks in the data.
            %
            %   Inputs:
            %   TIMESERIESTIMESTAMPS - Time vector of the time series.
            %   TIMESERIESDATA - Data vector of the time series.
            %   DETECTEDTIMESTAMPS - Vector of timestamps around which to extract data.
            %   DETECTORSAMPLES - Size of the window to extract (in samples).
            %   EXAMPLESAREPOSITIVES - Boolean, true if these are positive examples (sets TFvalues).
            %   OPTIONS - Name-value arguments:
            %       'optimizeForPeak' (logical, default false) - Whether to align to local peaks.
            %       'peakFindingSamples' (double, default 10) - Window size for peak search (+/- samples).
            %       'useNegativeForPeak' (logical, default false) - If true, searches for local minimum instead of maximum.
            %
            %   Outputs:
            %   OBSERVATIONS - Extracted data matrix (detectorSamples x numExamples).
            %   TFVALUES - Boolean vector indicating class (all true or all false).
            %   NEWTIMESTAMPS - The actual timestamps used for extraction (refined if optimized).
            %
            arguments
                timeSeriesTimeStamps (:,1) double
                timeSeriesData (:,1) double
                detectedTimeStamps (1,:) double
                detectorSamples (1,1) double
                examplesArePositives (1,1) logical = true
                options.optimizeForPeak (1,1) logical = false
                options.peakFindingSamples (1,1) double = 10
                options.useNegativeForPeak (1,1) logical = false
            end

            newTimeStamps = detectedTimeStamps;
            if options.optimizeForPeak && ~isempty(newTimeStamps)
                for i=1:numel(newTimeStamps)
                    [~,idx] = min(abs(timeSeriesTimeStamps - newTimeStamps(i)));
                    search_indices = max(1, idx - options.peakFindingSamples) : min(numel(timeSeriesData), idx + options.peakFindingSamples);
                    if options.useNegativeForPeak
                        [~, max_idx] = min(timeSeriesData(search_indices));
                    else
                        [~, max_idx] = max(timeSeriesData(search_indices));
                    end
                    newTimeStamps(i) = timeSeriesTimeStamps(search_indices(max_idx));
                end
            end

            observations = zeros(detectorSamples, numel(newTimeStamps));
            for i = 1:numel(newTimeStamps)
                [~, idx] = min(abs(timeSeriesTimeStamps - newTimeStamps(i)));
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
            newTimeStamps = newTimeStamps(validCols);

            if examplesArePositives
                TFvalues = true(1, size(observations, 2));
            else
                TFvalues = false(1, size(observations, 2));
            end
        end

        function [observations, TFvalues, newTimeStamps] = timeStamps2NegativeObservations(timeSeriesTimeStamps, timeSeriesData, detectedTimeStamps, detectorSamples, options)
            % TIMESTAMPS2NEGATIVEOBSERVATIONS - Generate negative observations by random sampling
            %
            %   [OBSERVATIONS, TFVALUES, NEWTIMESTAMPS] = TIMESTAMPS2NEGATIVEOBSERVATIONS(TIMESERIESTIMESTAMPS, TIMESERIESDATA, DETECTEDTIMESTAMPS, DETECTORSAMPLES, OPTIONS)
            %
            %   Generates negative examples by randomly sampling the time series at locations
            %   that are sufficiently far from known positive events (DETECTEDTIMESTAMPS).
            %
            %   Inputs:
            %   TIMESERIESTIMESTAMPS - Time vector of the time series.
            %   TIMESERIESDATA - Data vector of the time series.
            %   DETECTEDTIMESTAMPS - Vector of known positive event timestamps.
            %   DETECTORSAMPLES - Size of the window to extract (in samples).
            %   OPTIONS - Name-value arguments:
            %       'minimumSpacingFromPositive' (double, default 0.050) - Minimum time distance from any positive event.
            %       'negativeDataSetSize' (double, default 2 * numel(detectedTimeStamps)) - Number of negative examples to generate.
            %       Also accepts options for timeStamps2Observations (though optimizeForPeak is usually false for random noise).
            %
            %   Outputs:
            %   OBSERVATIONS - Extracted data matrix (detectorSamples x numExamples).
            %   TFVALUES - Boolean vector (all false).
            %   NEWTIMESTAMPS - The random timestamps selected.
            %
            arguments
                timeSeriesTimeStamps (:,1) double
                timeSeriesData (:,1) double
                detectedTimeStamps (1,:) double
                detectorSamples (1,1) double
                options.optimizeForPeak (1,1) logical = false
                options.peakFindingSamples (1,1) double = 10
                options.useNegativeForPeak (1,1) logical = false
                options.minimumSpacingFromPositive (1,1) double = 0.050
                options.negativeDataSetSize double = []
            end

            if isempty(options.negativeDataSetSize)
                options.negativeDataSetSize = 2 * numel(detectedTimeStamps);
            end

            newTimeStamps = [];
            N = numel(timeSeriesTimeStamps);

            half_window = floor(double(detectorSamples)/2);
            min_idx = 1 + half_window;
            max_idx = N - double(detectorSamples) + 1 + half_window;

            if max_idx < min_idx
                 error('Time series data is shorter than detectorSamples.');
            end

            % If we can't find valid spots after many tries, we should stop to avoid infinite loop
            maxAttempts = options.negativeDataSetSize * 100;
            attempts = 0;

            while numel(newTimeStamps) < options.negativeDataSetSize && attempts < maxAttempts
                attempts = attempts + 1;
                rand_idx = randi([min_idx, max_idx]);
                candidate_time = timeSeriesTimeStamps(rand_idx);

                % Check distance from all positive timestamps
                if isempty(detectedTimeStamps) || ~any(abs(candidate_time - detectedTimeStamps) < options.minimumSpacingFromPositive)
                    newTimeStamps(end+1) = candidate_time;
                end
            end

            if attempts >= maxAttempts
                warning('Could not generate the requested number of negative examples with the given constraints.');
            end

            % Pass the generated timestamps to timeStamps2Observations to do the extraction
            % We pass the inherited options (optimizeForPeak, etc.) as name-value pairs
            % Note: newTimeStamps is passed as a row vector to match the (1,:) requirement of timeStamps2Observations

            [observations, TFvalues, newTimeStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                timeSeriesTimeStamps, timeSeriesData, newTimeStamps, detectorSamples, false, ...
                'optimizeForPeak', options.optimizeForPeak, ...
                'peakFindingSamples', options.peakFindingSamples, ...
                'useNegativeForPeak', options.useNegativeForPeak);
        end

        function [observations, TFvalues, newTimeStamps] = negativeShoulderEvents(timeSeriesTimeStamps, timeSeriesData, positiveEventTimeStamps, detectorSamples, options)
            % NEGATIVESHOULDEREVENTS - Generate negative observations from shoulders of positive events
            %
            %   [OBSERVATIONS, TFVALUES, NEWTIMESTAMPS] = NEGATIVESHOULDEREVENTS(TIMESERIESTIMESTAMPS, TIMESERIESDATA, POSITIVEEVENTTIMESTAMPS, DETECTORSAMPLES, OPTIONS)
            %
            %   Generates negative examples by sampling the "shoulders" (near misses) of known positive events.
            %   It samples every time point within the specified shoulder windows.
            %
            %   Inputs:
            %   TIMESERIESTIMESTAMPS - Time vector of the time series.
            %   TIMESERIESDATA - Data vector of the time series.
            %   POSITIVEEVENTTIMESTAMPS - Vector of known positive event timestamps.
            %   DETECTORSAMPLES - Size of the window to extract (in samples).
            %   OPTIONS - Name-value arguments:
            %       'leftShoulderOnset' (double, default -0.010) - Start time of left shoulder relative to event.
            %       'leftShoulderOffset' (double, default -0.005) - End time of left shoulder relative to event.
            %       'rightShoulderOnset' (double, default 0.005) - Start time of right shoulder relative to event.
            %       'rightShoulderOffset' (double, default 0.010) - End time of right shoulder relative to event.
            %       'refractoryPeriod' (double, default 0.002) - Minimum distance from any positive event.
            %
            %   Outputs:
            %   OBSERVATIONS - Extracted data matrix.
            %   TFVALUES - Boolean vector (all false).
            %   NEWTIMESTAMPS - The timestamps selected.
            %
            arguments
                timeSeriesTimeStamps (:,1) double
                timeSeriesData (:,1) double
                positiveEventTimeStamps (1,:) double
                detectorSamples (1,1) double
                options.leftShoulderOnset (1,1) double = -0.010
                options.leftShoulderOffset (1,1) double = -0.005
                options.rightShoulderOnset (1,1) double = 0.005
                options.rightShoulderOffset (1,1) double = 0.010
                options.refractoryPeriod (1,1) double = 0.002
            end

            dt = nanmedian(diff(timeSeriesTimeStamps));

            % Define time offsets for shoulders
            left_onset_idx = round(options.leftShoulderOnset / dt);
            left_offset_idx = round(options.leftShoulderOffset / dt);

            right_onset_idx = round(options.rightShoulderOnset / dt);
            right_offset_idx = round(options.rightShoulderOffset / dt);

            % Generate relative offsets (in time)
            left_offsets = (left_onset_idx : left_offset_idx) * dt;
            right_offsets = (right_onset_idx : right_offset_idx) * dt;

            all_offsets = [left_offsets, right_offsets];

            % Generate candidates
            [P, O] = meshgrid(positiveEventTimeStamps, all_offsets);
            candidateTimeStamps = P(:)' + O(:)';

            % Filter based on refractory period
            valid_mask = true(size(candidateTimeStamps));

            if ~isempty(positiveEventTimeStamps) && ~isempty(candidateTimeStamps)
                 for i = 1:numel(positiveEventTimeStamps)
                     pos_t = positiveEventTimeStamps(i);
                     bad_indices = abs(candidateTimeStamps - pos_t) <= options.refractoryPeriod;
                     valid_mask(bad_indices) = false;
                 end
            end

            newTimeStamps = candidateTimeStamps(valid_mask);

            [observations, TFvalues, newTimeStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                timeSeriesTimeStamps, timeSeriesData, newTimeStamps, detectorSamples, false, ...
                'optimizeForPeak', false);
        end

        function [eventTimes, filtered_signal] = detectIndividualEvents(timeSeriesTimeStamps, detectorOutput, options)
            % DETECTINDIVIDUALEVENTS - Detect discrete events from detector output likelihood
            %
            %   [EVENTTIMES, FILTERED_SIGNAL] = DETECTINDIVIDUALEVENTS(TIMESERIESTIMESTAMPS, DETECTOROUTPUT, OPTIONS)
            %
            %   Smooths the detector output and finds peaks above a threshold to identify event times.
            %   Applies a refractory period to merge close detections.
            %
            %   Inputs:
            %   TIMESERIESTIMESTAMPS - Time vector corresponding to the detector output.
            %   DETECTOROUTPUT - Likelihood signal from the detector.
            %   OPTIONS - Name-value arguments:
            %       'useGaussianBlur' (logical, default true) - Whether to smooth the output.
            %       'gaussianSigmaTime' (double, default 0.010) - Sigma for Gaussian smoothing (in time units).
            %       'refractoryPeriod' (double, default 0.010) - Minimum time between events.
            %       'threshold' (double, default 0.9) - Detection threshold.
            %
            %   Outputs:
            %   EVENTTIMES - Vector of detected event timestamps.
            %   FILTERED_SIGNAL - The smoothed detector output signal.
            %
            arguments
                timeSeriesTimeStamps (:,1) double
                detectorOutput (1,:) double
                options.useGaussianBlur (1,1) logical = true
                options.gaussianSigmaTime (1,1) double {mustBePositive} = 0.010
                options.refractoryPeriod (1,1) double {mustBePositive} = 0.010
                options.threshold (1,1) double = 0.9
            end

            if ~options.useGaussianBlur
                error('Non-Gaussian blur detection not yet implemented.');
            end

            dt = timeSeriesTimeStamps(2) - timeSeriesTimeStamps(1);
            gaussian_sigma_samples = options.gaussianSigmaTime / dt;

            kernel_width = 4 * round(gaussian_sigma_samples);
            x = -kernel_width:kernel_width;
            gaussian_kernel = exp(-x.^2 / (2*gaussian_sigma_samples^2));
            gaussian_kernel = gaussian_kernel / sum(gaussian_kernel);

            filtered_signal = conv(detectorOutput(:)', gaussian_kernel, 'same');

            [peak_values, peak_indices] = findpeaks(filtered_signal, 'MinPeakHeight', options.threshold);

            if isempty(peak_indices), eventTimes = []; return; end;

            peak_times = timeSeriesTimeStamps(peak_indices);

            final_indices = [];
            i = 1;
            while i <= numel(peak_indices)
                j = i;
                while j < numel(peak_indices) && peak_times(j+1) <= peak_times(i) + options.refractoryPeriod
                    j = j + 1;
                end

                window_indices_for_search = i:j;
                [~, max_local_idx] = max(peak_values(window_indices_for_search));
                winner_absolute_idx = peak_indices(window_indices_for_search(max_local_idx));
                final_indices(end+1) = winner_absolute_idx;
                i = j + 1;
            end

            eventTimes = timeSeriesTimeStamps(sort(final_indices));
        end

        function detector = buildTimeseriesDetectorMLFromDirectory(dirname)
            % BUILDTIMESERIESDETECTORMLFROMDIRECTORY - build a detector from a directory
            %
            % DETECTOR = vlt.signal.timeseriesDetectorML.base.buildTimeseriesDetectorMLFromDirectory(DIRNAME)
            %
            % Builds a new vlt.signal.timeseriesDetectorML object from a directory DIRNAME.
            %
            % The directory must contain:
            %   1) 'parameters.json' - a file that describes how to build the object.
            %      It should have a field 'timeseriesDetectorMLClassName' that has the classname
            %      of the object to create.
            %      It should have a field 'creatorInputArgs' that is a structure array with fields
            %      'name' and 'value'. These are the arguments to be passed to the creator.
            %      Argument names 'requiredArg1', 'requiredArg2', etc, are assumed to be required
            %      positional arguments. Other argument names are assumed to be name/value pairs.
            %   2) '*positive*.mat' files - one or more MAT-files that contain a variable 'positiveExamples'
            %      which is a matrix of positive examples.
            %   3) '*negative*.mat' files - one or more MAT-files that contain a variable 'negativeExamples'
            %      which is a matrix of negative examples.
            %
            % The DETECTOR is returned with its parameters trained on the positive and negative examples.
            %
            arguments
                dirname (1,:) char {mustBeFolder}
            end

            % Step 1: read parameters.json
            p_file = fullfile(dirname, 'parameters.json');
            if ~exist(p_file,'file'),
                error(['Could not find ' p_file '.']);
            end;
            params = jsondecode(fileread(p_file));

            % Step 2: build the creator string
            req_arg_str = '';
            name_value_str = '';

            if isfield(params, 'creatorInputArgs')
                for i=1:numel(params.creatorInputArgs)
                    if startsWith(params.creatorInputArgs(i).name, 'requiredArg')
                        % it is a required argument
                        value = params.creatorInputArgs(i).value;
                        if ischar(value)
                            req_arg_str = [req_arg_str '''' value ''','];
                        elseif isnumeric(value)
                            req_arg_str = [req_arg_str num2str(value) ','];
                        else
                            error(['Do not know how to handle this value type.']);
                        end
                    else
                        % it is a name/value pair
                        name = params.creatorInputArgs(i).name;
                        value = params.creatorInputArgs(i).value;
                        name_value_str = [name_value_str '''' name ''','];
                        if ischar(value)
                            name_value_str = [name_value_str '''' value ''','];
                        elseif isnumeric(value)
                            name_value_str = [name_value_str num2str(value) ','];
                        else
                            error(['Do not know how to handle this value type.']);
                        end
                    end
                end
            end
            if endsWith(req_arg_str,','), req_arg_str = req_arg_str(1:end-1); end;
            if endsWith(name_value_str,','), name_value_str = name_value_str(1:end-1); end;

            constructor_str = [params.timeseriesDetectorMLClassName '(' req_arg_str ];
            if ~isempty(name_value_str)
                if ~isempty(req_arg_str)
                    constructor_str = [ constructor_str ',' name_value_str];
                else
                    constructor_str = [ constructor_str name_value_str];
                end
            end
            constructor_str = [constructor_str ')'];

            detector = eval(constructor_str);

            % Step 3: load the positive and negative examples

            positive_files = dir(fullfile(dirname, '*positive*.mat'));
            negative_files = dir(fullfile(dirname, '*negative*.mat'));

            positiveExamples = [];
            for i=1:numel(positive_files)
                data = load(fullfile(dirname, positive_files(i).name),'positiveExamples');
                if isfield(data,'positiveExamples')
                    positiveExamples = cat(2, positiveExamples, data.positiveExamples);
                end
            end

            negativeExamples = [];
            for i=1:numel(negative_files)
                data = load(fullfile(dirname, negative_files(i).name),'negativeExamples');
                if isfield(data,'negativeExamples')
                    negativeExamples = cat(2, negativeExamples, data.negativeExamples);
                end
            end

            % Step 4: train the detector
            observations = [positiveExamples negativeExamples];
            TFvalues = [true(1,size(positiveExamples,2)) false(1,size(negativeExamples,2))];

            detector = detector.train(observations, TFvalues);
        end
    end
end
