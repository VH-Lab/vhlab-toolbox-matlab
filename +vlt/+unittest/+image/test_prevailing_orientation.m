classdef test_prevailing_orientation < matlab.unittest.TestCase
    % TEST_PREVAILING_ORIENTATION - tests for vlt.image.prevailing_orientation
    %
    % Builds sinusoidal gratings at orientations spanning 0 to 180 degrees and
    % checks that rotating each image by the returned THETA leaves a grating that
    % varies only along dimension 2 (across columns) and is near-constant along
    % dimension 1 (down rows).

    properties (TestParameter)
        phiDegrees = {0, 20, 45, 70, 90, 120, 160};
    end

    methods (Test)
        function testRotationAlignsGrating(testCase, phiDegrees)
            [x,y] = meshgrid(-50:50, -50:50); % x = columns, y = rows
            phi = deg2rad(phiDegrees);
            im = sin(0.3*(cos(phi)*x + sin(phi)*y));

            theta = vlt.image.prevailing_orientation(im);

            testCase.verifyGreaterThan(theta, -pi - eps);
            testCase.verifyLessThanOrEqual(theta, pi + eps);

            % theta is an orientation, so compare modulo pi
            angleDiff = mod(theta - phi + pi/2, pi) - pi/2;
            testCase.verifyLessThan(abs(angleDiff), deg2rad(5), ...
                sprintf('Orientation %g deg returned theta = %g deg.', ...
                phiDegrees, rad2deg(theta)));

            imRotated = imrotate(im, rad2deg(theta), 'bilinear', 'crop');
            center = 51;
            halfWidth = 15;
            crop = imRotated(center-halfWidth:center+halfWidth, ...
                center-halfWidth:center+halfWidth);

            varAlongDim1 = mean(var(crop, 0, 1));
            varAlongDim2 = mean(var(crop, 0, 2));

            testCase.verifyLessThan(varAlongDim1, 0.1, ...
                sprintf('Rotated grating at %g deg should be near-constant along dim 1 (var = %g).', ...
                phiDegrees, varAlongDim1));
            testCase.verifyGreaterThan(varAlongDim2, 0.3, ...
                sprintf('Rotated grating at %g deg should vary along dim 2 (var = %g).', ...
                phiDegrees, varAlongDim2));
        end

        function testSecondOutputMatchesImrotate(testCase)
            [x,y] = meshgrid(-50:50, -50:50);
            phi = deg2rad(120);
            im = sin(0.3*(cos(phi)*x + sin(phi)*y));

            [theta, imOut] = vlt.image.prevailing_orientation(im);
            expected = imrotate(im, rad2deg(theta), 'bilinear', 'crop');
            testCase.verifyEqual(imOut, expected, 'AbsTol', 1e-12);
        end
    end
end
