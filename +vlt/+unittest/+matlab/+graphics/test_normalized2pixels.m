classdef test_normalized2pixels < matlab.unittest.TestCase
    methods(Test)
        function test_normalized2pixels_conversion(testCase)
            % Test that normalized2pixels correctly converts units

            fig_rect = [0 0 1000 500]; % A 1000x500 pixel figure
            norm_rect = [0.1 0.1 0.5 0.5]; % A 50% rect starting at 10%

            % Expected output:
            % x = 0.1 * 1000 + 1 = 101
            % y = 0.1 * 500 + 1 = 51
            % width = 0.5 * 1000 = 500
            % height = 0.5 * 500 = 250
            expected_pixel_rect = [101 51 500 250];

            actual_pixel_rect = vlt.matlab.graphics.normalized2pixels(fig_rect, norm_rect);

            testCase.verifyEqual(actual_pixel_rect, expected_pixel_rect);
        end
    end
end
