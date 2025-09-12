function [spatialFrequency, power_distribution] = spatialPowerSpectralDensityNull(image, options)
% SPATIALPOWERSPECTRALDENSITYNULL - Generates a null distribution for a 1D power spectrum.
%
%   [SF, POWER_DIST] = vlt.image.spatialPowerSpectralDensityNull(IMAGE, Name, Value, ...)
%
%   Calculates a null distribution for a 1D radially-averaged power spectrum
%   by using phase randomization. This method creates surrogate images that have
%   the same power spectrum as the original image but with all spatial structure
%   destroyed. This function uses the Parallel Computing Toolbox.
%
%   Inputs:
%     IMAGE          - A 2D matrix (e.g., an image) of double-precision values.
%
%   Name-Value Pairs:
%     'num_shuffles'  - The number of surrogate images to generate for the
%                       null distribution. (Default: 1000)
%     'meters_per_pixel' - The physical size of each pixel in meters.
%                       (Default: 1)
%     'mask'          - A logical matrix of the same size as IMAGE. Pixels
%                       where the mask is `false` are excluded.
%     'window'        - Windowing function to apply. ('hanning' or 'none').
%                       (Default: 'hanning')
%     'fft_padding_factor' - Factor to increase FFT resolution. (Default: 1)
%     'verbose'       - If true, prints progress every 10 simulations.
%                       (Default: true)
%
%   Outputs:
%     spatialFrequency - A 1D vector of the spatial frequency axis (cycles/meter).
%     power_distribution - A [num_freq_bins x num_shuffles] matrix where each
%                          column is the 1D power spectrum of a single
%                          phase-randomized surrogate image.
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

if any(isnan(original_image), 'all')
    original_image(isnan(original_image)) = 0;
end

% --- 2. Prepare for Phase Randomization ---
F_original = fft2(original_image);
magnitude_original = abs(F_original);

% --- 3. Pre-calculate output size for parfor ---
% To pre-allocate, we need to know the size of the output frequency vector.
% We can get this by running the analysis on a single surrogate image first.
if options.verbose, disp('Pre-calculating output size for parallel execution...'); end
[spatialFrequency, ~] = vlt.image.spatialPowerSpectralDensity(original_image, ...
    options.meters_per_pixel, ...
    'mask', options.mask, ...
    'window', options.window, ...
    'fft_padding_factor', options.fft_padding_factor);

% Pre-allocate the full results matrix, as required by parfor
power_distribution = zeros(numel(spatialFrequency), options.num_shuffles);

% --- 4. Build the Null Distribution in Parallel ---
if options.verbose
    disp(['Generating ' num2str(options.num_shuffles) ' surrogate images in parallel...']);
end

parfor i = 1:options.num_shuffles
    % Create a random phase matrix with the correct conjugate symmetry
    random_noise = rand(size(original_image));
    F_noise = fft2(random_noise);
    phase_noise = angle(F_noise);
    
    % Combine the original magnitude with the random phase
    F_surrogate = magnitude_original .* exp(1i * phase_noise);
    
    % Inverse transform to get the surrogate image in the spatial domain
    surrogate_image = real(ifft2(F_surrogate));
    
    % Calculate the power spectrum for the surrogate
    [sf_temp, current_power] = vlt.image.spatialPowerSpectralDensity(surrogate_image, ...
        options.meters_per_pixel, ...
        'mask', options.mask, ...
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

