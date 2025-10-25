classdef test_grect2local < matlab.unittest.TestCase
    methods(Test)
        function test_grect2local_scaling(testCase)
            % Test that grect2local correctly scales the rectangle

            rect = [0.1 0.1 0.5 0.5]; % A 50% rect starting at 10%
            lrect = [0 1 0 1]; % The entire figure

            % Expected output: The same as the input, since the local rect is the whole figure
            expected_rect = rect;

            actual_rect = vlt.matlab.graphics.grect2local(rect, 'normalized', lrect);

            testCase.verifyEqual(actual_rect, expected_rect, 'AbsTol', 1e-9);
        end
    end
end
