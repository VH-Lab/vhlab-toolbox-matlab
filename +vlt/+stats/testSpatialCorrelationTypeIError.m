function results = testSpatialCorrelationTypeIError(options)
% TESTSPATIALCORRELATIONTYPEIERROR Test Type I error rates for spatial correlation methods
%
% This function tests the Type I error rate (false positive rate) of the
% spatialCorrelationSignificance function compared to traditional correlation tests
% by generating spatially autocorrelated but statistically independent image pairs.
%
% Syntax:
%   results = testSpatialCorrelationTypeIError()
%   results = testSpatialCorrelationTypeIError(options)
%
% Inputs:
%   options - Structure with optional parameters:
%     .image_size      - Size of test images [height, width] (default: [200, 200])
%     .autocorr_range  - Vector of autocorrelation lengths to test (default: 1:5:50)
%     .n_iterations    - Number of random iterations per autocorrelation value (default: 100)
%     .alpha           - Significance threshold (default: 0.05)
%     .n_permutations  - Number of permutations for spatialCorrelationSignificance (default: 1000)
%     .generate_plots  - Whether to generate plots (default: true)
%     .verbose         - Display progress updates (default: true)
%
% Outputs:
%   results              - Structure containing test results with fields:
%       .autocorr_sizes  - Tested autocorrelation sizes
%       .type1_corrcoef  - Type I error rates for standard corrcoef
%       .type1_spatial   - Type I error rates for spatialCorrelationSignificance
%       .correlation_values - Mean correlation values for each autocorr size
%
% Example:
%   % Run test with default parameters
%   results = testSpatialCorrelationTypeIError();
%
%   % Run test with custom parameters
%   options.image_size = [100, 100];
%   options.autocorr_range = [1, 5, 10, 20, 30];
%   options.n_iterations = 50;
%   results = testSpatialCorrelationTypeIError(options);
%
% Notes:
%   - This function generates pairs of spatially autocorrelated images that are 
%     statistically independent (null hypothesis is true)
%   - Type I error rate should ideally be at the specified alpha level
%   - Traditional corrcoef typically shows inflated Type I errors with 
%     spatial autocorrelation
%   - The spatialCorrelationSignificance method should maintain proper 
%     Type I error control
%
% See also: SPATIALCORRELATIONSIGNIFICANCE, CORRCOEF

% Parse inputs using arguments block
arguments
    options.image_size (1,2) double {mustBePositive, mustBeInteger} = [200, 200]
    options.autocorr_range (1,:) double {mustBePositive} = 1:5:50
    options.n_iterations (1,1) double {mustBePositive, mustBeInteger} = 100
    options.alpha (1,1) double {mustBeInRange(options.alpha, 0, 1)} = 0.05
    options.n_permutations (1,1) double {mustBePositive, mustBeInteger} = 1000
    options.generate_plots (1,1) logical = true
    options.verbose (1,1) logical = true
end

% Extract parameters from options
image_size = options.image_size;
autocorr_range = options.autocorr_range;
n_iterations = options.n_iterations;
alpha = options.alpha;
n_permutations = options.n_permutations;
generate_plots = options.generate_plots;
verbose = options.verbose;

% Initialize results
n_autocorr = length(autocorr_range);
type1_corrcoef = zeros(1, n_autocorr);
type1_spatial = zeros(1, n_autocorr);
mean_corr_values = zeros(1, n_autocorr);

if verbose
    fprintf('Testing Type I error rates for spatial correlation methods\n');
    fprintf('Image size: %d x %d\n', image_size(1), image_size(2));
    fprintf('Testing %d autocorrelation lengths\n', n_autocorr);
    fprintf('Running %d iterations per autocorrelation length\n', n_iterations);
    fprintf('Alpha level: %.3f\n', alpha);
    fprintf('Permutations for spatial test: %d\n\n', n_permutations);
end

% Create progress bar if verbose
if verbose
    progress_interval = max(1, floor(n_autocorr/10));
    fprintf('Progress: ');
end

% Loop through autocorrelation sizes
for a_idx = 1:n_autocorr
    autocorr_size = autocorr_range(a_idx);
    
    % Display progress if verbose
    if verbose && (mod(a_idx, progress_interval) == 0 || a_idx == 1)
        fprintf('%d%% ', round(100 * (a_idx-1) / n_autocorr));
    end
    
    % Initialize counters for this autocorrelation size
    corrcoef_significant = 0;
    spatial_significant = 0;
    corr_values = zeros(n_iterations, 1);
    
    % Run multiple iterations
    for iter = 1:n_iterations
        % Generate two spatially autocorrelated but statistically independent images
        [indexA, indexB] = generateAutocorrelatedImages(image_size, autocorr_size);
        
        % Calculate standard correlation and p-value
        [R, P] = corrcoef(indexA(:), indexB(:));
        corr_values(iter) = R(1, 2);
        if P(1, 2) < alpha
            corrcoef_significant = corrcoef_significant + 1;
        end
        
        % Calculate spatial correlation p-value
        spatial_options.n_permutations = n_permutations;
        [p_spatial, ~, ~] = vlt.stats.spatialCorrelationSignificance(indexA, indexB, 'n_permutations', n_permutations);
        if p_spatial < alpha
            spatial_significant = spatial_significant + 1;
        end
    end
    
    % Calculate Type I error rates
    type1_corrcoef(a_idx) = corrcoef_significant / n_iterations;
    type1_spatial(a_idx) = spatial_significant / n_iterations;
    mean_corr_values(a_idx) = mean(abs(corr_values));
end

