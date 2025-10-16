classdef (Abstract) base
    % vlt.signal.timeseriesDetectorML.base - Abstract base class for time series machine learning detectors

    properties
        detectorSamples (1,1) uint64 {mustBePositive} = 1; % The number of samples to be considered for the detection
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
                detectorSamples (1,1) uint64
                examplesArePositives (1,1) logical = true
                options.optimizeForPeak (1,1) logical = false
                options.peakFindingSamples (1,1) uint64 = 10
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

        function [observations, TFvalues, jittered_stamps] = jitterPositiveObservations(timestamps, timeSeriesTimeStamps, timeSeriesData, detectorSamples, options)
            arguments
                timestamps (1,:) double
                timeSeriesTimeStamps (:,1) double
                timeSeriesData (:,1) double
                detectorSamples (1,1) uint64
                options.jitterRange (1,1) double {mustBePositive} = 0.002
            end
            dt = timeSeriesTimeStamps(2) - timeSeriesTimeStamps(1);
            jitter_shifts = -options.jitterRange:dt:options.jitterRange;
            jitter_shifts(abs(jitter_shifts)<(dt/2)) = []; % remove 0

            jittered_stamps = [];
            for t = timestamps
                jittered_stamps = [jittered_stamps, t + jitter_shifts];
            end

            [observations, TFvalues, jittered_stamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                timeSeriesTimeStamps, timeSeriesData, jittered_stamps, detectorSamples, true);
        end

        function [observations, TFvalues, shoulder_stamps] = shoulderNegativeObservations(timestamps, timeSeriesTimeStamps, timeSeriesData, detectorSamples, options)
            arguments
                timestamps (1,:) double
                timeSeriesTimeStamps (:,1) double
                timeSeriesData (:,1) double
                detectorSamples (1,1) uint64
                options.shoulderRangeStart (1,1) double {mustBePositive} = 0.010
                options.shoulderRangeStop (1,1) double {mustBePositive} = 0.050
            end
            dt = timeSeriesTimeStamps(2) - timeSeriesTimeStamps(1);
            shoulder_shifts = [-options.shoulderRangeStop:dt:-options.shoulderRangeStart, options.shoulderRangeStart:dt:options.shoulderRangeStop];

            shoulder_stamps = [];
            for t = timestamps
                shoulder_stamps = [shoulder_stamps, t + shoulder_shifts];
            end

            [observations, TFvalues, shoulder_stamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                timeSeriesTimeStamps, timeSeriesData, shoulder_stamps, detectorSamples, false);
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

        function plotTrainingExamples(observations, TFvalues)
            positive_examples = observations(:, TFvalues);
            negative_examples = observations(:, ~TFvalues);

            figure;

            subplot(1, 2, 1);
            plot(positive_examples, 'Color', [0.5 0.5 0.5]);
            title('Positive Training Examples');
            xlabel('Sample Number');
            ylabel('Value');

            subplot(1, 2, 2);
            plot(negative_examples, 'Color', [0.5 0.5 0.5]);
            title('Negative Training Examples');
            xlabel('Sample Number');
            ylabel('Value');
        end
    end
end