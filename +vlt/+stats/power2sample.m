function p = power2sample(sample1, sample2, differences, varargin)
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
%   - 'test' ('ttest2' | 'kstest2' | 'ranksum'): The statistical test to use.
%     Default is 'ttest2'.
%   - 'alpha' (0 < alpha < 1): The significance level. Default is 0.05.
%   - 'numSimulations' (integer > 0): The number of simulations. Default is 10000.
%
%   Output:
%   - P: A vector the same size as DIFFERENCES, indicating the fraction of
%     simulations where the test yielded a significant difference.
%
%   Example:
%     sample1 = randn(1, 10);
%     sample2 = randn(1, 10);
%     differences = 0:0.1:1;
%     p = vlt.stats.power2sample(sample1, sample2, differences, 'test', 'ttest2');
%     figure;
%     plot(differences, p);
%     xlabel('Difference');
%     ylabel('Power');
%

arguments
    sample1 (1,:) double
    sample2 (1,:) double
    differences (1,:) double
    varargin.test {mustBeMember(varargin.test,{'ttest2','kstest2','ranksum'})} = 'ttest2'
    varargin.alpha (1,1) double {mustBeGreaterThan(varargin.alpha,0), mustBeLessThan(varargin.alpha,1)} = 0.05
    varargin.numSimulations (1,1) double {mustBeInteger, mustBeGreaterThan(varargin.numSimulations,0)} = 10000
end

p = zeros(size(differences));
combined_samples = [sample1 sample2];
n1 = numel(sample1);
n2 = numel(sample2);
n_total = n1 + n2;

for i = 1:numel(differences)
    disp(['Running difference ' int2str(i) ' of ' int2str(numel(differences)) '.']);
    significant_count = 0;
    for j = 1:varargin.numSimulations
        % Shuffle the data
        shuffled_indices = randperm(n_total);
        shuffled_data = combined_samples(shuffled_indices);

        shuffled_sample1 = shuffled_data(1:n1);
        shuffled_sample2 = shuffled_data(n1+1:end) + differences(i);

        % Perform the test
        switch varargin.test
            case 'ttest2'
                [~, p_val] = ttest2(shuffled_sample1, shuffled_sample2, 'alpha', varargin.alpha);
            case 'kstest2'
                [~, p_val] = kstest2(shuffled_sample1, shuffled_sample2, 'alpha', varargin.alpha);
            case 'ranksum'
                p_val = ranksum(shuffled_sample1, shuffled_sample2, 'alpha', varargin.alpha);
        end

        if p_val < varargin.alpha
            significant_count = significant_count + 1;
        end
    end
    p(i) = significant_count / varargin.numSimulations;
end

end
