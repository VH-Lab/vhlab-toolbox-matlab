function perceptronDemo()
% PERCEPTRONDEMO - A demonstration of the vlt.signal.timeseriesDetectorML.perceptron class
%
%   vlt.signal.timeseriesDetectorML.perceptronDemo()
%
%   Generates artificial data with embedded Gaussian events, then uses the
%   perceptron detector to identify them. The function demonstrates:
%     1. Artificial data generation.
%     2. Preparation of training data using thresholding and random sampling.
%     3. Training the perceptron detector.
%     4. Evaluating the detector on the full time series.
%     5. Visualization of the results.
%

% 1. Data Generation
dt = 0.001; % 1ms sampling interval
t = (0:dt:10-dt)'; % 10 seconds of data, as a column vector
N = numel(t);
timeSeriesData = randn(size(t)); % Background noise

% Create a Gaussian-like event waveform
event_t = -0.1:dt:0.1;
event_sigma = 0.030;
event_amplitude = 2;
event_waveform = event_amplitude * exp(-event_t.^2 / (2 * event_sigma^2))';
event_duration_samples = numel(event_t);

% Add 5-10 events to the data
num_events = randi([5, 10]);
event_times = zeros(1, num_events);
for i = 1:num_events
    % Ensure events do not overlap and are not at the very edge
    event_start_idx = randi([event_duration_samples, N - event_duration_samples]);
    event_times(i) = t(event_start_idx);
    timeSeriesData(event_start_idx:event_start_idx+event_duration_samples-1) = ...
        timeSeriesData(event_start_idx:event_start_idx+event_duration_samples-1) + event_waveform;
end

% 2. Training Set Preparation
detectorSamples = numel(event_t);

% Use a threshold to find potential positive events
threshold = 1.5;
crossings = vlt.signal.threshold_crossings(timeSeriesData, threshold);
positiveTimeStamps = t(crossings);

% Choose random negative examples (avoiding actual event locations)
num_negative = 10 * numel(positiveTimeStamps); % Provide 10x more negative examples
negativeTimeStamps = [];
while numel(negativeTimeStamps) < num_negative
    rand_idx = randi(N);
    % Ensure we are not too close to a known positive event
    if ~any(abs(t(rand_idx) - event_times) < (event_duration_samples * dt * 2))
        negativeTimeStamps(end+1) = t(rand_idx);
    end
end

% Prepare observations for training
[pos_obs, ~] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(t, timeSeriesData, positiveTimeStamps, detectorSamples);
[neg_obs, ~] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(t, timeSeriesData, negativeTimeStamps, detectorSamples);
observations = [pos_obs, neg_obs];
TFvalues = [true(1, size(pos_obs, 2)), false(1, size(neg_obs, 2))];

% 3. Training and Evaluation
p = vlt.signal.timeseriesDetectorML.perceptron(detectorSamples, 0.1);
[p, ~, errorHistory] = p.train(observations, TFvalues, false, 100);

% 4. Evaluate on the full time series
detectionLikelihood = p.evaluateTimeSeries(timeSeriesData);

% 5. Visualization
figure;

% Plot the time series data and true event locations
ax1 = subplot(3,1,1);
plot(t, timeSeriesData, 'k');
hold on;
plot(event_times, event_amplitude * ones(size(event_times)), 'gv', 'MarkerFaceColor', 'g', 'DisplayName', 'True Events');
title('Time Series Data with Events');
xlabel('Time (s)');
ylabel('Amplitude');
legend;

% Plot the detector's output
ax2 = subplot(3,1,2);
plot(t, detectionLikelihood, 'r', 'DisplayName', 'Detector Output');
title('Perceptron Detector Output');
xlabel('Time (s)');
ylabel('Likelihood');
legend;

% Plot the training error
ax3 = subplot(3,1,3);
plot(1:numel(errorHistory), errorHistory, 'b-o');
title('Training Error (MSE)');
xlabel('Iteration');
ylabel('Mean Squared Error');

linkaxes([ax1, ax2], 'x');

end