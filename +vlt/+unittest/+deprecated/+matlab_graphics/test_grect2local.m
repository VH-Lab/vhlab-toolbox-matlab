classdef test_grect2local < matlab.unittest.TestCase
    methods(Test)
        function test_grect2local_identity(testCase)
            % Test that grect2local is correct for identity case

            rect = [0.1 0.1 0.5 0.5]; % A 50% rect starting at 10%
            lrect = [0 0 1 1]; % The entire figure in [x0 y0 x1 y1] format

            % Expected output: The same as the input, since the local rect is the whole figure
            expected_rect = [0.1 0.1 0.5 0.5];

            actual_rect = grect2local(rect, 'normalized', lrect);

            testCase.verifyEqual(actual_rect, expected_rect, 'AbsTol', 1e-9);
        end

        function test_grect2local_scaling(testCase)
            % Test that grect2local correctly scales and offsets the rectangle

            rect = [0.5 0.5 0.5 0.5]; % top-right quadrant in relative coords
            lrect = [0.5 0 1 0.5]; % bottom-right quadrant of figure

            % Expected output: top-right quadrant of the local rect
            expected_rect = [0.75 0.25 0.25 0.25];

            actual_rect = grect2local(rect, 'normalized', lrect);

            testCase.verifyEqual(actual_rect, expected_rect, 'AbsTol', 1e-9);
        end
    end
end
