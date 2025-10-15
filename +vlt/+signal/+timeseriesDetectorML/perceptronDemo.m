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
t = (0:dt:100-dt)'; % 100 seconds of data, as a column vector
N = numel(t);
timeSeriesData = randn(size(t)); % Background noise

% Create a Gaussian-like event waveform
event_t = -0.1:dt:0.1;
event_sigma = 0.030;
event_amplitude = 10;
event_waveform = event_amplitude * exp(-event_t.^2 / (2 * event_sigma^2))';
event_duration_samples = numel(event_t);

% Add 50-100 events to the data (maintaining 5-10 per 10s)
num_events = randi([50, 100]);
event_times = zeros(1, num_events);
for i = 1:num_events
    % Ensure events do not overlap and are not at the very edge
    event_start_idx = randi([event_duration_samples, N - event_duration_samples]);
    event_center_idx = event_start_idx + floor(event_duration_samples/2);
    event_times(i) = t(event_center_idx);
    timeSeriesData(event_start_idx:event_start_idx+event_duration_samples-1) = ...
        timeSeriesData(event_start_idx:event_start_idx+event_duration_samples-1) + event_waveform;
end

% 2. Training Set Preparation
detectorSamples = numel(event_t);

% Use a threshold to find initial positive events
threshold = 5;
initial_positive_indices = vlt.signal.threshold_crossings(timeSeriesData, threshold);
initial_positive_times = t(initial_positive_indices);

% Generate augmented training data from the true event times
[observations_pos, TFvalues_pos, corrected_pos_times] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
    t, timeSeriesData, event_times, detectorSamples, 'optimizeForPeak', true);

% Generate random negative examples
num_random_negative = 20 * numel(event_times); % 20x random negatives
random_negative_times = [];
while numel(random_negative_times) < num_random_negative
    rand_idx = randi(N);
    if ~any(abs(t(rand_idx) - event_times) < (event_duration_samples * dt * 2))
        random_negative_times(end+1) = t(rand_idx);
    end
end
[observations_neg, TFvalues_neg, ~] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
    t, timeSeriesData, random_negative_times, detectorSamples, 'examplesArePositives', false, 'jitterPositive', false, 'makeShoulderNegatives', false);

% Combine all training data
observations = [observations_pos, observations_neg];
TFvalues = [TFvalues_pos, TFvalues_neg];

% 3. Training and Evaluation
p = vlt.signal.timeseriesDetectorML.perceptron(detectorSamples, 0.1);
[p, ~, errorHistory] = p.train(observations, TFvalues, false, 100, 10); % Use penalty of 10

% 4. Evaluate on the full time series
detectionLikelihood = p.evaluateTimeSeries(timeSeriesData);

% 5. Visualization
figure;

% Plot the time series data and true event locations
ax1 = subplot(3,1,1);
plot(t, timeSeriesData, 'k');
hold on;
plot(event_times, event_amplitude * ones(size(event_times)), 'gv', 'MarkerFaceColor', 'g', 'DisplayName', 'True Events');
plot(corrected_pos_times, event_amplitude * ones(size(corrected_pos_times)), 'bx', 'MarkerSize', 10, 'DisplayName', 'Corrected Detections');
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