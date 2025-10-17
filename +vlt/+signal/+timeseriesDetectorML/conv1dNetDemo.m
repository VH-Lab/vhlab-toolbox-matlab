function conv1dNetDemo()
% CONV1DNETDEMO - A demonstration of the vlt.signal.timeseriesDetectorML.conv1dNet class
%
%   vlt.signal.timeseriesDetectorML.conv1dNetDemo()
%
%   Generates artificial data, then uses the conv1dNet class to build,
%   train, and evaluate a 1D CNN for event detection.
%

% 1. Data Generation
dt = 0.001;
t = (0:dt:200-dt)'; % Longer time series for more data
N = numel(t);
timeSeriesData = randn(size(t));
event_t = -0.025:dt:0.025; % Shorter event for 50 sample window
event_sigma = 0.010;
event_amplitude = 10;
event_waveform = event_amplitude * exp(-event_t.^2 / (2 * event_sigma^2))';
event_duration_samples = numel(event_t);
num_events = randi([150, 200]);
ground_truth_event_times = zeros(1, num_events);
for i = 1:num_events
    event_start_idx = randi([event_duration_samples, N - event_duration_samples]);
    ground_truth_event_times(i) = t(event_start_idx + floor(event_duration_samples/2));
    timeSeriesData(event_start_idx:event_start_idx+event_duration_samples-1) = ...
        timeSeriesData(event_start_idx:event_start_idx+event_duration_samples-1) + event_waveform;
end

% 2. Training and Validation Set Preparation
detectorSamples = uint64(event_duration_samples);

[obs_pos, tf_pos, ~] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(t, timeSeriesData, ground_truth_event_times, detectorSamples, true);
num_random_negative = 2 * size(obs_pos, 2);
random_negative_times = [];
while numel(random_negative_times) < num_random_negative
    rand_idx = randi(N);
    if ~any(abs(t(rand_idx) - ground_truth_event_times) < (event_duration_samples * dt * 5))
        random_negative_times(end+1) = t(rand_idx);
    end
end
[obs_neg, tf_neg, ~] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(t, timeSeriesData, random_negative_times, detectorSamples, false);

observations = [obs_pos, obs_neg];
TFvalues = [tf_pos, tf_neg];

cv = cvpartition(size(observations, 2), 'HoldOut', 0.2);
idx_train = training(cv);
idx_val = test(cv);
X_train = observations(:, idx_train);
Y_train = TFvalues(idx_train);
X_validation = observations(:, idx_val);
Y_validation = TFvalues(idx_val);

% 3. Training and Evaluation
% Create the training options with validation data
dlt_options = trainingOptions('adam', ...
    'InitialLearnRate', 0.001, ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 128, ...
    'Shuffle', 'every-epoch', ...
    'Verbose', true, ...
    'Plots', 'training-progress', ...
    'ValidationData', {reshape(X_validation, [detectorSamples, 1, 1, size(X_validation,2)]), categorical(Y_validation)});

% Instantiate the conv1dNet with default architecture but custom options
cnn_detector = vlt.signal.timeseriesDetectorML.conv1dNet('detectorSamples', detectorSamples, 'DLToptions', dlt_options);
cnn_detector = cnn_detector.train(X_train, Y_train);

% 4. Evaluate on the full time series
detectionLikelihood = cnn_detector.evaluateTimeSeries(t, timeSeriesData);
[detected_events, filtered_likelihood] = vlt.signal.timeseriesDetectorML.base.detectIndividualEvents(t, detectionLikelihood, 'threshold', 0.5, 'gaussianSigmaTime', 0.005);

% 5. Visualization
figure('Position', [100, 100, 1200, 600]);
ax1 = subplot(3,1,1);
plot(t, timeSeriesData, 'k-', 'DisplayName', 'Time Series Data');
hold on;
y_level = max(timeSeriesData) * 1.1;
h_true = plot(ground_truth_event_times, y_level*ones(size(ground_truth_event_times)), 'gv', 'MarkerFaceColor', 'g', 'DisplayName', 'True Events');
h_detected = plot(detected_events, y_level*ones(size(detected_events)), 'rx', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Detected Events');
h_neg = plot(random_negative_times, y_level*0.95*ones(size(random_negative_times)), 'm.', 'DisplayName', 'Negative Examples');
title('Time Series Data with Detections');
xlabel('Time (s)');
ylabel('Amplitude');
legend([h_true, h_detected, h_neg],'Location', 'northeast');
box off;

ax2 = subplot(3,1,2);
plot(t, detectionLikelihood, 'r', 'DisplayName', 'Detector Output');
title('1D CNN Detector Output (Likelihood)');
xlabel('Time (s)');
ylabel('Likelihood');
box off;

ax3 = subplot(3,1,3);
plot(t, filtered_likelihood, 'm', 'DisplayName', 'Filtered Output');
hold on;
plot(ground_truth_event_times, max(filtered_likelihood) * ones(size(ground_truth_event_times)), 'gv', 'MarkerFaceColor', 'g');
plot(detected_events, max(filtered_likelihood) * ones(size(detected_events)), 'rx', 'MarkerSize', 10);
title('Filtered Detector Output and Final Detections');
xlabel('Time (s)');
ylabel('Filtered Likelihood');
box off;

linkaxes([ax1, ax2, ax3], 'x');

end