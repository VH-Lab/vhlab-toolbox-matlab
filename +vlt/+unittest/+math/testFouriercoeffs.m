classdef testFouriercoeffs < matlab.unittest.TestCase
    % vlt.unittest.math.testFouriercoeffs - Tests for the frequency labels of
    % vlt.math.fouriercoeffs and vlt.math.fouriercoeffs_2d
    %
    % FFT treats N samples as one period of length N*si, so bin n (0-based)
    % is at frequency n/(N*si).

    methods (Test)

        function testPeakFrequency(testCase)
            t = (0:99)/100;
            data = cos(2*pi*5*t);
            [fc, freqs] = vlt.math.fouriercoeffs(data, 0.01);
            [~, peak] = max(abs(fc(1:50)));
            testCase.verifyEqual(peak, 6);
            testCase.verifyEqual(freqs(peak), 5, 'AbsTol', 1e-10);
            testCase.verifyEqual(abs(fc(peak)), 1, 'AbsTol', 1e-10);
        end

        function testFrequencySpacing(testCase)
            si = 0.001;
            N = 3000;
            [~, freqs] = vlt.math.fouriercoeffs(rand(1,N), si);
            testCase.verifyEqual(numel(freqs), N);
            testCase.verifyEqual(freqs(1), 0);
            testCase.verifyEqual(freqs(2), 1/(N*si), 'AbsTol', 1e-10);
            testCase.verifyEqual(diff(freqs), repmat(1/(N*si),1,N-1), 'AbsTol', 1e-9);
        end

        function test2dFrequencyAxes(testCase)
            % even number of rows, odd number of columns
            pixelsize = 0.01;
            M = 8;
            N = 5;
            [~, FX, FY] = vlt.math.fouriercoeffs_2d(rand(M,N), pixelsize);
            testCase.verifyEqual(FX(1,:), (-2:2)/(N*pixelsize), 'AbsTol', 1e-10);
            testCase.verifyEqual(FY(:,1), (-4:3)'/(M*pixelsize), 'AbsTol', 1e-10);
        end

        function test2dPeakFrequency(testCase)
            pixelsize = 0.001;
            x = (0:999)*pixelsize; % 1 meter, without repeating the endpoint
            [X1, X2] = meshgrid(x, x);
            X = 1 + 0.5*sin(2*pi*3*X1);
            [Y, FX, FY] = vlt.math.fouriercoeffs_2d(X, pixelsize);
            nonDC = ~(FX==0 & FY==0);
            [~, peak] = max(abs(Y(:)).*nonDC(:));
            testCase.verifyEqual(abs(FX(peak)), 3, 'AbsTol', 1e-10);
            testCase.verifyEqual(FY(peak), 0, 'AbsTol', 1e-10);
            testCase.verifyEqual(abs(Y(peak)), 0.5, 'AbsTol', 1e-10);
            testCase.verifyEqual(real(Y(FX==0 & FY==0)), 1, 'AbsTol', 1e-10);
        end

    end
end
