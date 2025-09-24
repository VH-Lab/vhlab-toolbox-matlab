function [spatialFrequency, power_distribution] = spatialPowerSpectralDensityNullShuffle(image, options)
% SPATIALPOWERSPECTRALDENSITYNULLSHUFFLE - Generates a null distribution for a 1D power spectrum by shuffling pixels.
%
%   [SF, POWER_DIST] = vlt.image.spatialPowerSpectralDensityNullShuffle(IMAGE, Name, Value, ...)
%
%   Calculates a null distribution for a 1D radially-averaged power spectrum
%   by shuffling the non-NaN pixels in the image. This method creates surrogate
%   images that have the same pixel intensity distribution as the original image,
%   but with the spatial structure destroyed. This function uses the Parallel
%   Computing Toolbox.
%
%   NaN values in the original image remain as NaN values in the surrogate images.
%
%   Inputs:
%     IMAGE          - A 2D matrix (e.g., an image) of double-precision values.
%
%   Name-Value Pairs:
%     'num_shuffles'  - The number of surrogate images to generate for the
%                       null distribution. (Default: 1000)
%     'meters_per_pixel' - The physical size of each pixel in meters. (Passed to
%                       vlt.image.spatialPowerSpectralDensity). (Default: 1)
%     'mask'          - A logical matrix of the same size as IMAGE. Pixels
%                       where the mask is `false` are excluded (set to NaN).
%     'window'        - Windowing function to apply. (Passed to
%                       vlt.image.spatialPowerSpectralDensity). ('hanning' or 'none').
%                       (Default: 'hanning')
%     'fft_padding_factor' - Factor to increase FFT resolution. (Passed to
%                       vlt.image.spatialPowerSpectralDensity). (Default: 1)
%     'verbose'       - If true, prints progress every 10 simulations.
%                       (Default: true)
%
%   Outputs:
%     spatialFrequency - A 1D vector of the spatial frequency axis (cycles/meter).
%     power_distribution - A [num_freq_bins x num_shuffles] matrix where each
%                          column is the 1D power spectrum of a single
%                          pixel-shuffled surrogate image.
%

% --- Input Validation and Defaults ---
arguments
    image (:,:) {mustBeNumeric}
    options.num_shuffles (1,1) {mustBeInteger, mustBePositive} = 1000
    options.meters_per_pixel (1,1) {mustBeNumeric, mustBePositive} = 1
    options.mask (:,:)
    options.window {mustBeMember(options.window, {'hanning', 'none'})} = 'hanning'
    options.fft_padding_factor (1,1) {mustBeNumeric, mustBeGreaterThanOrEqual(options.fft_padding_factor, 1)} = 1
    options.verbose (1,1) logical = true
end

% --- 1. Pre-process the original image once ---
original_image = image; % Keep a copy
if isfield(options, 'mask')
    options.mask = logical(options.mask);
    if ~isequal(size(original_image), size(options.mask))
        error('Image and mask must have the same dimensions.');
    end
    original_image(~options.mask) = NaN;
end

% --- 2. Prepare for Shuffling ---
% Find the indices and values of the non-NaN pixels.
not_nan_indexes = find(~isnan(original_image));
not_nan_values = original_image(not_nan_indexes);

% --- 3. Pre-calculate output size for parfor ---
% To pre-allocate, we need to know the size of the output frequency vector.
% We can get this by running the analysis on a single surrogate image first.
if options.verbose, disp('Pre-calculating output size for parallel execution...'); end
[spatialFrequency, ~] = vlt.image.spatialPowerSpectralDensity(original_image, ...
    'meters_per_pixel', options.meters_per_pixel, ...
    'mask', ~isnan(original_image), ... % Use a mask of non-NaN values
    'window', options.window, ...
    'fft_padding_factor', options.fft_padding_factor);

% Pre-allocate the full results matrix, as required by parfor
power_distribution = zeros(numel(spatialFrequency), options.num_shuffles);

% --- 4. Build the Null Distribution in Parallel ---
if options.verbose
    disp(['Generating ' num2str(options.num_shuffles) ' surrogate images in parallel...']);
end

parfor i = 1:options.num_shuffles
    % Create a surrogate image by shuffling the non-NaN pixels
    shuffled_values = not_nan_values(randperm(numel(not_nan_values)));

    surrogate_image = nan(size(original_image));
    surrogate_image(not_nan_indexes) = shuffled_values;

    % Calculate the power spectrum for the surrogate
    [sf_temp, current_power] = vlt.image.spatialPowerSpectralDensity(surrogate_image, ...
        'meters_per_pixel', options.meters_per_pixel, ...
        'mask', ~isnan(surrogate_image), ...
        'window', options.window, ...
        'fft_padding_factor', options.fft_padding_factor);

    % Store the results in the pre-allocated matrix
    if numel(sf_temp) == numel(spatialFrequency)
        power_distribution(:, i) = current_power;
    else
        % Fallback to interpolation if sizes unexpectedly differ
        power_distribution(:, i) = interp1(sf_temp, current_power, spatialFrequency);
    end

    % Note: Verbose output inside a parfor loop can be unordered
    if options.verbose && mod(i, 10) == 0
        fprintf('    Simulation %d of %d completed...\n', i, options.num_shuffles);
    end
end

if options.verbose
    disp('...done.');
end

end