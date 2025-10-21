function p = power2sample(sample1, sample2, differences, options)
% VLT.STATS.POWER2SAMPLE - Calculate statistical power for a 2-sample test by simulation
%
%   P = VLT.STATS.POWER2SAMPLE(SAMPLE1, SAMPLE2, DIFFERENCES, ...)
%
%   Calculates the statistical power of a 2-sample test by simulation.
%
%   Inputs:
%   - SAMPLE1: A vector of samples.
%   - SAMPLE2: A vector of samples.
%   - DIFFERENCES: A vector of differences to examine for power.
%
%   Optional Name-Value Pairs:
%   - 'test' ('ttest2' | 'kstest2' | 'ranksum' | 'pairedTTest'): The statistical test to use.
%     Default is 'ttest2'. For 'pairedTTest', the function uses the MATLAB function
%     ttest. Pairs where either value is NaN in the simulated data are removed
%     before the test is run.
%   - 'alpha' (0 < alpha < 1): The significance level. Default is 0.05.
%   - 'numSimulations' (integer > 0): The number of simulations. Default is 10000.
%   - 'verbose' (logical): If true, displays progress. Default is true.
%   - 'plot' (logical): If true, plots the power curve. Default is true.
%   - 'titleText' (string): The title for the plot.
%   - 'xLabel' (string): The x-axis label for the plot.
%   - 'yLabel' (string): The y-axis label for the plot.
%
%   Output:
%   - P: A vector the same size as DIFFERENCES, indicating the fraction of
%     simulations where the test yielded a significant difference.
%
%   Example:
%     % Generate some data and calculate power
%     sample1 = randn(1, 10);
%     sample2 = randn(1, 10);
%     differences = 0:0.1:1;
%     p = vlt.stats.power2sample(sample1, sample2, differences, 'test', 'ttest2');
%
%   Example:
%     % Load data from an Excel file and calculate power
%     % (Assumes the file 'mydata.xls' has columns "Sample 1" and "Sample 2")
%     T = readtable('mydata.xls');
%     sample1 = T.("Sample 1");
%     sample2 = T.("Sample 2");
%     differences = 0:0.1:1;
%     p = vlt.stats.power2sample(sample1, sample2, differences, 'test', 'ttest2');
%

arguments
    sample1 (1,:) double
    sample2 (1,:) double
    differences (1,:) double
    options.test {mustBeMember(options.test,{'ttest2','kstest2','ranksum','pairedTTest'})} = 'ttest2'
    options.alpha (1,1) double {mustBeGreaterThan(options.alpha,0), mustBeLessThan(options.alpha,1)} = 0.05
    options.numSimulations (1,1) double {mustBeInteger, mustBeGreaterThan(options.numSimulations,0)} = 10000
    options.verbose (1,1) logical = true
    options.plot (1,1) logical = true
    options.titleText (1,1) string = "Power Analysis"
    options.xLabel (1,1) string = "Difference"
    options.yLabel (1,1) string = "Power"
end

p = zeros(size(differences));

if strcmp(options.test, 'pairedTTest')
    if numel(sample1) ~= numel(sample2)
        error('For pairedTTest, sample1 and sample2 must have the same number of elements.');
    end
    n = numel(sample1);
    for i = 1:numel(differences)
        if options.verbose
            disp(['Running difference ' int2str(i) ' of ' int2str(numel(differences)) '.']);
        end
        significant_count = 0;
        for j = 1:options.numSimulations
            % Permutation within pairs
            sim_sample1 = zeros(1,n);
            sim_sample2 = zeros(1,n);
            swap_indices = rand(1,n) > 0.5;

            sim_sample1(~swap_indices) = sample1(~swap_indices);
            sim_sample2(~swap_indices) = sample2(~swap_indices);

            sim_sample1(swap_indices) = sample2(swap_indices);
            sim_sample2(swap_indices) = sample1(swap_indices);

            sim_sample2 = sim_sample2 + differences(i);

            % Remove pairs with NaN
            nan_mask = isnan(sim_sample1) | isnan(sim_sample2);
            clean_sample1 = sim_sample1(~nan_mask);
            clean_sample2 = sim_sample2(~nan_mask);

            if ~isempty(clean_sample1) % ttest errors on empty input
                [~, p_val] = ttest(clean_sample1, clean_sample2, 'alpha', options.alpha);
                if p_val < options.alpha
                    significant_count = significant_count + 1;
                end
            end
        end
        p(i) = significant_count / options.numSimulations;
    end
else % Existing logic for independent samples
    combined_samples = [sample1 sample2];
    n1 = numel(sample1);
    n2 = numel(sample2);
    n_total = n1 + n2;

    for i = 1:numel(differences)
        if options.verbose
            disp(['Running difference ' int2str(i) ' of ' int2str(numel(differences)) '.']);
        end
        significant_count = 0;
        for j = 1:options.numSimulations
            % Shuffle the data
            shuffled_indices = randperm(n_total);
            shuffled_data = combined_samples(shuffled_indices);

            shuffled_sample1 = shuffled_data(1:n1);
            shuffled_sample2 = shuffled_data(n1+1:end) + differences(i);

            % Perform the test
            switch options.test
                case 'ttest2'
                    [~, p_val] = ttest2(shuffled_sample1, shuffled_sample2, 'alpha', options.alpha);
                case 'kstest2'
                    [~, p_val] = kstest2(shuffled_sample1, shuffled_sample2, 'alpha', options.alpha);
                case 'ranksum'
                    p_val = ranksum(shuffled_sample1, shuffled_sample2, 'alpha', options.alpha);
            end

            if p_val < options.alpha
                significant_count = significant_count + 1;
            end
        end
        p(i) = significant_count / options.numSimulations;
    end
end

if options.plot
    figure;
    plot(differences, p, 'bo');
    box off;
    title(options.titleText);
    xlabel(options.xLabel);
    ylabel(options.yLabel);
    legend('Simulated Power');
end

end
