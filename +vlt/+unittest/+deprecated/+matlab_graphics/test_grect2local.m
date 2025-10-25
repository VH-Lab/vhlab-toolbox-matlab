classdef test_grect2local < matlab.unittest.TestCase
    methods(Test)
        function test_grect2local_scaling(testCase)
            % Test that grect2local correctly scales the rectangle

            rect = [0.1 0.1 0.5 0.5]; % A 50% rect starting at 10%
            lrect = [0 0 1 1]; % The entire figure in [x0 y0 x1 y1] format

            % Expected output:
            w = lrect(3) - lrect(1); % = 1
            h = lrect(4) - lrect(2); % = 1
            % x = lrect(1) + w * rect(1) = 0 + 1 * 0.1 = 0.1
            % y = lrect(2) + h * rect(2) = 0 + 1 * 0.1 = 0.1
            % width = rect(3) * w = 0.5 * 1 = 0.5
            % height = rect(4) * h = 0.5 * 1 = 0.5
            expected_rect = [0.1 0.1 0.5 0.5];

            actual_rect = grect2local(rect, 'normalized', lrect);

            testCase.verifyEqual(actual_rect, expected_rect, 'AbsTol', 1e-9);
        end
    end
end
