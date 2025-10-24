function power = calculateTukeyPairwisePower(expectedDifference, expectedMSE, nPerGroup, kTotalGroups, alpha, options)
%vlt.stats.power.calculateTukeyPairwisePower Calculates power for a single pairwise Tukey HSD comparison.
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
%   power = vlt.stats.power.calculateTukeyPairwisePower(..., 'method', methodName)
%   specifies the underlying algorithm used to find the critical value from
%   the Studentized range distribution.
%
%   **********************************************************************
%   *** DEPENDENCIES                          ***
%   **********************************************************************
%   This function requires functions from the 'vlt.stats' package:
%   - If method is 'cdfTukey' (Default): Needs 'vlt.stats.cdfTukey'.
%   - If method is 'qTukey': Needs 'vlt.stats.qtukey'.
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
%   OPTIONAL NAME-VALUE PAIR ARGUMENTS (supplied via 'options' struct or directly):
%
%     method (string)    - Specifies the algorithm to use for the critical value.
%                          Options:
%                          'cdfTukey' (Default): Uses 'vlt.stats.cdfTukey' and 'fzero'
%                                                for the highest accuracy.
%                          'qTukey':           Uses 'vlt.stats.qtukey' for a fast
%                                                approximation.
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
%   % Example 1: One-Way ANOVA (k=3), default high-accuracy method.
%   % Expect a 3-unit difference, pooled SD of 2.0 (MSE=4), n=10.
%   try
%       pwr1 = vlt.stats.power.calculateTukeyPairwisePower(3, 4, 10, 3, 0.05);
%       fprintf('One-Way (k=3, cdfTukey) Power: %.2f%%\n', pwr1 * 100);
%   catch ME
%       disp(ME.message); % Display dependency error if needed
%   end
%
%   % Example 2: Two-Way ANOVA (2x3, k=6), fast approximation method.
%   % Same parameters, but k=6 increases the correction, reducing power.
%   try
%       pwr2 = vlt.stats.power.calculateTukeyPairwisePower(3, 4, 10, 6, 0.05, "method", "qTukey");
%       fprintf('Two-Way (k=6, qTukey) Power: %.2f%%\n', pwr2 * 100);
%   catch ME
%       disp(ME.message); % Display dependency error if needed
%   end
%
%   See also nctcdf, anovan, multcompare, vlt.stats.qtukey, vlt.stats.cdfTukey

% --- Input Parsing using Arguments Block ---
arguments
    expectedDifference (1,1) double {mustBeNumeric, mustBeNonnegative}
    expectedMSE (1,1) double {mustBeNumeric, mustBePositive}
    nPerGroup (1,1) double {mustBeInteger, mustBeGreaterThan(nPerGroup, 1)}
    kTotalGroups (1,1) double {mustBeInteger, mustBeGreaterThanOrEqual(kTotalGroups, 2)}
    alpha (1,1) double {mustBeNumeric, mustBeGreaterThan(alpha, 0), mustBeLessThan(alpha, 1)}
    % Optional Name-Value arguments defined using the 'options' structure pattern
    options.method string {mustBeMember(options.method, ["cdfTukey", "qTukey"])} = "cdfTukey"
end

% Assign method from options
method = options.method;

% --- Step 1: Calculate Error Degrees of Freedom (nu) ---
% For a balanced fixed-effects model, v = k * (n - 1)
v = kTotalGroups * (nPerGroup - 1);

% --- Step 2: Get Critical Value (q_crit) using chosen method ---
switch method
    case "cdfTukey"
        % High-accuracy method using fzero and cdfTukey
        try
            target_p = 1 - alpha;
            fun_to_solve = @(q) vlt.stats.cdfTukey(q, kTotalGroups, v) - target_p;
            q_crit = fzero(fun_to_solve, 4.0); % Start search near typical values
        catch ME
            if any(strcmp(ME.identifier, {'MATLAB:UndefinedFunction', 'MATLAB:structRefFromNonStruct'})) || contains(ME.message, 'vlt.stats.cdfTukey', 'IgnoreCase', true)
                 error('MATLAB:MissingDependency', ...
                    ['The function "vlt.stats.cdfTukey.m" is not on your path.\n' ...
                     'This is required for the default ''cdfTukey'' method.']);
            else
                rethrow(ME);
            end
        end

    case "qTukey"
        % Fast approximation method using qtukey
        try
            % Correct argument order: v, k, p
            q_crit = vlt.stats.qtukey(v, kTotalGroups, 1 - alpha);
        catch ME
            if strcmp(ME.identifier,'MATLAB:UndefinedFunction') || contains(ME.message, 'vlt.stats.qtukey', 'IgnoreCase', true)
                error('MATLAB:MissingDependency', ...
                    ['The function "vlt.stats.qtukey.m" is not on your path.\n' ...
                     'This is required for the ''qTukey'' method.']);
            else
                rethrow(ME);
            end
        end
end

% Convert the 'q' statistic (Studentized range) to an equivalent 'c'
% statistic (related to the t-distribution)
c = q_crit / sqrt(2);

% --- Step 3: Calculate Non-Centrality Parameter (delta) ---
% This is the standardized effect size for the pairwise comparison.
delta = expectedDifference / sqrt((2 * expectedMSE) / nPerGroup);

% --- Step 4: Calculate Power ---
% Power is the probability that an observation from the non-central
% t-distribution (with non-centrality 'delta') will fall outside
% the critical region [-c, c] of the central t-distribution.
power = 1 - nctcdf(c, v, delta) + nctcdf(-c, v, delta);

% Ensure power is within [0, 1] bounds due to potential floating point inaccuracies
power = max(0, min(1, power));

end

