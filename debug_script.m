% Debug script for detectIndividualEvents

% 1. Create a clear test signal
t_vec = (0:0.001:1-0.001)';
detectorOutput = zeros(1, numel(t_vec));
peak1_idx = 250;
peak2_idx = 260; % within refractory period of peak1
peak3_idx = 750;

detectorOutput(peak1_idx) = 1.0; % Strongest peak
detectorOutput(peak2_idx) = 0.8; % Weaker peak, should be ignored by refractory logic
detectorOutput(peak3_idx) = 0.9; % Second event

% 2. Define parameters
gaussianSigmaTime = 0.003; % 3ms sigma
refractoryPeriod = 0.020; % 20ms
threshold = 0.5;

% 3. Run the actual function
[eventTimes, filtered_signal] = vlt.signal.timeseriesDetectorML.base.detectIndividualEvents(...
    t_vec, detectorOutput, ...
    'gaussianSigmaTime', gaussianSigmaTime, ...
    'threshold', threshold, ...
    'refractoryPeriod', refractoryPeriod);

% 4. Display results
disp('Event times found:');
disp(eventTimes);
disp('Filtered signal max:');
disp(max(filtered_signal));