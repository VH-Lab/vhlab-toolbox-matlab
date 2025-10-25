classdef test_cubeplot3d < matlab.unittest.TestCase
    properties
        fig
    end

    methods(TestMethodSetup)
        function createFigure(testCase)
            testCase.fig = figure('Visible', 'off');
        end
    end

    methods(TestMethodTeardown)
        function closeFigure(testCase)
            close(testCase.fig);
        end
    end

    methods(Test)
        function test_cubeplot3d_creates_axes(testCase)
            % Test that cubeplot3d creates the expected axes

            plot_name = 'myCubePlot';
            vlt.matlab.graphics.cubeplot3d(plot_name, 'fig', testCase.fig, 'command', [plot_name 'init']);

            % Check for the 3d axes
            h = findobj(testCase.fig, 'Tag', [plot_name '-3dAxes']);
            testCase.verifyNotEmpty(h, 'The 3D axes were not created.');
        end
    end
end
