classdef test_get_sim_func < matlab.unittest.TestCase
    % TEST_GET_SIM_FUNC - Test for the get_sim_func function
    %

    methods (Test)
        function test_returns_correct_handles(testCase)
            % TEST_RETURNS_CORRECT_HANDLES - Verify correct function handles are returned

            % Test for 'gaussian'
            gaussian_handle = vlt.stats.get_sim_func('gaussian');
            testCase.verifyEqual(gaussian_handle, @vlt.stats.simulate_lme_data, ...
                'Did not return the correct handle for "gaussian".');

            % Test for 'shuffle'
            shuffle_handle = vlt.stats.get_sim_func('shuffle');
            testCase.verifyEqual(shuffle_handle, @vlt.stats.simulate_lme_data_shuffled, ...
                'Did not return the correct handle for "shuffle".');

            % Test for 'hierarchical'
            hierarchical_handle = vlt.stats.get_sim_func('hierarchical');
            testCase.verifyEqual(hierarchical_handle, @vlt.stats.simulate_lme_data_hierarchical, ...
                'Did not return the correct handle for "hierarchical".');
        end
    end
end
