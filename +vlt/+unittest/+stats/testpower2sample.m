classdef testpower2sample < matlab.unittest.TestCase
    % TESTPOWER2SAMPLE - Test for vlt.stats.power2sample and its demo
    %

    properties
    end

    methods (Test)

        function test_power2sample_basic(testCase)
            % Test basic functionality of power2sample

            sample1 = randn(1, 15);
            sample2 = randn(1, 15);
            differences = [0 1];

            % Test ttest2
            p_ttest = vlt.stats.power2sample(sample1, sample2, differences, 'test', 'ttest2', 'numSimulations', 100);
            testCase.verifyEqual(numel(p_ttest), numel(differences), 'Output size mismatch for ttest2');
            testCase.verifyGreaterThanOrEqual(p_ttest(2), p_ttest(1), 'Power should be monotonic for ttest2');

            % Test kstest2
            p_kstest = vlt.stats.power2sample(sample1, sample2, differences, 'test', 'kstest2', 'numSimulations', 100);
            testCase.verifyEqual(numel(p_kstest), numel(differences), 'Output size mismatch for kstest2');
            testCase.verifyGreaterThanOrEqual(p_kstest(2), p_kstest(1), 'Power should be monotonic for kstest2');

            % Test ranksum
            p_ranksum = vlt.stats.power2sample(sample1, sample2, differences, 'test', 'ranksum', 'numSimulations', 100);
            testCase.verifyEqual(numel(p_ranksum), numel(differences), 'Output size mismatch for ranksum');
            testCase.verifyGreaterThanOrEqual(p_ranksum(2), p_ranksum(1), 'Power should be monotonic for ranksum');
        end

        function test_power2sample_demo(testCase)
            % Test if the demo runs without error

            try
                vlt.stats.power2sampleDemo();
                % Close the figure created by the demo
                close(gcf);
            catch e
                testCase.verifyFail(['The demo function failed with error: ' e.message]);
            end
        end

    end

end
