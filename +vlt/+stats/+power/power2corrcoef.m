function p = power2corrcoef(sample1, sample2, correlations, options)
% VLT.STATS.POWER.POWER2CORRCOEF - Calculate statistical power for a correlation test by simulation
%
%   P = VLT.STATS.POWER.POWER2CORRCOEF(SAMPLE1, SAMPLE2, CORRELATIONS, ...)
%
%   Calculates the statistical power of a correlation test by simulation.
%
%   This function assesses the probability of correctly detecting a significant
%   correlation of a specified magnitude. For each target correlation value in
%   the `correlations` vector, it runs multiple simulations. In each simulation,
%   it generates new data by re-pairing `sample1` and `sample2` to have that
%   target rank correlation, and then performs a statistical test to see if a
%   significant correlation is found. The fraction of simulations that yield a
%   significant result is the estimated power.
%
%   This method preserves the exact marginal distributions of the original samples.
%
%   Inputs:
%   - SAMPLE1: A numerical vector of samples.
%   - SAMPLE2: A numerical vector of samples, same size as SAMPLE1.
%   - CORRELATIONS: A vector of target correlation coefficients to examine.
%
%   Optional Name-Value Pairs:
%   - 'test' ('corrcoef' | 'corrcoefResample'): The statistical test to use.
%     'corrcoef' uses MATLAB's built-in `corr` function (t-test based).
%     'corrcoefResample' uses `vlt.stats.corrcoefResample` for a permutation-based test.
%     Default is 'corrcoef'.
%   - 'alpha' (0 < alpha < 1): The significance level. Default is 0.05.
%   - 'numSimulations' (integer > 0): The number of simulations. Default is 1000.
%   - 'resampleNum' (integer > 0): Number of resamples for 'corrcoefResample'. Default is 1000.
%   - 'verbose' (logical): If true, displays progress. Default is true.
%   - 'plot' (logical): If true, plots the power curve. Default is true.
%   - 'titleText' (string): The title for the plot.
%   - 'xLabel' (string): The x-axis label for the plot.
%   - 'yLabel' (string): The y-axis label for the plot.
%
%   Output:
%   - P: A vector the same size as CORRELATIONS, indicating the fraction of
%     simulations where the test yielded a significant correlation.
%
%   Example:
%     % Generate some data and calculate power
%     sample1 = randn(1, 20);
%     sample2 = randn(1, 20);
%     correlations = -1:0.2:1;
%     p = vlt.stats.power.power2corrcoef(sample1, sample2, correlations, 'test', 'corrcoef');
%
%   See also: VLT.STATS.POWER.IMPOSECORRELATIONBYREORDERING, CORR, VLT.STATS.CORRCOEFRESAMPLE

arguments
    sample1 (1,:) double
    sample2 (1,:) double
    correlations (1,:) double {mustBeGreaterThanOrEqual(correlations,-1), mustBeLessThanOrEqual(correlations,1)}
    options.test {mustBeMember(options.test,{'corrcoef','corrcoefResample'})} = 'corrcoef'
    options.alpha (1,1) double {mustBeGreaterThan(options.alpha,0), mustBeLessThan(options.alpha,1)} = 0.05
    options.numSimulations (1,1) double {mustBeInteger, mustBeGreaterThan(options.numSimulations,0)} = 1000
    options.resampleNum (1,1) double {mustBeInteger, mustBeGreaterThan(options.resampleNum,0)} = 1000
    options.verbose (1,1) logical = true
    options.plot (1,1) logical = true
    options.titleText (1,1) string = "Power Analysis for Correlation"
    options.xLabel (1,1) string = "Imposed Correlation"
    options.yLabel (1,1) string = "Power"
end

if numel(sample1) ~= numel(sample2)
    error('SAMPLE1 and SAMPLE2 must have the same number of elements.');
end

p = zeros(size(correlations));

for i = 1:numel(correlations)
    if options.verbose
        disp(['Running correlation ' int2str(i) ' of ' int2str(numel(correlations)) ' (' num2str(correlations(i)) ').']);
    end

    significant_count = 0;
    for j = 1:options.numSimulations
        % Create a surrogate dataset with the desired correlation
        [sim_sample1, sim_sample2] = vlt.stats.power.imposeCorrelationByReordering(sample1, sample2, correlations(i));

        % Perform the statistical test
        p_val = NaN;
        switch options.test
            case 'corrcoef'
                [~, p_val_matrix] = corr(sim_sample1, sim_sample2);
                p_val = p_val_matrix(1,2);
            case 'corrcoefResample'
                p_val = vlt.stats.corrcoefResample(sim_sample1, sim_sample2, options.resampleNum);
        end

        if ~isnan(p_val) && p_val < options.alpha
            significant_count = significant_count + 1;
        end
    end
    p(i) = significant_count / options.numSimulations;
end

if options.plot
    figure;
    plot(correlations, p, 'bo-');
    hold on;
    plot(correlations, 1-options.alpha+0*p, 'k--');
    box off;
    title(options.titleText);
    xlabel(options.xLabel);
    ylabel(options.yLabel);
    legend('Simulated Power', 'Alpha', 'Location', 'best');
    ylim([0 1]);
end

end
