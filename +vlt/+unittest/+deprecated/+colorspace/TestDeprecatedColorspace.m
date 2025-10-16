classdef TestDeprecatedColorspace < matlab.unittest.TestCase

    properties
        rgb_colors
        cmyk_colors
        angle_ybgr_colors
        angle_ycgr_colors
    end

    methods (TestClassSetup)
        function setupOnce(testCase)
            % RGB Test Colors (normalized 0-1)
            testCase.rgb_colors = { ...
                [1, 0, 0], ...         % Red
                [0, 1, 0], ...         % Green
                [0, 0, 1], ...         % Blue
                [1, 1, 0], ...         % Yellow
                [0, 1, 1], ...         % Cyan
                [1, 0, 1], ...         % Magenta
                [0.5, 0.5, 0.5], ...   % Gray
                [192/255, 192/255, 192/255], ... % Silver
                [128/255, 0, 0], ...   % Maroon
                [0, 128/255, 0], ...   % Dark Green
                [0, 0, 0], ...         % Black
                [1, 1, 1] ...          % White
            };

            % Corresponding CMYK Test Colors
            testCase.cmyk_colors = { ...
                [0, 1, 1, 0], ...         % Red
                [1, 0, 1, 0], ...         % Green
                [1, 1, 0, 0], ...         % Blue
                [0, 0, 1, 0], ...         % Yellow
                [1, 0, 0, 0], ...         % Cyan
                [0, 1, 0, 0], ...         % Magenta
                [0, 0, 0, 0.5], ...       % Gray
                [0, 0, 0, 1 - 192/255], ... % Silver
                [0, 1, 1, 1 - 128/255], ... % Maroon
                [1, 0, 1, 1 - 128/255], ... % Dark Green
                [0, 0, 0, 1], ...         % Black
                [0, 0, 0, 0] ...          % White
            };

            % Angle test cases for angle2ybgr
            testCase.angle_ybgr_colors = { ...
                0,   [1.0, 1.0, 0.0]; ...
                45,  [0.5, 1.0, 0.0]; ...
                90,  [0.0, 1.0, 0.0]; ...
                135, [0.0, 0.5, 0.5]; ...
                180, [0.0, 0.0, 1.0]; ...
                225, [0.5, 0.0, 0.5]; ...
                270, [1.0, 0.0, 0.0]; ...
                315, [1.0, 0.5, 0.0]; ...
                360, [1.0, 1.0, 0.0]  ...
            };

            % Angle test cases for angle2ycgr
            testCase.angle_ycgr_colors = { ...
                0,   [1.0, 1.0, 0.0]; ...
                45,  [0.5, 1.0, 0.0]; ...
                90,  [0.0, 1.0, 0.0]; ...
                135, [0.0, 1.0, 0.5]; ...
                180, [0.0, 1.0, 1.0]; ...
                225, [0.5, 0.5, 0.5]; ...
                270, [1.0, 0.0, 0.0]; ...
                315, [1.0, 0.5, 0.0]; ...
                360, [1.0, 1.0, 0.0]  ...
            };
        end
    end

    methods (Test)
        function testRgb2Cmyk(testCase)
            for i = 1:numel(testCase.rgb_colors)
                rgb_in = testCase.rgb_colors{i};
                expected_cmyk = testCase.cmyk_colors{i};
                actual_cmyk = rgb2cmyk(rgb_in);
                testCase.verifyEqual(actual_cmyk, expected_cmyk, 'AbsTol', 1e-9, ...
                    ['Failed for RGB color: ' mat2str(rgb_in)]);
            end
        end

        function testCmyk2Rgb(testCase)
            for i = 1:numel(testCase.cmyk_colors)
                cmyk_in = testCase.cmyk_colors{i};
                expected_rgb = testCase.rgb_colors{i};
                actual_rgb = cmyk2rgb(cmyk_in);
                testCase.verifyEqual(actual_rgb, expected_rgb, 'AbsTol', 1e-9, ...
                    ['Failed for CMYK color: ' mat2str(cmyk_in)]);
            end
        end

        function testAngle2ybgr(testCase)
            % Test with no input arguments
            [ctab, value, rgb] = angle2ybgr();
            testCase.verifyEqual(size(ctab), [360, 3]);
            testCase.verifyEmpty(value);
            testCase.verifyEmpty(rgb);

            % Test with specific angles
            for i = 1:size(testCase.angle_ybgr_colors, 1)
                angle = testCase.angle_ybgr_colors{i, 1};
                expected_rgb = testCase.angle_ybgr_colors{i, 2};
                [~, ~, actual_rgb] = angle2ybgr(angle);
                testCase.verifyEqual(actual_rgb, expected_rgb, 'AbsTol', 1e-9, ...
                    ['Failed for angle: ' num2str(angle)]);
            end
        end

        function testAngle2ycgr(testCase)
            % Test with no input arguments
            [ctab, value, rgb] = angle2ycgr();
            testCase.verifyEqual(size(ctab), [360, 3]);
            testCase.verifyEmpty(value);
            testCase.verifyEmpty(rgb);

            % Test with specific angles
            for i = 1:size(testCase.angle_ycgr_colors, 1)
                angle = testCase.angle_ycgr_colors{i, 1};
                expected_rgb = testCase.angle_ycgr_colors{i, 2};
                [~, ~, actual_rgb] = angle2ycgr(angle);
                testCase.verifyEqual(actual_rgb, expected_rgb, 'AbsTol', 1e-9, ...
                    ['Failed for angle: ' num2str(angle)]);
            end
        end
    end
end