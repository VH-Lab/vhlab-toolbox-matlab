function power = calculateTukeyPairwisePower(expectedDifference, expectedMSE, nPerGroup, kTotalGroups, alpha, varargin)
%calculateTukeyPairwisePower Calculates power for a single pairwise Tukey HSD comparison.
%
%   power = vlt.stats.power.calculateTukeyPairwisePower(expectedDifference, expectedMSE, nPerGroup, kTotalGroups, alpha)
%   calculates the a priori statistical power for a single pairwise
%   comparison within a larger multi-group experiment. It assumes the
%   comparison will be analyzed using a Tukey's Honestly Significant
%   Difference (HSD) test, which controls the family-wise error rate (FWER)
%   for all possible pairwise comparisons.
%
%   This function is primarily intended to validate the results of a power
%   simulation by providing a precise analytical solution for a balanced,
%   fixed-effects design. It uses an analytical solution based on the
%   non-central t-distribution and the Studentized range distribution.
%
%   This function uses vlt.stats.qtukey for its calculations.
%
%   **********************************************************************
%   *** DEPENDENCIES                          ***
%   **********************************************************************
%   This function requires 'vlt.stats.qtukey' to be on the MATLAB path.
%   **********************************************************************
%
%   INPUT ARGUMENTS:
%
%     expectedDifference - The expected absolute mean difference between
%                          the two specific groups you are comparing.
%                          (e.g., |mu_i - mu_j|)
%
%     expectedMSE        - The expected Mean Squared Error (MSE) from the
%                          full ANOVA model. This is the pooled
%                          within-group variance (sigma_residual^2).
%
%     nPerGroup          - The sample size *per group* (or per cell).
%                          This function assumes a balanced design.
%
%     kTotalGroups       - The **total number of groups/cells** in the
%                          entire experiment. This is the "k" that Tukey's
%                          HSD uses to correct for multiple comparisons.
%                          (e.g., For a 3-group one-way ANOVA, kTotalGroups = 3)
%                          (e.g., For a 2x3 two-way ANOVA, kTotalGroups = 6)
%
%     alpha              - The desired family-wise error rate (FWER)
%                          or significance level (e.g., 0.05).
%
%   OUTPUT ARGUMENTS:
%
%     power              - The calculated statistical power (a scalar
%                          value from 0 to 1). This is the probability
%                          (1 - beta) of correctly rejecting the null
%                          hypothesis for this specific pair.
%
%   EXAMPLES:
%
%   % Example 1: One-Way ANOVA (k=3)
%   % Expect a 3-unit difference, pooled SD of 2.0 (MSE=4), n=10.
%   pwr1 = vlt.stats.power.calculateTukeyPairwisePower(3, 4, 10, 3, 0.05);
%   fprintf('One-Way (k=3) Power: %.2f%%\n', pwr1 * 100);
%
%   % Example 2: Two-Way ANOVA (2x3, k=6)
%   % Same parameters, but k=6 increases the correction, reducing power.
%   pwr2 = vlt.stats.power.calculateTukeyPairwisePower(3, 4, 10, 6, 0.05);
%   fprintf('Two-Way (k=6) Power: %.2f%%\n', pwr2 * 100);
%
%   See also nctcdf, anovan, multcompare, vlt.stats.qtukey

% --- Input Parsing ---
p = inputParser;
p.FunctionName = 'calculateTukeyPairwisePower';

% Required numerical, scalar inputs
addRequired(p, 'expectedDifference', @(x) isnumeric(x) && isscalar(x) && x >= 0);
addRequired(p, 'expectedMSE',        @(x) isnumeric(x) && isscalar(x) && x > 0);
addRequired(p, 'nPerGroup',          @(x) isnumeric(x) && isscalar(x) && x > 1 && floor(x)==x);
addRequired(p, 'kTotalGroups',       @(x) isnumeric(x) && isscalar(x) && x >= 2 && floor(x)==x);
addRequired(p, 'alpha',              @(x) isnumeric(x) && isscalar(x) && x > 0 && x < 1);

% Parse inputs
parse(p, expectedDifference, expectedMSE, nPerGroup, kTotalGroups, alpha, varargin{:});

% Assign parsed results to local variables for clarity
diff  = p.Results.expectedDifference;
mse   = p.Results.expectedMSE;
n     = p.Results.nPerGroup;
k     = p.Results.kTotalGroups;
a     = p.Results.alpha;

% --- Step 1: Calculate Error Degrees of Freedom (nu) ---
% For a balanced fixed-effects model, v = k * (n - 1)
v = k * (n - 1);

% --- Step 2: Get Critical Value (q_crit) from qtukey ---
try
    q_crit = vlt.stats.qtukey(1 - a, k, v);
catch ME
    if (strcmp(ME.identifier,'MATLAB:UndefinedFunction'))
        error('MATLAB:MissingDependency', ...
            ['The function "vlt.stats.qtukey.m" is not on your path and is required.']);
    else
        rethrow(ME);
    end
end

% Convert the 'q' statistic (Studentized range) to an equivalent 'c'
% statistic (related to the t-distribution)
c = q_crit / sqrt(2);

% --- Step 3: Calculate Non-Centrality Parameter (delta) ---
% This is the standardized effect size for the pairwise comparison.
delta = diff / sqrt((2 * mse) / n);

% --- Step 4: Calculate Power ---
% Power is the probability that an observation from the non-central
% t-distribution (with non-centrality 'delta') will fall outside
% the critical region [-c, c] of the central t-distribution.
power = 1 - nctcdf(c, v, delta) + nctcdf(-c, v, delta);

end
