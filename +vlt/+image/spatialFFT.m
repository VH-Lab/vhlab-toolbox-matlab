function [spatialFrequency, spatialFrequencyAmp] = spatialFFT(image, meters_per_pixel, options)
% SPATIALFFT - Computes a 1D spatial frequency profile from a 2D image.
%
%   [SF, SF_AMP] = vlt.image.spatialFFT(IMAGE, METERS_PER_PIXEL)
%   [SF, SF_AMP] = vlt.image.spatialFFT(IMAGE, METERS_PER_PIXEL, 'mask', MASK)
%
%   Calculates a 1D, orientation-independent spatial frequency profile from a
%   2D image. This is achieved by taking the 2D Fourier Transform of the image
%   and then performing a radial average of the resulting amplitude spectrum.
%
%   Inputs:
%     IMAGE           - A 2D matrix (e.g., an image) of double-precision values.
%                       Any NaN values in the image will be replaced by 0
%                       before the FFT, which preserves the DC component.
%     METERS_PER_PIXEL- A scalar value indicating the physical size of each
%                       pixel in meters. This is used to correctly scale the
%                       frequency axis.
%
%   Name-Value Pairs:
%     'mask'          - A logical or numeric matrix of the same size as IMAGE.
%                       Pixels where the mask is `false` or 0 are set to 0
%                       and excluded from the analysis.
%
%   Outputs:
%     spatialFrequency    - A 1D vector representing the spatial frequency axis
%                           in units of cycles per meter.
%     spatialFrequencyAmp - A 1D vector containing the corresponding mean
%                           amplitude for each spatial frequency.
%
%   Example:
%     % Create a sample image with a known frequency
%     [x, ~] = meshgrid(1:256);
%     img = sin(2 * pi * 10 * x / 256); % 10 cycles in 256 pixels
%     m_per_pix = 1e-3; % 1 mm per pixel
%     [sf, amp] = vlt.image.spatialFFT(img, m_per_pix);
%     figure;
%     plot(sf, amp, 'o-');
%     xlabel('Spatial Frequency (cycles/meter)');
%     ylabel('Amplitude');
%     title('1D Spatial frequency Profile');
%

% --- Input Validation ---
arguments
    image (:,:) {mustBeNumeric}
    meters_per_pixel (1,1) {mustBeNumeric, mustBePositive}
    options.mask (:,:)
end

% --- Pre-processing ---
% Apply the optional mask. Pixels where the mask is false are set to NaN.
if isfield(options, 'mask')
    options.mask = logical(options.mask); % Cast to logical
    if ~isequal(size(image), size(options.mask))
        error('Image and mask must have the same dimensions.');
    end
    image(~options.mask) = NaN;
end

% Handle any NaN values (either original or from the mask) to prevent them
% from affecting the FFT. Replacing with 0 correctly preserves the DC
% component (the sum of the original pixels).
if any(isnan(image), 'all')
    image(isnan(image)) = 0;
end

% --- 2D Fourier Transform ---
% 1. Compute the 2D FFT of the image.
% 2. Shift the zero-frequency component to the center.
% 3. Take the absolute value to get the amplitude spectrum.
F = fftshift(fft2(image));
amplitude_spectrum = abs(F);

% --- Prepare for Radial Averaging ---
[rows, cols] = size(image);
center_y = floor(rows / 2) + 1;
center_x = floor(cols / 2) + 1;

% Create coordinate grids
[X, Y] = meshgrid(1:cols, 1:rows);
% Calculate the radial distance of each pixel from the center
radial_dist = sqrt((X - center_x).^2 + (Y - center_y).^2);

% --- Radial Averaging ---
% Bin the radial distances (as integers)
radial_bins = floor(radial_dist(:)) + 1;

% Use accumarray to efficiently calculate the mean amplitude for each radial bin
% This is the core of the radial averaging process.
max_bin = max(radial_bins);
spatialFrequencyAmp = accumarray(radial_bins, amplitude_spectrum(:), [max_bin 1], @mean);

% The number of bins is determined by the maximum integer radius
num_bins = numel(spatialFrequencyAmp);

% --- Frequency Axis Scaling ---
% Calculate the sampling frequency in meters
sampling_freq = 1 / meters_per_pixel;
% The frequency resolution is the sampling frequency divided by the number of samples
% We use the mean image dimension as an effective number of samples.
freq_resolution = sampling_freq / mean([rows, cols]);

% Create the spatial frequency axis
spatialFrequency = (0:(num_bins-1))' * freq_resolution;

end

