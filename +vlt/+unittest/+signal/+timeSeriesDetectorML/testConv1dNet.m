classdef testConv1dNet < matlab.unittest.TestCase
    % TESTCONV1DNET - Unit tests for the vlt.signal.timeseriesDetectorML.conv1dNet class

    methods (Test)
        function testConstructorDefaults(testCase)
            % Test that the constructor builds a network with default parameters

            cnn = vlt.signal.timeseriesDetectorML.conv1dNet();

            % Verify that it is a subclass of dlt
            testCase.verifyClass(cnn, 'vlt.signal.timeseriesDetectorML.dlt');

            % Verify some default parameters were used to build the layers
            layers = cnn.Layers;
            testCase.verifyEqual(layers(1).InputSize, [50 1 1]); % default detectorSamples
            testCase.verifyEqual(layers(2).FilterSize, [5 1]); % default firstConvLayerKernelSize
            testCase.verifyEqual(layers(2).NumFilters, 8); % default firstConvLayerNodes
        end

        function testConstructorCustom(testCase)
            % Test constructor with custom architecture parameters

            cnn = vlt.signal.timeseriesDetectorML.conv1dNet(...
                'detectorSamples', 100, ...
                'firstConvLayerKernelSize', 7, ...
                'firstConvLayerNodes', 16, ...
                'maxPoolSize', 3, ...
                'secondConvLayerKernelSize', 5, ...
                'secondConvLayerNodes', 32);

            layers = cnn.Layers;
            % Input layer
            testCase.verifyEqual(layers(1).InputSize, [100 1 1]);
            % First conv layer
            testCase.verifyEqual(layers(2).FilterSize, [7 1]);
            testCase.verifyEqual(layers(2).NumFilters, 16);
            % Max pooling layer
            testCase.verifyEqual(layers(4).PoolSize, [3 1]);
            % Second conv layer
            testCase.verifyEqual(layers(5).FilterSize, [5 1]);
            testCase.verifyEqual(layers(5).NumFilters, 32);
        end
    end
end