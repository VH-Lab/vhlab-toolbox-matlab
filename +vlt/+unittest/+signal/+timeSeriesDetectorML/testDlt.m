classdef testDlt < matlab.unittest.TestCase
    % TESTDLT - Unit tests for the vlt.signal.timeseriesDetectorML.dlt class

    properties
        DetectorSamples = 50;
    end

    methods (Test)
        function testConstructorDefaults(testCase)
            % Test that the constructor correctly assigns default layers and options
            dlt_detector = vlt.signal.timeseriesDetectorML.dlt(testCase.DetectorSamples);

            testCase.verifyTrue(isa(dlt_detector.Layers, 'nnet.cnn.layer.Layer'));
            testCase.verifyNotEmpty(dlt_detector.Layers);

            testCase.verifyTrue(isa(dlt_detector.DLToptions, 'nnet.cnn.TrainingOptions'));
        end

        function testConstructorCustom(testCase)
            % Test constructor with custom layers and options
            customLayers = [
                imageInputLayer([testCase.DetectorSamples 1 1])
                fullyConnectedLayer(2)
                softmaxLayer
                classificationLayer];

            customOptions = trainingOptions('sgdm');

            dlt_detector = vlt.signal.timeseriesDetectorML.dlt(testCase.DetectorSamples, customLayers, customOptions);

            testCase.verifyEqual(dlt_detector.Layers, customLayers);
            testCase.verifyTrue(isa(dlt_detector.DLToptions, 'nnet.cnn.TrainingOptionsSGDM'));
        end

        function testTrainReshaping(testCase)
            % Test that the train method can be called without error,
            % verifying the data reshaping logic. This is not a test of
            % training accuracy, just that the data is prepared correctly.

            dlt_detector = vlt.signal.timeseriesDetectorML.dlt(testCase.DetectorSamples);

            % Create a minimal dataset
            obs = randn(testCase.DetectorSamples, 10);
            tf = logical([1 0 1 0 1 0 1 0 1 0]);

            % Use minimal training options to speed up the test
            fastOptions = trainingOptions('sgdm', 'MaxEpochs', 1, 'Verbose', false, 'Plots', 'none');
            dlt_detector.DLToptions = fastOptions;

            % Verify that train runs without error
            dlt_detector = testCase.verifyWarningFree(@() dlt_detector.train(obs, tf));

            % Verify that a network was trained
            testCase.verifyTrue(isa(dlt_detector.Net, 'SeriesNetwork'));
        end
    end
end