% Complete progress bar
if verbose
    fprintf('100%%\n');
end

% Store results
results = struct();
results.autocorr_sizes = autocorr_range;
results.type1_corrcoef = type1_corrcoef;
results.type1_spatial = type1_spatial;
results.correlation_values = mean_corr_values;

% Display summary if verbose
if verbose
    fprintf('\nSummary of Type I Error Rates:\n');
    fprintf('Expected error rate (alpha): %.3f\n', alpha);
    fprintf('Autocorr Size | Standard Correlation | Spatial Correlation\n');
    fprintf('------------------------------------------------------\n');
    for a_idx = 1:n_autocorr
        fprintf('%12d | %20.3f | %18.3f\n', autocorr_range(a_idx), ...
            type1_corrcoef(a_idx), type1_spatial(a_idx));
    end
    
    % Print mean error rates
    fprintf('------------------------------------------------------\n');
    fprintf('%12s | %20.3f | %18.3f\n', 'Mean', ...
        mean(type1_corrcoef), mean(type1_spatial));
    fprintf('\n');
end

% Generate plots if requested
if generate_plots
    % Create figure
    figure('Position', [100, 100, 1000, 700]);
    
    % Plot 1: Type I error rates
    subplot(2, 2, 1);
    plot(autocorr_range, type1_corrcoef, 'ro-', 'LineWidth', 1.5);
    hold on;
    plot(autocorr_range, type1_spatial, 'bo-', 'LineWidth', 1.5);
    % Add reference line for alpha
    line(xlim, [alpha, alpha], 'Color', 'k', 'LineStyle', '--');
    xlabel('Spatial Autocorrelation Size (pixels)');
    ylabel('Type I Error Rate');
    title('Type I Error Rate vs. Autocorrelation Size');
    legend({'Standard Correlation', 'Spatial Correlation', '\alpha threshold'}, ...
        'Location', 'best');
    grid on;
    
    % Plot 2: Ratio of error rates
    subplot(2, 2, 2);
    ratio = type1_corrcoef ./ max(type1_spatial, eps);
    semilogy(autocorr_range, ratio, 'ko-', 'LineWidth', 1.5);
    line(xlim, [1, 1], 'Color', 'k', 'LineStyle', '--');
    xlabel('Spatial Autocorrelation Size (pixels)');
    ylabel('Error Rate Ratio (Standard / Spatial)');
    title('Relative False Positive Rates');
    grid on;
    
    % Plot 3: Mean correlation values
    subplot(2, 2, 3);
    plot(autocorr_range, mean_corr_values, 'mo-', 'LineWidth', 1.5);
    xlabel('Spatial Autocorrelation Size (pixels)');
    ylabel('Mean |Correlation Value|');
    title('Mean Correlation Magnitude vs. Autocorrelation Size');
    grid on;
    
    % Plot 4: Example images at max autocorrelation
    subplot(2, 2, 4);
    [img1, img2] = generateAutocorrelatedImages(image_size, max(autocorr_range));
    
    % Create RGB visualization where:
    % - Red channel = normalized indexA
    % - Green channel = normalized indexB
    % - Blue channel = zeros
    
    % Normalize images to [0,1]
    img1_norm = (img1 - min(img1(:))) / (max(img1(:)) - min(img1(:)));
    img2_norm = (img2 - min(img2(:))) / (max(img2(:)) - min(img2(:)));
    
    % Create RGB composite
    rgb_img = cat(3, img1_norm, img2_norm, zeros(size(img1)));
    
    % Display image
    imagesc(rgb_img);
    axis image;
    title(sprintf('Example Images (Autocorr = %d px)', max(autocorr_range)));
    colorbar('Ticks', [0, 1], 'TickLabels', {'Low', 'High'});
    
    % Add color legend
    text(image_size(2)*0.75, image_size(1)*0.1, 'Red = Image A', 'Color', 'r', 'FontWeight', 'bold');
    text(image_size(2)*0.75, image_size(1)*0.15, 'Green = Image B', 'Color', 'g', 'FontWeight', 'bold');
    text(image_size(2)*0.75, image_size(1)*0.2, 'Yellow = Overlap', 'Color', [0.8 0.8 0], 'FontWeight', 'bold');
    
    % Set overall title
    sgtitle('Type I Error Analysis for Spatial Correlation Methods');
end

end

function [img1, img2] = generateAutocorrelatedImages(img_size, autocorr_size)
% Generate two spatially autocorrelated but statistically independent images
%
% Parameters:
%   img_size       - Size of images to generate [height, width]
%   autocorr_size  - Spatial autocorrelation length in pixels
%
% Returns:
%   img1, img2     - Two spatially autocorrelated but uncorrelated images

% For autocorr_size = 1, just return white noise (no autocorrelation)
if autocorr_size <= 1
    img1 = randn(img_size);
    img2 = randn(img_size);
    return;
end

% Create Gaussian kernel for spatial filtering
kernel_size = 2*autocorr_size + 1;
[x, y] = meshgrid(-autocorr_size:autocorr_size, -autocorr_size:autocorr_size);
kernel = exp(-(x.^2 + y.^2) / (2*autocorr_size^2));
kernel = kernel / sum(kernel(:)); % Normalize

% Generate white noise
noise1 = randn(img_size);
noise2 = randn(img_size);

% Apply spatial filtering to create autocorrelated noise
img1 = conv2(noise1, kernel, 'same');
img2 = conv2(noise2, kernel, 'same');

% Normalize to have unit variance
img1 = img1 / std(img1(:));
img2 = img2 / std(img2(:));
end
