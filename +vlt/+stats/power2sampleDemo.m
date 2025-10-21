function power2sampleDemo()
% VLT.STATS.POWER2SAMPLEDEMO - Demonstrate the vlt.stats.power2sample function
%
%   VLT.STATS.POWER2SAMPLEDEMO()
%
%   Demonstrates the usage of the vlt.stats.power2sample function.
%   It compares the simulated power from vlt.stats.power2sample with the
%   theoretical power calculated by MATLAB's 'sampsizepwr' function for a
%   two-sample t-test.
%
%   Example:
%     vlt.stats.power2sampleDemo();
%

% Generate some data
sample1 = randn(1, 20);
sample2 = randn(1, 20);
sd = std([sample1 sample2]); % pooled standard deviation
differences = 0:0.1:2;

% Calculate power using vlt.stats.power2sample
p_simulated = vlt.stats.power2sample(sample1, sample2, differences, 'test', 'ttest2');

% Calculate theoretical power using sampsizepwr
p_theoretical = sampsizepwr('t2', [mean(sample1) sd], mean(sample1) + differences, [], numel(sample1));

% Plot the results
figure;
plot(differences, p_simulated, 'b-o', 'DisplayName', 'Simulated Power');
hold on;
plot(differences, p_theoretical, 'r--', 'DisplayName', 'Theoretical Power');
xlabel('Difference between means');
ylabel('Power');
title('Simulated vs. Theoretical Power for a Two-Sample t-test');
legend('show');
grid on;

end
