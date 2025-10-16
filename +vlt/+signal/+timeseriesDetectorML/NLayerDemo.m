function NLayerDemo()
% NLAYERDEMO - A demonstration of the vlt.signal.timeseriesDetectorML.NLayer class
%
%   vlt.signal.timeseriesDetectorML.NLayerDemo()
%
%   Generates artificial data with embedded Gaussian events, then uses the
%   NLayer detector to identify them. The function demonstrates:
%     1. Artificial data generation.
%     2. Detection of events in raw data to seed training.
%     3. Data augmentation (jitter, shoulders) based on detected events.
%     4. Training the NLayer detector.
%     5. Evaluating the detector on the full time series.
%     6. Visualization of the results.
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
ground_truth_event_times = zeros(1, num_events);
for i = 1:num_events
    event_start_idx = randi([event_duration_samples, N - event_duration_samples]);
    event_center_idx = event_start_idx + floor(event_duration_samples/2);
    ground_truth_event_times(i) = t(event_center_idx);
    timeSeriesData(event_start_idx:event_start_idx+event_duration_samples-1) = ...
        timeSeriesData(event_start_idx:event_start_idx+event_duration_samples-1) + event_waveform;
end

% 2. Detect events from raw data to seed training
detectorSamples = uint64(event_duration_samples);
event_threshold = 5;
refractory_period_s = 0.2;
initial_detected_indices = vlt.signal.threshold_crossings(timeSeriesData, event_threshold);
initial_detected_indices = vlt.signal.refractory(initial_detected_indices, refractory_period_s / dt);
initial_detected_times = t(initial_detected_indices);

% 3. Training Set Preparation
peakFindingSamples = round(0.1 / dt);
[obs_pos, tf_pos, peak_corrected_times] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(t, timeSeriesData, initial_detected_times, detectorSamples, true, 'optimizeForPeak', true, 'peakFindingSamples', peakFindingSamples);
[obs_jitter, tf_jitter, ~] = vlt.signal.timeseriesDetectorML.base.jitterPositiveObservations(peak_corrected_times, t, timeSeriesData, detectorSamples);
[obs_shoulder, tf_shoulder, ~] = vlt.signal.timeseriesDetectorML.base.shoulderNegativeObservations(peak_corrected_times, t, timeSeriesData, detectorSamples, 'shoulderRangeStart', 0.1, 'shoulderRangeStop', 0.2);
num_random_negative = 10 * numel(peak_corrected_times);
random_negative_times = [];
while numel(random_negative_times) < num_random_negative
    rand_idx = randi(N);
    if ~any(abs(t(rand_idx) - ground_truth_event_times) < (event_duration_samples * dt * 5))
        random_negative_times(end+1) = t(rand_idx);
    end
end
[obs_random_neg, tf_random_neg, ~] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(t, timeSeriesData, random_negative_times, detectorSamples, false);
observations = [obs_pos, obs_jitter, obs_shoulder, obs_random_neg];
TFvalues = [tf_pos, tf_jitter, tf_shoulder, tf_random_neg];

% 4. Training and Evaluation
vlt.signal.timeseriesDetectorML.base.plotTrainingExamples(observations, TFvalues);
M = [4 1]; % The network architecture
nlayer = vlt.signal.timeseriesDetectorML.NLayer(detectorSamples, M, 0.1);
[nlayer, ~, errorHistory] = nlayer.train(observations, TFvalues, true, 200, 10); % More iterations for NLayer

% 5. Evaluate on the full time series
detectionLikelihood = nlayer.evaluateTimeSeries(timeSeriesData);
[detected_events, filtered_likelihood] = vlt.signal.timeseriesDetectorML.base.detectIndividualEvents(t, detectionLikelihood, 'threshold', 0.8);

% 6. Visualization
figure('Position', [100, 100, 1200, 900]);
ax1 = subplot(4,1,1);
plot(t, timeSeriesData, 'k-', 'DisplayName', 'Time Series Data');
hold on;
y_level = max(timeSeriesData) * 1.1;
h_true = plot(ground_truth_event_times, y_level*ones(size(ground_truth_event_times)), 'gv', 'MarkerFaceColor', 'g', 'DisplayName', 'True Events');
h_detected = plot(detected_events, y_level*ones(size(detected_events)), 'rx', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Detected Events');
title('Time Series Data with Events');
xlabel('Time (s)');
ylabel('Amplitude');
legend([h_true, h_detected], 'Location', 'northeast');
box off;

ax2 = subplot(4,1,2);
plot(t, detectionLikelihood, 'r', 'DisplayName', 'Detector Output');
title('N-Layer Detector Output (Likelihood)');
xlabel('Time (s)');
ylabel('Likelihood');
box off;

ax3 = subplot(4,1,3);
plot(t, filtered_likelihood, 'm', 'DisplayName', 'Filtered Output');
hold on;
plot(ground_truth_event_times, max(filtered_likelihood) * ones(size(ground_truth_event_times)), 'gv', 'MarkerFaceColor', 'g');
plot(detected_events, max(filtered_likelihood) * ones(size(detected_events)), 'rx', 'MarkerSize', 10);
title('Filtered Detector Output and Final Detections');
xlabel('Time (s)');
ylabel('Filtered Likelihood');
box off;

ax4 = subplot(4,1,4);
plot(1:numel(errorHistory), errorHistory, 'b-o');
title('Training Error (MSE)');
xlabel('Iteration');
ylabel('Mean Squared Error');
box off;

linkaxes([ax1, ax2, ax3], 'x');

end