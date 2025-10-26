classdef test_pixels2normalized < matlab.unittest.TestCase
    methods(Test)
        function test_pixels2normalized_conversion(testCase)
            % Test that pixels2normalized correctly converts units

            fig_rect = [0 0 1000 500]; % A 1000x500 pixel figure
            pixel_rect = [101 51 500 250];

            % Expected output:
            % x = (101 - 1) / 1000 = 0.1
            % y = (51 - 1) / 500 = 0.1
            % width = 500 / 1000 = 0.5
            % height = 250 / 500 = 0.5
            expected_norm_rect = [0.1 0.1 0.5 0.5];

            actual_norm_rect = pixels2normalized(fig_rect, pixel_rect);

            testCase.verifyEqual(actual_norm_rect, expected_norm_rect, 'AbsTol', 1e-9);
        end
    end
end
