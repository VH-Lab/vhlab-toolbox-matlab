# Building a Time Series Detector from a Directory

This manual describes how to train a `vlt.signal.timeseriesDetectorML.conv1dNet` machine-learning time series detector by organizing positive and negative examples into a specific directory structure. This method allows you to easily manage your training data and reproduce your detector.

## Introduction

The `vlt.signal.timeseriesDetectorML` package provides tools for detecting events in time series data using machine learning. The `conv1dNet` class implements a 1-dimensional Convolutional Neural Network (CNN) specifically designed for this purpose.

While you can train these detectors programmatically in MATLAB, a convenient "folder-based" workflow exists. You place your configuration and data files in a folder, and a single command builds and trains the detector for you.

## Step 1: Create a Training Directory

First, create a new directory on your file system to hold your detector's configuration and training data. You can name this directory whatever you like (e.g., `my_spike_detector_training`).

## Step 2: Prepare the Configuration File

Inside your training directory, create a file named `parameters.json`. This file tells the builder which class to instantiate and what parameters to use.

For a `conv1dNet` detector, the file should look like this:

```json
{
    "timeseriesDetectorMLClassName": "vlt.signal.timeseriesDetectorML.conv1dNet",
    "creatorInputArgs": [
        {
            "name": "detectorSamples",
            "value": 50
        },
        {
            "name": "firstConvLayerKernelSize",
            "value": 5
        },
        {
            "name": "firstConvLayerNodes",
            "value": 8
        }
    ]
}
```

### Key Fields:
*   **`timeseriesDetectorMLClassName`**: Must be `"vlt.signal.timeseriesDetectorML.conv1dNet"`.
*   **`creatorInputArgs`**: A list of arguments passed to the class constructor.
    *   **`detectorSamples`**: (Required) The number of time points (samples) in each input window. This must match the size of your training examples.
    *   **Other Options**: You can also specify other options like `firstConvLayerNodes`, `maxPoolSize`, `secondConvLayerKernelSize`, etc., as defined in the `conv1dNet` class.

## Step 3: Prepare Training Data

You need to provide "positive" examples (snippets of the signal containing the event you want to detect) and "negative" examples (snippets of noise or other artifacts).

### Data Format
The data must be stored in standard MATLAB `.mat` files.

*   **Positive Examples**:
    *   **Filename**: Must contain the string `positive` (e.g., `data_positive_set1.mat`).
    *   **Variable Name**: The file must contain a variable named `positiveExamples`.
    *   **Dimensions**: This variable should be a numeric matrix of size `M x N`, where:
        *   `M` is the number of samples (must match `detectorSamples` in your `parameters.json`).
        *   `N` is the number of examples.

*   **Negative Examples**:
    *   **Filename**: Must contain the string `negative` (e.g., `data_negative_noise.mat`).
    *   **Variable Name**: The file must contain a variable named `negativeExamples`.
    *   **Dimensions**: This variable should be a numeric matrix of size `M x N`.

You can have multiple `.mat` files for both positive and negative examples; the builder will load all of them and concatenate the data.

### Generating Training Data from Raw Signals

You can generate these training matrices from raw data using helper methods in `vlt.signal`. A common workflow is to perform an initial, rough detection (e.g., using thresholding), refine the event times (e.g., by aligning to peaks), and then extract the data snippets.

#### 1. Initial Detection
Use `vlt.signal.threshold_crossings` to find candidate event locations.

```matlab
% Finds indices where signal crosses the threshold
threshold = 3.5; % Example threshold
detected_indices = vlt.signal.threshold_crossings(raw_signal, threshold);

% Convert indices to timestamps (if you have a time vector)
% or work with indices directly.
detected_timestamps = time_vector(detected_indices);
```

#### 2. Filtering Close Events
Use `vlt.signal.refractory` to remove duplicate detections of the same event (e.g., multiple crossings for one spike).

```matlab
refractory_period = 0.002; % 2ms refractory period
detected_timestamps = vlt.signal.refractory(detected_timestamps, refractory_period);
```

#### 3. Refining and Extracting Positive Examples
Use `vlt.signal.timeseriesDetectorML.base.timeStamps2Observations` to refine the timestamps by aligning them to the local signal peak and extract the waveforms.

