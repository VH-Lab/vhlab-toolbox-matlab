function [spatialFrequency, spatialPower] = spatialPowerSpectralDensity(image, meters_per_pixel, options)
% SPATIALPOWERSPECTRALDENSITY - Computes a 1D radially averaged power spectrum.
%
%   [SF, SF_POWER] = vlt.image.spatialPowerSpectralDensity(IMAGE, METERS_PER_PIXEL, ...)
%
%   Calculates a 1D, orientation-independent power spectrum from a 2D image.
%
%   Inputs:
%     IMAGE           - A 2D matrix of double-precision values. NaN values
%                       will be replaced by 0 before the FFT.
%     METERS_PER_PIXEL- The physical size of each pixel in meters.
%
%   Name-Value Pairs:
%     'mask'          - A logical matrix of the same size as IMAGE. Pixels
%                       where the mask is `false` are excluded.
%     'window'        - A string specifying the windowing function to apply
%                       before the FFT to reduce boundary artifacts. Can be
%                       'hanning' (default) or 'none'.
%     'fft_padding_factor' - A scalar >= 1 that increases the frequency
%                       resolution by zero-padding the image. A value of 2
%                       doubles the resolution. (Default: 1, no padding).
%
%   Outputs:
%     spatialFrequency - A 1D vector of the spatial frequency axis (cycles/meter).
%     spatialPower     - A 1D vector of the mean power for each frequency.
%

% --- Input Validation and Defaults ---
arguments
    image (:,:) {mustBeNumeric}
    meters_per_pixel (1,1) {mustBeNumeric, mustBePositive}
    options.mask (:,:)
    options.window {mustBeMember(options.window, {'hanning', 'none'})} = 'hanning'
    options.fft_padding_factor (1,1) {mustBeNumeric, mustBeGreaterThanOrEqual(options.fft_padding_factor, 1)} = 1
end

% --- Pre-processing ---
if isfield(options, 'mask')
    options.mask = logical(options.mask); % Cast to logical
    if ~isequal(size(image), size(options.mask))
        error('Image and mask must have the same dimensions.');
    end
    image(~options.mask) = NaN;
end

if any(isnan(image), 'all')
    image(isnan(image)) = 0;
end

[rows, cols] = size(image);

% --- Windowing (to reduce boundary artifacts) ---
if strcmp(options.window, 'hanning')
    hanning_window = hanning(rows) * hanning(cols)';
    image = image .* hanning_window;
end

% --- Zero-Padding (for increased frequency resolution) ---
if options.fft_padding_factor > 1
    new_rows = round(rows * options.fft_padding_factor);
    new_cols = round(cols * options.fft_padding_factor);
    
    padded_image = zeros(new_rows, new_cols);
    
    % Calculate start indices to center the original image
    start_row = floor((new_rows - rows) / 2) + 1;
    start_col = floor((new_cols - cols) / 2) + 1;
    
    % Embed the image
    padded_image(start_row:start_row+rows-1, start_col:start_col+cols-1) = image;
    image = padded_image; % Use the padded image for the rest of the analysis
end

[rows, cols] = size(image); % Update dimensions if padding was applied

% --- 2D Power Spectrum ---
F = fftshift(fft2(image));
power_spectrum = abs(F).^2; % Calculate POWER, not amplitude

% --- Prepare for Radial Averaging ---
center_y = floor(rows / 2) + 1;
center_x = floor(cols / 2) + 1;

[X, Y] = meshgrid(1:cols, 1:rows);
radial_dist = sqrt((X - center_x).^2 + (Y - center_y).^2);

% --- Radial Averaging of Power ---
radial_bins = floor(radial_dist(:)) + 1;
max_bin = max(radial_bins);
% Use accumarray to efficiently calculate the mean power for each radial bin
spatialPower = accumarray(radial_bins, power_spectrum(:), [max_bin 1], @mean);
num_bins = numel(spatialPower);

% --- Frequency Axis Scaling ---
sampling_freq = 1 / meters_per_pixel;
% The frequency resolution is now determined by the (potentially padded) image size
freq_resolution = sampling_freq / mean([rows, cols]);
spatialFrequency = (0:(num_bins-1))' * freq_resolution;

end

