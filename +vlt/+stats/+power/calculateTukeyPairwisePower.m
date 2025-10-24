function power = calculateTukeyPairwisePower(expectedDifference, expectedMSE, nPerGroup, kTotalGroups, alpha, options)
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
%   power = vlt.stats.power.calculateTukeyPairwisePower(..., 'method', methodName)
%   specifies the underlying algorithm used to find the critical value from
%   the Studentized range distribution.
%
%   **********************************************************************
%   *** DEPENDENCIES                          ***
%   **********************************************************************
%   This function is a wrapper and requires one of the following
%   functions from the MATLAB File Exchange (or within the vlt package)
%   to be on your MATLAB path, depending on the chosen 'method':
%
%   1. 'qTukey' (Default Method):
%      - NEEDS: 'vlt.stats.qtukey.m' (originally FEX ID: 3469)
%      - DESC: A fast, direct approximation of the quantile function.
%        It is generally accurate and robust. Recommended for most uses.
%
%   2. 'cdfTukey' (High Accuracy Method):
%      - NEEDS: 'vlt.stats.cdfTukey.m' (originally FEX ID: 37450, rewritten)
%      - DESC: Uses high-accuracy numerical integration for the CDF and
%        MATLAB's 'fzero' to find the precise critical value (quantile).
%        May be less stable for large 'k' or extreme probabilities due
%        to numerical integration challenges.
%
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
%   OPTIONAL NAME-VALUE PAIR ARGUMENTS (options):
%
%     method (string)    - Specifies the algorithm to use.
%
%         'qTukey' (Default):   Uses 'vlt.stats.qtukey.m' for a fast
%                               approximation. Recommended.
%
%         'cdfTukey':           Uses 'vlt.stats.cdfTukey.m' and 'fzero'
%                               for the highest accuracy (may be unstable).
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
%   % Example 1: One-Way ANOVA (k=3), default fast method.
%   % Expect a 3-unit difference, pooled SD of 2.0 (MSE=4), n=10.
%   try
%       pwr1 = vlt.stats.power.calculateTukeyPairwisePower(3, 4, 10, 3, 0.05);
%       fprintf('One-Way (k=3, qTukey) Power: %.2f%%\n', pwr1 * 100);
%   catch ME
%       disp(ME.message); % Display error if dependencies are missing
%   end
%
%   % Example 2: Two-Way ANOVA (2x3, k=6), high accuracy method.
%   % Same parameters, but k=6 increases the correction, reducing power.
%   try
%       pwr2 = vlt.stats.power.calculateTukeyPairwisePower(3, 4, 10, 6, 0.05, 'method', 'cdfTukey');
%       fprintf('Two-Way (k=6, cdfTukey) Power: %.2f%%\n', pwr2 * 100);
%   catch ME
%       disp(ME.message); % Display error if dependencies are missing
%   end
%
%   See also nctcdf, fzero, anovan, multcompare, vlt.stats.cdfTukey, vlt.stats.qtukey

% --- Input Parsing using arguments block ---
arguments
    expectedDifference (1,1) double {mustBeNumeric, mustBeNonnegative}
    expectedMSE        (1,1) double {mustBeNumeric, mustBePositive}
    nPerGroup          (1,1) double {mustBeInteger, mustBeGreaterThan(nPerGroup, 1)}
    kTotalGroups       (1,1) double {mustBeInteger, mustBeGreaterThanOrEqual(kTotalGroups, 2)}
    alpha              (1,1) double {mustBeNumeric, mustBeGreaterThan(alpha, 0), mustBeLessThan(alpha, 1)}
    % --- FIX: Change default method to 'qTukey' ---
    options.method     (1,1) string {mustBeMember(options.method, ["cdfTukey", "qTukey"])} = "qTukey" % Default method changed
end

% Assign validated inputs to local variables for clarity
diff  = expectedDifference;
mse   = expectedMSE;
n     = nPerGroup;
k     = kTotalGroups;
a     = alpha;
method = options.method;

% --- Step 1: Calculate Error Degrees of Freedom (nu) ---
% For a balanced fixed-effects model, v = k * (n - 1)
v = k * (n - 1);

% --- Step 2: Get Critical Value (q_crit) using chosen method ---
switch method
    case "cdfTukey"
        % High-accuracy method using fzero and cdfTukey
        try
            target_p = 1 - a;
            fun_to_solve = @(q) vlt.stats.cdfTukey(q, k, v) - target_p;
            % Increase MaxIter and TolX for fzero robustness
            fzero_opts = optimset('TolX', 1e-6, 'MaxIter', 1000); 
            q_crit = fzero(fun_to_solve, 4.0, fzero_opts);

        catch ME
            if (strcmp(ME.identifier,'MATLAB:UndefinedFunction'))
                error('MATLAB:MissingDependency', ...
                    ['The function "vlt.stats.cdfTukey.m" is not on your path.\n' ...
                     'This is required for the ''cdfTukey'' method.']);
            else
                if strcmp(ME.identifier, 'MATLAB:fzero:ValuesAtEndPtsSameSign') || contains(ME.message, 'Function values at interval endpoints') || contains(ME.message,'NaN or Inf function value')
                   warning('vlt:stats:power:fzeroFailed', ...
                           'fzero/cdfTukey failed to find the critical value (likely due to numerical instability). Results may be inaccurate. Try the ''qTukey'' method.');
                   q_crit = NaN; % Indicate failure
                else
                    rethrow(ME); % Rethrow other errors
                end
            end
        end

    case "qTukey"
        % Fast approximation method using qTukey
        try
            % CORRECT ARGUMENT ORDER: v, k, p
            q_crit = vlt.stats.qtukey(v, k, 1 - a);
        catch ME
            if (strcmp(ME.identifier,'MATLAB:UndefinedFunction'))
                error('MATLAB:MissingDependency', ...
                    ['The function "vlt.stats.qtukey.m" is not on your path.\n' ...
                     'This is required for the ''qTukey'' method.']);
            else
                rethrow(ME);
            end
        end
end

% Handle potential failure in finding q_crit
if isnan(q_crit) || q_crit <= 0 % Also check for invalid q_crit from fzero failure
    power = NaN;
    warning('vlt:stats:power:qCritNaN', 'Could not determine a valid critical q-value. Power calculation failed.');
    return;
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

% --- Remove Debugging Lines ---
power = 1 - nctcdf(c, v, delta) + nctcdf(-c, v, delta);

% Ensure power is within [0, 1] - handles potential numerical inaccuracies
power = max(0, min(1, power));

end

