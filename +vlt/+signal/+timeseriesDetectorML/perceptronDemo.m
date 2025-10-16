function perceptronDemo()
% PERCEPTRONDEMO - A demonstration of the vlt.signal.timeseriesDetectorML.perceptron class
%
%   vlt.signal.timeseriesDetectorML.perceptronDemo()
%
%   Generates artificial data with embedded Gaussian events, then uses the
%   perceptron detector to identify them. The function demonstrates:
%     1. Artificial data generation.
%     2. Explicit data augmentation (jitter, shoulders).
%     3. Training the perceptron detector.
%     4. Evaluating the detector on the full time series.
%     5. Visualization of the results.
%

% 1. Data Generation
dt = 0.001;
t = (0:dt:100-dt)';
N = numel(t);
timeSeriesData = randn(size(t));
event_t = -0.1:dt:0.1;
event_sigma = 0.030;
event_amplitude = 10;
event_waveform = event_amplitude * exp(-event_t.^2 / (2 * event_sigma^2))';
event_duration_samples = numel(event_t);
num_events = randi([20, 30]); % Reduced for clarity
event_times = zeros(1, num_events);
for i = 1:num_events
    event_start_idx = randi([event_duration_samples, N - event_duration_samples]);
    event_center_idx = event_start_idx + floor(event_duration_samples/2);
    event_times(i) = t(event_center_idx);
    timeSeriesData(event_start_idx:event_start_idx+event_duration_samples-1) = ...
        timeSeriesData(event_start_idx:event_start_idx+event_duration_samples-1) + event_waveform;
end

% 2. Training Set Preparation
detectorSamples = uint64(event_duration_samples);

% Positive examples from ground truth
[obs_pos, tf_pos, ~] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(t, timeSeriesData, event_times, detectorSamples, true);

% Positive examples from jittering
[obs_jitter, tf_jitter, jittered_stamps] = vlt.signal.timeseriesDetectorML.base.jitterPositiveObservations(event_times, t, timeSeriesData, detectorSamples);
positive_training_stamps = [event_times, jittered_stamps];

% Negative examples from shoulders
[obs_shoulder, tf_shoulder, shoulder_stamps] = vlt.signal.timeseriesDetectorML.base.shoulderNegativeObservations(event_times, t, timeSeriesData, detectorSamples);

% Negative examples from random points
num_random_negative = 5 * numel(event_times);
random_negative_times = [];
while numel(random_negative_times) < num_random_negative
    rand_idx = randi(N);
    if ~any(abs(t(rand_idx) - event_times) < (event_duration_samples * dt * 5))
        random_negative_times(end+1) = t(rand_idx);
    end
end
[obs_random_neg, tf_random_neg, ~] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(t, timeSeriesData, random_negative_times, detectorSamples, false);
negative_training_stamps = [shoulder_stamps, random_negative_times];

% Combine all training data
observations = [obs_pos, obs_jitter, obs_shoulder, obs_random_neg];
TFvalues = [tf_pos, tf_jitter, tf_shoulder, tf_random_neg];

% 3. Training and Evaluation
p = vlt.signal.timeseriesDetectorML.perceptron(detectorSamples, 0.1);
[p, ~, errorHistory] = p.train(observations, TFvalues, true, 100, 10);

% 4. Evaluate on the full time series
detectionLikelihood = p.evaluateTimeSeries(timeSeriesData);

% For plotting: find initial threshold crossings from raw data and then correct them
initial_detected_indices_raw = find(timeSeriesData > 5); % Example threshold on raw data
initial_detected_times_raw = t(initial_detected_indices_raw);
[~, ~, peak_corrected_times_raw] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(t, timeSeriesData, initial_detected_times_raw, detectorSamples, true, 'optimizeForPeak', true);

% For performance metrics: get final detected events from detector output
[detected_events, filtered_likelihood] = vlt.signal.timeseriesDetectorML.base.detectIndividualEvents(t, detectionLikelihood, 'threshold', 0.8);

% 5. Visualization
figure('Position', [100, 100, 1200, 900]);
ax1 = subplot(4,1,1);
plot(t, timeSeriesData, 'k-', 'DisplayName', 'Time Series Data');
hold on;
y_level = max(timeSeriesData) * 1.1;
h_true = plot(event_times, y_level*ones(size(event_times)), 'gv', 'MarkerFaceColor', 'g', 'DisplayName', 'a) True Events');
h_detected_initial = plot(initial_detected_times_raw, (y_level*1.05)*ones(size(initial_detected_times_raw)), 'c^', 'DisplayName', 'b) Detections by Threshold (Raw)');
h_detected_peak_corrected = plot(peak_corrected_times_raw, (y_level*1.1)*ones(size(peak_corrected_times_raw)), 'ms', 'DisplayName', 'c) Corrected by Peak Adjustment (Raw)');
h_train_pos = plot(positive_training_stamps, (y_level*0.95)*ones(size(positive_training_stamps)), 'b+', 'DisplayName', 'd) Positive Training Examples');
h_train_neg = plot(negative_training_stamps, (y_level*0.9)*ones(size(negative_training_stamps)), 'm.', 'DisplayName', 'e) Negative Training Examples');
title('Time Series Data with Events and Training Data');
xlabel('Time (s)');
ylabel('Amplitude');
legend([h_true, h_detected_initial, h_detected_peak_corrected, h_train_pos, h_train_neg], ...
    'Location', 'northeastoutside');
ylim([min(timeSeriesData), y_level*1.25]);

ax2 = subplot(4,1,2);
plot(t, detectionLikelihood, 'r', 'DisplayName', 'Detector Output');
title('Perceptron Detector Output (Likelihood)');
xlabel('Time (s)');
ylabel('Likelihood');
legend;

ax3 = subplot(4,1,3);
plot(t, filtered_likelihood, 'm', 'DisplayName', 'Filtered Output');
hold on;
plot(event_times, max(filtered_likelihood) * ones(size(event_times)), 'gv', 'MarkerFaceColor', 'g', 'DisplayName', 'True Events');
plot(detected_events, max(filtered_likelihood) * ones(size(detected_events)), 'rx', 'MarkerSize', 10, 'DisplayName', 'Final Detected Events (from Detector)');
title('Filtered Detector Output and Final Detections');
xlabel('Time (s)');
ylabel('Filtered Likelihood');
legend;

ax4 = subplot(4,1,4);
plot(1:numel(errorHistory), errorHistory, 'b-o');
title('Training Error (MSE)');
xlabel('Iteration');
ylabel('Mean Squared Error');

linkaxes([ax1, ax2, ax3], 'x');

end