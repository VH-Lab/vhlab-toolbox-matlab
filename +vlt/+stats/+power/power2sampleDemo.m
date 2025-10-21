function power2sampleDemo(options)
% VLT.STATS.POWER.POWER2SAMPLEDEMO - Demonstrate the vlt.stats.power.power2sample function
%
%   VLT.STATS.POWER.POWER2SAMPLEDEMO()
%
%   Demonstrates the usage of the vlt.stats.power.power2sample function.
%   It compares the simulated power from vlt.stats.power.power2sample with the
%   theoretical power calculated by MATLAB's 'sampsizepwr' function for a
%   two-sample t-test.
%
%   This function can also be called with name/value pairs to alter
%   the simulation parameters.
%
%   'numSamples1' (default 20) : number of samples in sample 1
%   'numSamples2' (default 20) : number of samples in sample 2
%   'sampleStdDev' (default 1) : The standard deviation of the samples.
%   'differences' (default [0:0.1:2]) : The differences to test.
%
%   Example:
%     vlt.stats.power.power2sampleDemo();
%
%   Example:
%     vlt.stats.power.power2sampleDemo('numSamples1',50,'numSamples2',50);
%
%   Example:
%     vlt.stats.power.power2sampleDemo('numSamples1',50,'numSamples2',10,'sampleStdDev',20)
%
%   Example:
%     vlt.stats.power.power2sampleDemo('numSamples1',50,'numSamples2',10,'sampleStdDev',20,'differences',[0:1:5])
%

arguments
    options.numSamples1 (1,1) double {mustBeInteger, mustBeGreaterThan(options.numSamples1,0)} = 20
    options.numSamples2 (1,1) double {mustBeInteger, mustBeGreaterThan(options.numSamples2,0)} = 20
    options.sampleStdDev (1,1) double {mustBeGreaterThanOrEqual(options.sampleStdDev,0)} = 1
    options.differences (1,:) double = 0:0.1:2
end

% Generate some data
sample1 = options.sampleStdDev * randn(1, options.numSamples1);
sample2 = options.sampleStdDev * randn(1, options.numSamples2);
sd = std([sample1 sample2]); % pooled standard deviation

% Calculate power using vlt.stats.power.power2sample
p_simulated = vlt.stats.power.power2sample(sample1, sample2, options.differences, 'test', 'ttest2');

% Calculate theoretical power using sampsizepwr
n_smaller = min(options.numSamples1, options.numSamples2);
n_larger = max(options.numSamples1, options.numSamples2);
ratio = n_larger / n_smaller;
p_theoretical = sampsizepwr('t2', [mean(sample1) sd], mean(sample1) + options.differences, [], n_smaller, 'ratio', ratio);

% Plot the results
figure;
plot(options.differences, p_simulated, 'bo', 'DisplayName', 'Simulated Power');
hold on;
plot(options.differences, p_theoretical, 'r--', 'DisplayName', 'Theoretical Power');
xlabel('Difference between means');
ylabel('Power');
title(['Simulated vs. Theoretical Power, N1=' int2str(options.numSamples1) ', N2=' int2str(options.numSamples2)]);
legend('show');
box off;
grid on;

end
