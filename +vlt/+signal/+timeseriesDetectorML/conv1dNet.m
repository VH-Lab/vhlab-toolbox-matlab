classdef conv1dNet < vlt.signal.timeseriesDetectorML.dlt
    % CONV1DNET - A convenience class for creating a 2-tier 1D CNN for time series.
    %
    %   This class simplifies the creation of a common 2-tier CNN architecture
    %   by providing named parameters for the network's structure. It inherits
    %   the training and evaluation methods from the dlt class.
    %

    methods
        function obj = conv1dNet(options)
            % CONV1DNET - Creates a new 1D CNN detector.
            %
            %   OBJ = vlt.signal.timeseriesDetectorML.conv1dNet( ... )
            %
            %   Accepts name-value pairs to define the network architecture.
            %
            arguments
                options.detectorSamples (1,1) {mustBeInteger, mustBePositive} = 50
                options.firstConvLayerKernelSize (1,1) {mustBeInteger, mustBePositive} = 5
                options.firstConvLayerNodes (1,1) {mustBeInteger, mustBePositive} = 8
                options.maxPoolSize (1,1) {mustBeInteger, mustBePositive} = 2
                options.secondConvLayerKernelSize (1,1) {mustBeInteger, mustBePositive} = 3
                options.secondConvLayerNodes (1,1) {mustBeInteger, mustBePositive} = 16
                options.DLToptions = []
            end

            % Build the layers array programmatically
            layers = [
                imageInputLayer([options.detectorSamples 1 1], 'Normalization', 'none')

                convolution2dLayer([options.firstConvLayerKernelSize 1], options.firstConvLayerNodes, 'Padding', 'same')
                reluLayer
                maxPooling2dLayer([options.maxPoolSize 1], 'Stride', [options.maxPoolSize 1])

                convolution2dLayer([options.secondConvLayerKernelSize 1], options.secondConvLayerNodes, 'Padding', 'same')
                reluLayer

                fullyConnectedLayer(2)
                softmaxLayer
                classificationLayer
            ];

            % Call the superclass constructor with the generated layers
            obj@vlt.signal.timeseriesDetectorML.dlt(options.detectorSamples, layers, options.DLToptions);
        end
    end
end