```matlab
detectorSamples = 50; % Must match your parameter.json
examplesArePositives = true; % Set to false for negative examples

[positiveExamples, TFvalues, refinedTimeStamps] = ...
    vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
        time_vector, raw_signal, detected_timestamps, ...
        detectorSamples, examplesArePositives, ...
        'optimizeForPeak', true, ...
        'peakFindingSamples', 10, ... % Search +/- 10 samples for the peak
        'useNegativeForPeak', false); % Set to true if looking for troughs (negative peaks)
```

This function performs two key tasks:
1.  **Refinement**: It searches within `peakFindingSamples` of each initial timestamp to find the local maximum (or minimum). This centers your training examples on the event peak, which improves detector performance.
2.  **Extraction**: It extracts a window of `detectorSamples` centered on the refined timestamp.

Finally, save the extracted `positiveExamples` (or `negativeExamples`) to a `.mat` file as described above.

```matlab
save('training_data_positive_1.mat', 'positiveExamples');
```

#### 4. Generating Negative Examples
To train a robust detector, you need negative examples: parts of the signal that are *not* events. You can generate these in two ways:

**Method A: "Shoulders" (Near Misses)**
This extracts data slightly offset from the true events. This teaches the detector that a peak must be centered to be valid.

```matlab
% Generate negative shoulder events
% This will sample the regions just before (-10ms to -5ms) and after (+5ms to +10ms) each event
% avoiding the region within +/- 2ms of the event peak.

[negativeExamples_shoulders, ~, ~] = ...
    vlt.signal.timeseriesDetectorML.base.negativeShoulderEvents(...
        time_vector, raw_signal, refinedTimeStamps, detectorSamples, ...
        'leftShoulderOnset', -0.010, ...
        'leftShoulderOffset', -0.005, ...
        'rightShoulderOnset', 0.005, ...
        'rightShoulderOffset', 0.010, ...
        'refractoryPeriod', 0.002);
```

**Method B: Random Background Noise**
Use the helper function `timeStamps2NegativeObservations` to automatically generate random snippets from the signal that are sufficiently far away from any detected events.

```matlab
% Generate 1000 negative examples that are at least 50ms away from any positive event
% Note: optimizeForPeak should usually be false for random noise

[negativeExamples_noise, ~, ~] = ...
    vlt.signal.timeseriesDetectorML.base.timeStamps2NegativeObservations(...
        time_vector, raw_signal, refinedTimeStamps, ...
        detectorSamples, ...
        'minimumSpacingFromPositive', 0.050, ... % 50ms
        'negativeDataSetSize', 1000, ...
        'optimizeForPeak', false);
```

Combine your negative examples and save them:
```matlab
negativeExamples = [negativeExamples_shoulders, negativeExamples_noise];
save('training_data_negative_1.mat', 'negativeExamples');
```

## Step 4: Build and Train the Detector

Once your directory is set up with `parameters.json` and your `.mat` files, you can build and train the detector in MATLAB with a single command:

```matlab
dirname = '/path/to/your/training/directory';
detector = vlt.signal.timeseriesDetectorML.base.buildTimeseriesDetectorMLFromDirectory(dirname);
```

This command will:
1.  Read the configuration from `parameters.json`.
2.  Instantiate a new `conv1dNet` object.
3.  Load all `positiveExamples` and `negativeExamples` from the `.mat` files.
4.  Train the network using these examples.
5.  Return the trained `detector` object.

## Step 5: Use the Detector

After training, you can use the `detector` object to evaluate new time series data.

```matlab
% Generate or load some new time series data
% timeSeriesData should be a vector (1xT or Tx1)
timeSeriesData = randn(1, 1000);

% Evaluate the signal
% This returns a likelihood score (0 to 1) for each time point
likelihood = detector.evaluateTimeSeries(timeSeriesData);

% Plot the results
figure;
subplot(2,1,1);
plot(timeSeriesData);
title('Original Signal');
subplot(2,1,2);
plot(likelihood);
title('Event Likelihood');
```

The `evaluateTimeSeries` method slides the detector window across the input signal and produces a continuous likelihood score indicating the probability of an event at each sample.
