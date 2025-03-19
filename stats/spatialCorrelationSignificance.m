function [p, r_observed, r_null_distribution] = spatialCorrelationSignificance(indexA, indexB, options)
% SPATIALCORRELATIONSIGNIFICANCE Estimate significance of correlation between two spatial index maps
%
% This function estimates the significance of correlation between two spatial index maps
% (indexA and indexB) while accounting for spatial autocorrelation. It uses toroidal
% shifts (random X/Y offsets) of indexB to create a null distribution of correlation
% values that preserves the spatial structure of the data.
%
% Syntax:
%   [p, r_observed, r_null_distribution] = spatialCorrelationSignificance(indexA, indexB)
%   [p, r_observed, r_null_distribution] = spatialCorrelationSignificance(indexA, indexB, options)
%
% Inputs:
%   indexA          - 2D matrix containing the first index values (e.g., response to stimulus A)
%   indexB          - 2D matrix containing the second index values (e.g., response to stimulus B)
%   options         - Structure with optional parameters:
%       .mask           - Logical 2D matrix specifying pixels to include (default: all pixels)
%       .n_permutations - Number of random toroidal shifts to perform (default: 1000)
%       .max_shift     - Maximum allowed shift in pixels (default: size(indexA)/2)
%       .alpha         - Significance level (default: 0.05)
%       .plot_results  - Logical flag to generate summary plot (default: false)
%
% Outputs:
%   p                 - p-value for the observed correlation
%   r_observed        - Observed correlation coefficient between indexA and indexB
%   r_null_distribution - Vector of correlation values from the null distribution
%
% Example:
%   % Generate sample data
%   indexA = randn(50, 50);
%   indexB = indexA*0.3 + randn(50, 50)*0.9; % Related but noisy
%   
%   % Set options
%   plot_results = true;
%   n_permutations = 2000; % Increase number of permutations
%   mask = indexA > -1; % Example: custom mask based on data values
%   
%   % Estimate significance
%   [p, r_obs, r_null] = spatialCorrelationSignificance(indexA, indexB, ...
%      'plot_results',plot_results,'n_permutations',n_permutations,...
%      'mask',mask);
%   fprintf('Observed correlation: %.3f, p-value: %.3f\n', r_obs, p);
%
% Notes:
%   - Both index maps must be the same size
%   - The function uses toroidal shifts (wrapping around edges) to maintain the
%     spatial autocorrelation structure in the permutation test
%   - NaN values in either index map will be excluded from analysis
%
% See also: CORRCOEF, CIRCSHIFT

% Input validation and parsing
arguments
    indexA (:,:) double {mustBeNumeric}
    indexB (:,:) double {mustBeNumeric}
    options.mask (:,:) logical = []
    options.n_permutations (1,1) {mustBeInteger, mustBePositive} = 1000
    options.max_shift = []
    options.alpha (1,1) double {mustBeInRange(options.alpha, 0, 1)} = 0.05
    options.plot_results (1,1) logical = false
end

% Set default mask if not provided
if isempty(options.mask)
    mask = true(size(indexA));
else
    mask = options.mask;
end

% Get number of permutations from options
n_permutations = options.n_permutations;

% Validate input dimensions
if ~isequal(size(indexA), size(indexB))
    error('indexA and indexB must have the same dimensions');
end

if ~isempty(mask) && ~isequal(size(indexA), size(mask))
    error('mask must have the same dimensions as indexA and indexB');
end

% Set default max shift if not provided
if isempty(options.max_shift)
    max_shift = floor(size(indexA) / 2);
else
    max_shift = options.max_shift;
    if numel(max_shift) == 1
        max_shift = [max_shift, max_shift];
    end
end

% Extract values using the mask
validPixels = mask & ~isnan(indexA) & ~isnan(indexB);
if sum(validPixels(:)) < 5
    error('Too few valid pixels for analysis (minimum 5 required)');
end

% Calculate observed correlation
A_valid = indexA(validPixels);
B_valid = indexB(validPixels);
r_observed_matrix = corrcoef(A_valid, B_valid);
r_observed = r_observed_matrix(1, 2); % Extract the correlation coefficient

% Initialize storage for null distribution
r_null_distribution = zeros(n_permutations, 1);

% Create random X/Y shift combinations for toroidal shifts
max_x_shift = max_shift(1);
max_y_shift = max_shift(2);
x_shifts = randi([-max_x_shift, max_x_shift], n_permutations, 1);
y_shifts = randi([-max_y_shift, max_y_shift], n_permutations, 1);

