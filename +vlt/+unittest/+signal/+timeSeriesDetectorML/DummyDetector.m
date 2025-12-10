classdef DummyDetector < vlt.signal.timeseriesDetectorML.base
    % DUMMYDETECTOR - A concrete implementation of base class for testing

    methods
        function [obj, scores, errorEachIteration] = train(obj, observation, TFvalues, doReset, numIterations, falsePositivePenalty)
            obj = obj;
            scores = [];
            errorEachIteration = [];
        end
        function [detectLikelihood] = evaluateTimeSeries(obj, timeSeriesData)
            % Pass through the data as likelihood for testing purposes
            detectLikelihood = timeSeriesData;
        end
        function obj = initialize(obj)
        end
    end
end
