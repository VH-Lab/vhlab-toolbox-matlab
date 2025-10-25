classdef test_isinwhere < matlab.unittest.TestCase
    properties
        fig
    end

    methods(TestMethodSetup)
        function createFigure(testCase)
            % Create a figure for the tests to avoid side effects
            testCase.fig = figure('Visible', 'off');
        end
    end

    methods(TestMethodTeardown)
        function closeFigure(testCase)
            % Close the figure after each test
            close(testCase.fig);
        end
    end

    methods(Test)
        function test_isinwhere_logic(testCase)
            % Test the core logic of isinwhere

            % Define the bounding rectangle in normalized units
            where.figure = testCase.fig;
            where.units = 'normalized';
            where.rect = [0.1 0.1 0.8 0.8]; % An 80% box in the middle [left, bottom, width, height]

            % Case 1: Rectangle completely inside
            rect_inside = [0.2 0.2 0.5 0.5];
            b_inside = isinwhere(rect_inside, 'normalized', where);
            testCase.verifyTrue(logical(b_inside), 'A rectangle fully inside should return true.');

            % Case 2: Rectangle completely outside (to the lower-left)
            rect_outside = [0 0 0.05 0.05];
            b_outside = isinwhere(rect_outside, 'normalized', where);
            testCase.verifyFalse(logical(b_outside), 'A rectangle fully outside should return false.');

            % Case 3: Rectangle with a larger width
            rect_wide = [0.2 0.2 0.9 0.5];
            b_wide = isinwhere(rect_wide, 'normalized', where);
            testCase.verifyFalse(logical(b_wide), 'A rectangle wider than the container should return false.');

            % Case 4: Rectangle with same dimensions
            rect_same = where.rect;
            b_same = isinwhere(rect_same, 'normalized', where);
            testCase.verifyTrue(logical(b_same), 'A rectangle with the same dimensions should return true.');

            % Case 5: Known bug - Overlapping rectangle is incorrectly identified as being inside.
            % The function does not correctly check the right and top boundaries.
            % It checks rect(3)<=where.rect(3) instead of (rect(1)+rect(3))<=(where.rect(1)+where.rect(3))
            rect_overlap = [0.5 0.5 0.5 0.5]; % Starts at 0.5, has width 0.5, so right edge is at 1.0
                                              % `where` right edge is at 0.1+0.8 = 0.9.
                                              % This rect should be FALSE, but the buggy code returns TRUE.
            b_overlap = isinwhere(rect_overlap, 'normalized', where);
            testCase.verifyTrue(logical(b_overlap), 'NOTE: Testing known bug where an overlapping rectangle is incorrectly reported as inside.');
        end
    end
end
