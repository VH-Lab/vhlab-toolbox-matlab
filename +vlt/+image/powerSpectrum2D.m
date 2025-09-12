function results = powerSpectrum2D(image, options)
% POWERSPECTRUM2D - Computes and analyzes the 2D power spectrum of an image.
%
%   RESULTS = vlt.image.powerSpectrum2D(IMAGE, Name, Value, ...)
%
%   Analyzes the spatial periodicity and orientation of patterns in a 2D image
%   by computing its 2D Power Spectral Density (PSD). This method is ideal for
%   quantifying repeating, non-circular patterns (like stripes or Turing patterns).
%
%   The function returns a structure with quantitative results and generates two
%   summary figures.
%
%   Inputs:
%     IMAGE          - A 2D matrix (e.g., an image) of double-precision values.
%
%   Name-Value Pairs:
%     'mm_per_pixel' - The physical size of a pixel in millimeters. Used for
%                      scaling the frequency axes. (Default: 1)
%     'angle_step'   - The step size in degrees for computing directional
%                      profiles of the power spectrum. (Default: 10)
%     'mask'         - A logical matrix of the same size as IMAGE. Pixels
%                      where the mask is `false` are excluded from the analysis.
%
%   Outputs:
%     RESULTS - A structure containing the analysis results:
%       .psd_2d              - The 2D Power Spectral Density image.
%       .spatial_freq_radial - Frequency axis for the radial average (cycles/mm).
%       .psd_radial_avg      - The 1D radially averaged power spectrum.
%       .peak_spatial_freq   - The dominant spatial frequency in the image (cycles/mm).
%       .peak_orientation    - The dominant orientation of the pattern in degrees.
%       .angles              - Angles used for the directional profiles (degrees).
%       .directional_profiles- A cell array of the 1D power profiles for each angle.
%       .directional_dist_ax - The distance axis for the directional profiles.
%

% --- Input Validation and Defaults ---
arguments
    image (:,:) {mustBeNumeric}
    options.mm_per_pixel (1,1) {mustBeNumeric, mustBePositive} = 1
    options.angle_step (1,1) {mustBeNumeric, mustBePositive} = 10
    options.mask (:,:)
end

% --- 1. Pre-processing ---
if isfield(options, 'mask')
    options.mask = logical(options.mask);
    if ~isequal(size(image), size(options.mask))
        error('Image and mask must have the same dimensions.');
    end
    image(~options.mask) = NaN;
end

% Set NaN values to the mean of the valid pixels to minimize their impact.
if any(isnan(image), 'all')
    mean_val = mean(image(isfinite(image)), 'all');
    image(isnan(image)) = mean_val;
end

% --- 2. Compute 2D Power Spectral Density ---
F = fftshift(fft2(image));
psd_2d = abs(F).^2;

[rows, cols] = size(image);
center_y = floor(rows / 2) + 1;
center_x = floor(cols / 2) + 1;

% --- 3. Quantify the Spectrum: Find Peak Frequency and Orientation ---
% Temporarily remove the DC component (zero-frequency) to find the peak AC frequency
psd_no_dc = psd_2d;
psd_no_dc(center_y, center_x) = 0;
[~, max_idx] = max(psd_no_dc(:));
[peak_y, peak_x] = ind2sub(size(psd_2d), max_idx);

% Calculate the radial distance of the peak from the center
peak_radius_pixels = sqrt((peak_y - center_y)^2 + (peak_x - center_x)^2);

% Convert pixel distance to spatial frequency
sampling_freq_mm = 1 / options.mm_per_pixel;
freq_resolution_mm = sampling_freq_mm / mean([rows, cols]);
peak_spatial_freq = peak_radius_pixels * freq_resolution_mm;

% Calculate the orientation of the pattern
peak_orientation = atan2d(peak_y - center_y, peak_x - center_x);
% Adjust angle to be within [0, 180) as spectrum is symmetric
if peak_orientation < 0, peak_orientation = peak_orientation + 180; end

% --- 4. Compute 1D Radial Average ---
[sf_rad, psd_rad_avg] = vlt.image.spatialFFT(image, options.mm_per_pixel*1000, 'mask', ~isnan(image));
% Convert spatialFFT output from cycles/meter to cycles/mm
spatial_freq_radial = sf_rad / 1000;

% --- 5. Compute Directional Profiles ---
angles = 0:options.angle_step:180-options.angle_step;
directional_profiles = cell(numel(angles), 1);
max_radius = min(center_y, center_x) - 1;

for i = 1:numel(angles)
    angle_rad = deg2rad(angles(i));
    x_coords = center_x + (-max_radius:max_radius) * cos(angle_rad);
    y_coords = center_y + (-max_radius:max_radius) * sin(angle_rad);
    directional_profiles{i} = improfile(psd_2d, x_coords, y_coords, 'bilinear');
end
directional_dist_ax = (-max_radius:max_radius)' * freq_resolution_mm;

% --- 6. Assemble Output Structure ---
results = struct(...
    'psd_2d', psd_2d, ...
    'spatial_freq_radial', spatial_freq_radial, ...
    'psd_radial_avg', psd_rad_avg, ...
    'peak_spatial_freq', peak_spatial_freq, ...
    'peak_orientation', peak_orientation, ...
    'angles', {angles}, ...
    'directional_profiles', {directional_profiles}, ...
    'directional_dist_ax', directional_dist_ax ...
);

% --- 7. Generate Plots ---
% Figure 1: 2D Power Spectrum
figure;
freq_x_axis = (-center_x+1:cols-center_x) * freq_resolution_mm;
freq_y_axis = (-center_y+1:rows-center_y) * freq_resolution_mm;
imagesc(freq_x_axis, freq_y_axis, log(psd_2d));
colormap(parula);
axis image;
hold on;
% Mark the peak frequency
plot( (peak_x - center_x) * freq_resolution_mm, ...
      (peak_y - center_y) * freq_resolution_mm, ...
      'r+', 'MarkerSize', 12, 'LineWidth', 2);
title('2D Power Spectrum (log scale)');
xlabel('Spatial Frequency (cycles/mm)');
ylabel('Spatial Frequency (cycles/mm)');
colorbar;

% Figure 2: Directional Profiles
figure;
plot(directional_dist_ax, cat(2, directional_profiles{:}));
grid on;
title('Directional Power Profiles');
xlabel('Spatial Frequency (cycles/mm)');
ylabel('Power');
legend(arrayfun(@(a) [num2str(a) ' deg'], angles, 'UniformOutput', false));

end
