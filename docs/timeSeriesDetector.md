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
