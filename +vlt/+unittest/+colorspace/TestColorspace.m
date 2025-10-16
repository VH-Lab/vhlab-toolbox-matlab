classdef TestColorspace < matlab.unittest.TestCase

    methods (Test)

        function testAngle2ybgr(testCase)
            % Test with no input arguments
            [ctab, value, rgb] = vlt.colorspace.angle2ybgr();
            testCase.verifyEqual(size(ctab), [360, 3]);
            testCase.verifyEmpty(value);
            testCase.verifyEmpty(rgb);

            % Test with a specific angle
            [ctab, value, rgb] = vlt.colorspace.angle2ybgr(45);
            testCase.verifyEqual(size(ctab), [360, 3]);
            testCase.verifyNotEmpty(value);
            testCase.verifyNotEmpty(rgb);
            testCase.verifyEqual(rgb, [0.5 1 0], 'AbsTol', 1e-9);
        end

        function testAngle2ycgr(testCase)
            % Test with no input arguments
            [ctab, value, rgb] = vlt.colorspace.angle2ycgr();
            testCase.verifyEqual(size(ctab), [360, 3]);
            testCase.verifyEmpty(value);
            testCase.verifyEmpty(rgb);

            % Test with a specific angle
            [ctab, value, rgb] = vlt.colorspace.angle2ycgr(135);
            testCase.verifyEqual(size(ctab), [360, 3]);
            testCase.verifyNotEmpty(value);
            testCase.verifyNotEmpty(rgb);
            testCase.verifyEqual(rgb, [0 1 0.5], 'AbsTol', 1e-9);
        end

        function testCmyk2rgb(testCase)
            % Test black
            cmyk_black = [0 0 0 1];
            rgb_black = vlt.colorspace.cmyk2rgb(cmyk_black);
            testCase.verifyEqual(rgb_black, [0 0 0], 'AbsTol', 1e-9);

            % Test white
            cmyk_white = [0 0 0 0];
            rgb_white = vlt.colorspace.cmyk2rgb(cmyk_white);
            testCase.verifyEqual(rgb_white, [1 1 1], 'AbsTol', 1e-9);

            % Test red
            cmyk_red = [0 1 1 0];
            rgb_red = vlt.colorspace.cmyk2rgb(cmyk_red);
            testCase.verifyEqual(rgb_red, [1 0 0], 'AbsTol', 1e-9);
        end

        function testRgb2cmyk(testCase)
            % Test black
            rgb_black = [0 0 0];
            cmyk_black = vlt.colorspace.rgb2cmyk(rgb_black);
            testCase.verifyEqual(cmyk_black, [0 0 0 1], 'AbsTol', 1e-9);

            % Test white
            rgb_white = [1 1 1];
            cmyk_white = vlt.colorspace.rgb2cmyk(rgb_white);
            testCase.verifyEqual(cmyk_white, [0 0 0 0], 'AbsTol', 1e-9);

            % Test red
            rgb_red = [1 0 0];
            cmyk_red = vlt.colorspace.rgb2cmyk(rgb_red);
            testCase.verifyEqual(cmyk_red, [0 1 1 0], 'AbsTol', 1e-9);
        end

    end
end