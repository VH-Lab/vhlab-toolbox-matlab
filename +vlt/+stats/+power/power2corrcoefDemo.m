function power2corrcoefDemo()
% POWER2CORRCOEFDEMO - Demonstrates the vlt.stats.power.power2corrcoef function
%
%   Calculates and plots the power of a correlation test for a range of
%   correlation coefficients using simulated data.
%
%   See also: VLT.STATS.POWER.POWER2CORRCOEF
%

% --- 1. Define Simulation Parameters ---
n_samples = 30;         % Number of data points in each sample
correlations = -1:0.1:1; % Range of correlations to test
num_simulations = 500;  % Number of simulations per correlation value (lower for faster demo)

% --- 2. Generate Sample Data ---
% Create two independent, normally distributed datasets.
% The power analysis will assess the ability to detect correlations
% imposed on data with these marginal distributions.
sample1 = randn(1, n_samples);
sample2 = randn(1, n_samples);

% --- 3. Run Power Analysis using 'corrcoef' (Standard t-test based) ---
disp("Running power analysis using 'corrcoef' (standard t-test based)...");
p_corr = vlt.stats.power.power2corrcoef(sample1, sample2, correlations, ...
    'test', 'corrcoef', ...
    'numSimulations', num_simulations, ...
    'plot', true, ...
    'titleText', "Power of Standard Correlation Test (corrcoef)", ...
    'verbose', true);

% --- 4. Run Power Analysis using 'corrcoefResample' (Permutation test) ---
% Note: This will be slower due to the nested resampling.
disp(" ");
disp("Running power analysis using 'corrcoefResample' (permutation test)...");
p_resample = vlt.stats.power.power2corrcoef(sample1, sample2, correlations, ...
    'test', 'corrcoefResample', ...
    'numSimulations', num_simulations, ...
    'resampleNum', 500, ... % Lower for faster demo
    'plot', true, ...
    'titleText', "Power of Resampled Correlation Test (corrcoefResample)", ...
    'verbose', true);

% --- 5. Plot Both Results on a Single Figure for Comparison ---
figure;
h1 = plot(correlations, p_corr, 'bo-', 'DisplayName', '`corrcoef` (t-test)');
hold on;
h2 = plot(correlations, p_resample, 'rs-', 'DisplayName', '`corrcoefResample`');
h3 = plot(correlations, 0.05 + 0*correlations, 'k--', 'DisplayName', 'Alpha (0.05)');
box off;
title(['Power Analysis Comparison (N=' num2str(n_samples) ')']);
xlabel('Imposed Correlation Coefficient');
ylabel('Statistical Power');
legend([h1, h2, h3], 'Location', 'southeast');
ylim([0 1.05]);
grid on;

disp(" ");
disp("Demo complete.");

end
