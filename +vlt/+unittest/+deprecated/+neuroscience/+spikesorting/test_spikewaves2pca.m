classdef test_spikewaves2pca < matlab.unittest.TestCase
    methods (Test)
        function testDimensionsAndNaNs(testCase)
            NumSamples = 10;
            NumChannels = 2;
            NumSpikes = 20;
            N = 3;
            
            % Create dummy waves
            waves = randn(NumSamples, NumChannels, NumSpikes);
            
            % Introduce NaNs
            waves(1, 1, 5) = NaN; 
            waves(1, 1, 10) = NaN;
            
            % Call function
            features = spikewaves2pca(waves, N, [1 NumSamples]);
            
            % Verify dimensions
            testCase.verifyEqual(size(features), [N, NumSpikes], 'Output dimensions incorrect');
            
            % Verify NaN propagation
            testCase.verifyTrue(all(isnan(features(:, 5))), 'Spike 5 should be all NaNs');
            testCase.verifyTrue(all(isnan(features(:, 10))), 'Spike 10 should be all NaNs');
            
            % Verify valid data exists
            testCase.verifyFalse(all(isnan(features(:, 1))), 'Spike 1 should not be all NaNs');
        end
    end
end
