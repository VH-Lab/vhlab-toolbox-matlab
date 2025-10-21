function power2sampleDemo(options)
% VLT.STATS.POWER2SAMPLEDEMO - Demonstrate the vlt.stats.power2sample function
%
%   VLT.STATS.POWER2SAMPLEDEMO()
%
%   Demonstrates the usage of the vlt.stats.power2sample function.
%   It compares the simulated power from vlt.stats.power2sample with the
%   theoretical power calculated by MATLAB's 'sampsizepwr' function for a
%   two-sample t-test.
%
%   This function can also be called with name/value pairs to alter
%   the simulation parameters.
%
%   'numSamples1' (default 20) : number of samples in sample 1
%   'numSamples2' (default 20) : number of samples in sample 2
%
%   Example:
%     vlt.stats.power2sampleDemo();
%
%   Example:
%     vlt.stats.power2sampleDemo('numSamples1',50,'numSamples2',50);
%

arguments
    options.numSamples1 (1,1) double {mustBeInteger, mustBeGreaterThan(options.numSamples1,0)} = 20
    options.numSamples2 (1,1) double {mustBeInteger, mustBeGreaterThan(options.numSamples2,0)} = 20
end

% Generate some data
sample1 = randn(1, options.numSamples1);
sample2 = randn(1, options.numSamples2);
sd = std([sample1 sample2]); % pooled standard deviation
differences = 0:0.1:2;

% Calculate power using vlt.stats.power2sample
p_simulated = vlt.stats.power2sample(sample1, sample2, differences, 'test', 'ttest2');

% Calculate theoretical power using sampsizepwr
n_smaller = min(options.numSamples1, options.numSamples2);
n_larger = max(options.numSamples1, options.numSamples2);
ratio = n_larger / n_smaller;
p_theoretical = sampsizepwr('t2', [mean(sample1) sd], mean(sample1) + differences, [], n_smaller, 'ratio', ratio);

% Plot the results
figure;
plot(differences, p_simulated, 'b-o', 'DisplayName', 'Simulated Power');
hold on;
plot(differences, p_theoretical, 'r--', 'DisplayName', 'Theoretical Power');
xlabel('Difference between means');
ylabel('Power');
title(['Simulated vs. Theoretical Power, N1=' int2str(options.numSamples1) ', N2=' int2str(options.numSamples2)]);
legend('show');
grid on;

end
