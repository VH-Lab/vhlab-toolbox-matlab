classdef (Abstract) base
    % vlt.signal.timeseriesDetectorML.base - Abstract base class for time series machine learning detectors

    properties
        detectorSamples (1,1) double {mustBeInteger, mustBePositive} = 1; % The number of samples to be considered for the detection
    end

    methods (Abstract)
        [obj, scores, errorEachIteration] = train(obj, observation, TFvalues, doReset, numIterations, falsePositivePenalty)
        [detectLikelihood] = evaluateTimeSeries(obj, timeSeriesData)
        obj = initialize(obj)
    end

    methods (Static)
        function [observations, TFvalues, newTimeStamps] = timeStamps2Observations(timeSeriesTimeStamps, timeSeriesData, detectedTimeStamps, detectorSamples, examplesArePositives, options)
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

        function [eventTimes, filtered_signal] = detectIndividualEvents(timeSeriesTimeStamps, detectorOutput, options)
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