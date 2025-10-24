classdef test_getLMESimFunc < matlab.unittest.TestCase
    % TEST_GETLMESIMFUNC - Test for the getLMESimFunc function
    %

    methods (Test)
        function test_returns_correct_handles(testCase)
            % TEST_RETURNS_CORRECT_HANDLES - Verify correct function handles are returned

            % Test for 'gaussian'
            gaussian_handle = vlt.stats.power.getLMESimFunc('gaussian');
            testCase.verifyEqual(gaussian_handle, @vlt.stats.power.simulate_lme_data, ...
                'Did not return the correct handle for "gaussian".');

            % Test for 'shuffle'
            shuffle_handle = vlt.stats.power.getLMESimFunc('shuffle');
            testCase.verifyEqual(shuffle_handle, @vlt.stats.power.simulate_lme_data_shuffled, ...
                'Did not return the correct handle for "shuffle".');

            % Test for 'hierarchical'
            hierarchical_handle = vlt.stats.power.getLMESimFunc('hierarchical');
            testCase.verifyEqual(hierarchical_handle, @vlt.stats.power.simulate_lme_data_hierarchical, ...
                'Did not return the correct handle for "hierarchical".');
        end
    end
end