% Perform permutation test using toroidal shifts
for i = 1:n_permutations
    % Create shifted version of indexB
    shifted_B = circshift(indexB, [y_shifts(i), x_shifts(i)]);
    
    % Extract valid values with the mask
    % We need to shift the mask along with B to ensure consistent masking
    shifted_mask = circshift(mask, [y_shifts(i), x_shifts(i)]);
    
    % Only include pixels that are valid in both the original mask and the shifted mask
    shifted_valid_pixels = mask & shifted_mask & ~isnan(indexA) & ~isnan(shifted_B);
    A_valid_shifted = indexA(shifted_valid_pixels);
    B_valid_shifted = shifted_B(shifted_valid_pixels);
    
    % Skip if too few valid pixels after shift
    if length(A_valid_shifted) < 5
        r_null_distribution(i) = NaN;
        continue;
    end
    
    % Calculate correlation for this permutation
    r_null_matrix = corrcoef(A_valid_shifted, B_valid_shifted);
    r_null_distribution(i) = r_null_matrix(1, 2);
end

% Remove any NaN values from null distribution
r_null_distribution = r_null_distribution(~isnan(r_null_distribution));
if isempty(r_null_distribution)
    error('All permutations resulted in invalid correlations. Check your data and mask.');
end

% Calculate two-tailed p-value
if r_observed >= 0
    p = mean(abs(r_null_distribution) >= abs(r_observed));
else
    p = mean(-abs(r_null_distribution) <= r_observed);
end

% Create visualization if requested
if options.plot_results
    figure('Position', [100, 100, 1000, 400]);
    
    % Plot 1: Histogram of null distribution
    subplot(1, 3, 1);
    histogram(r_null_distribution, 30, 'EdgeColor', 'none', 'FaceColor', [0.4 0.4 0.4]);
    hold on;
    xline(r_observed, 'r-', 'LineWidth', 2);
    xlim([-1, 1]);
    title('Null Distribution of Correlation');
    xlabel('Correlation Coefficient');
    ylabel('Frequency');
    legend({'Null Distribution', 'Observed'});
    
    % Plot 2: Scatter plot of original data
    subplot(1, 3, 2);
    scatter(A_valid, B_valid, 20, 'filled', 'MarkerFaceAlpha', 0.5);
    hold on;
    
    % Add regression line
    x_range = linspace(min(A_valid), max(A_valid), 100);
    p_fit = polyfit(A_valid, B_valid, 1);
    y_fit = polyval(p_fit, x_range);
    plot(x_range, y_fit, 'r-', 'LineWidth', 2);
    
    title(sprintf('Original Data (r = %.3f, p = %.3f)', r_observed, p));
    xlabel('Index A');
    ylabel('Index B');
    grid on;
    
    % Plot 3: Display index maps
    subplot(1, 3, 3);
    
    % Create RGB visualization where:
    % - Red channel = indexA (normalized)
    % - Green channel = indexB (normalized)
    % - Blue channel = zeros
    
    % Normalize data to [0,1] for visualization
    indexA_norm = zeros(size(indexA));
    indexA_norm(validPixels) = normalize_to_range(indexA(validPixels));
    
    indexB_norm = zeros(size(indexB));
    indexB_norm(validPixels) = normalize_to_range(indexB(validPixels));
    
    % Create RGB image
    rgb_img = cat(3, indexA_norm, indexB_norm, zeros(size(indexA)));
    
    % Apply mask
    rgb_img = rgb_img .* cat(3, double(mask), double(mask), double(mask));
    
    % Display image
    imagesc(rgb_img);
    axis image;
    title('Index Maps Visualization');
    colorbar('Ticks', [0, 1], 'TickLabels', {'Low', 'High'});
    
    % Add color legend
    text(size(indexA, 2)*0.75, size(indexA, 1)*0.1, 'Red = Index A', 'Color', 'r', 'FontWeight', 'bold');
    text(size(indexA, 2)*0.75, size(indexA, 1)*0.15, 'Green = Index B', 'Color', 'g', 'FontWeight', 'bold');
    text(size(indexA, 2)*0.75, size(indexA, 1)*0.2, 'Yellow = Both', 'Color', [0.8 0.8 0], 'FontWeight', 'bold');
    
    sgtitle(sprintf('Correlation Significance Analysis (p = %.4f)', p));
end

end

% Helper function to normalize data to [0,1] range
function normalized = normalize_to_range(data, new_min, new_max)
    if nargin < 2
        new_min = 0;
        new_max = 1;
    end
    
    data_min = min(data);
    data_max = max(data);
    
    if data_max == data_min
        normalized = zeros(size(data)) + 0.5;
    else
        normalized = (data - data_min) / (data_max - data_min) * (new_max - new_min) + new_min;
    end
end

