classdef (Abstract) base
    % vlt.signal.timeseriesDetectorML.base - Abstract base class for time series machine learning detectors
    %

    properties
        detectorSamples (1,1) uint64 {mustBePositive} = 1; % The number of samples to be considered for the detection
    end

    methods (Abstract)
        % TRAIN - Train the detector
        %
        %   [obj, scores] = train(obj, observation, TFvalues, doReset)
        %
        %   Trains the detector with training data.
        %
        %   Inputs:
        %     obj - The detector object.
        %     observation - A matrix of training data (one column per observation).
        %     TFvalues - A boolean vector indicating if the observation is a match.
        %     doReset - (Optional) If true, re-initializes the learned parameters (default: false).
        %
        %   Outputs:
        %     obj - The trained detector object.
        %     scores - The scores from the training.
        %
        [obj, scores] = train(obj, observation, TFvalues, doReset)

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
        function [observations, newTimeStamps] = timeStamps2Observations(timeSeriesData, detectedTimeStamps, detectorSamples, options)
            % TIMESTAMPS2OBSERVATIONS - convert timestamps to observations for training/evaluation
            %
            %   [OBSERVATIONS, NEWTIMESTAMPS] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
            %       TIMESERIESDATA, DETECTEDTIMESTAMPS, DETECTORSAMPLES, Name, Value, ...)
            %
            %   Inputs:
            %     timeSeriesData - The time series data (1-D vector).
            %     detectedTimeStamps - The timestamps (indices) of the detected events.
            %     detectorSamples - The number of samples for each observation window.
            %   Optional Name-Value pairs:
            %     'optimizeForPeak'    - (logical) If true, find the peak around the timestamp. Default false.
            %     'peakFindingSamples' - (integer) The number of samples to search for a peak. Default 10.
            %     'useNegativeForPeak' - (logical) If true, search for a minimum instead of a maximum. Default false.
            %
            %   Outputs:
            %     observations - A matrix of observations (detectorSamples x N).
            %     newTimeStamps - The adjusted timestamps after peak finding (1 x N).
            %
            arguments
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
                currentStamp = newTimeStamps(i);

                if options.optimizeForPeak
                    searchStart = max(1, currentStamp - halfWindow);
                    searchEnd = min(length(timeSeriesData), currentStamp + halfWindow);

                    if options.useNegativeForPeak
                        [~, peakIdx] = min(timeSeriesData(searchStart:searchEnd));
                    else
                        [~, peakIdx] = max(timeSeriesData(searchStart:searchEnd));
                    end
                    currentStamp = searchStart + peakIdx - 1;
                    newTimeStamps(i) = currentStamp;
                end

                % Define observation window, centered on the (potentially new) timestamp
                obsStart = currentStamp - floor(double(detectorSamples)/2);
                obsEnd = obsStart + double(detectorSamples) - 1;

                if obsStart >= 1 && obsEnd <= length(timeSeriesData)
                    observations(:, i) = timeSeriesData(obsStart:obsEnd);
                else
                    % Handle edge cases where the window is out of bounds.
                    % Fill with NaN to indicate invalid observation.
                    observations(:, i) = NaN;
                end
            end
            % Remove columns with NaN, and their corresponding timestamps
            validCols = ~any(isnan(observations), 1);
            observations = observations(:, validCols);
            newTimeStamps = newTimeStamps(validCols);
        end
    end
end