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
%   power = vlt.stats.power.calculateTukeyPairwisePower(..., 'method', methodName)
%   specifies the underlying algorithm used to find the critical value from
%   the Studentized range distribution.
%
%   **********************************************************************
%   *** DEPENDENCIES                          ***
%   **********************************************************************
%   This function is a wrapper and requires one of the following
%   functions from the MATLAB File Exchange to be on your MATLAB path:
%
%   1. 'cdfTukey' (Default Method):
%      - NEEDS: 'cdfTukey.m' (File Exchange ID: 37450)
%      - DESC: A high-accuracy method that uses the robust AS 190
%        algorithm for the CDF and MATLAB's 'fzero' to find the
%        precise critical value (quantile).
%
%   2. 'qTukey' (Fast Method):
%      - NEEDS: 'qtukey.m' (File Exchange ID: 3469)
%      - DESC: A fast, direct approximation of the quantile function.
%        It is generally accurate but may be less precise than the
%        'cdfTukey' method at extreme probabilities.
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
%   OPTIONAL NAME-VALUE PAIR ARGUMENTS:
%
%     'method', methodName - Specifies the algorithm to use.
%
%         'cdfTukey' (Default): Uses 'cdfTukey.m' (FEX 37450) and 'fzero'
%                               for the highest accuracy.
%
%         'qTukey':           Uses 'qtukey.m' (FEX 3469) for a fast
%                               approximation.
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
%   % You need 'cdfTukey.m' (FEX 37450) on your path.
%   % Expect a 3-unit difference, pooled SD of 2.0 (MSE=4), n=10.
%   try
%       pwr1 = vlt.stats.power.calculateTukeyPairwisePower(3, 4, 10, 3, 0.05);
%       fprintf('One-Way (k=3, cdfTukey) Power: %.2f%%\n', pwr1 * 100);
%   catch ME
%       disp(ME.message);
%   end
%
%   % Example 2: Two-Way ANOVA (2x3, k=6), fast approximation method.
%   % You need 'qtukey.m' (FEX 3469) on your path.
%   % Same parameters, but k=6 increases the correction, reducing power.
%   try
%       pwr2 = vlt.stats.power.calculateTukeyPairwisePower(3, 4, 10, 6, 0.05, 'method', 'qTukey');
%       fprintf('Two-Way (k=6, qTukey) Power: %.2f%%\n', pwr2 * 100);
%   catch ME
%       disp(ME.message);
%   end
%
%   See also nctcdf, fzero, tinv, finv, anovan, multcompare, sampsizepwr.

% --- Input Parsing ---
p = inputParser;
p.FunctionName = 'calculateTukeyPairwisePower';

% Required numerical, scalar inputs
addRequired(p, 'expectedDifference', @(x) isnumeric(x) && isscalar(x) && x >= 0);
addRequired(p, 'expectedMSE',        @(x) isnumeric(x) && isscalar(x) && x > 0);
addRequired(p, 'nPerGroup',          @(x) isnumeric(x) && isscalar(x) && x > 1 && floor(x)==x);
addRequired(p, 'kTotalGroups',       @(x) isnumeric(x) && isscalar(x) && x >= 2 && floor(x)==x);
addRequired(p, 'alpha',              @(x) isnumeric(x) && isscalar(x) && x > 0 && x < 1);

% Optional Name-Value 'method'
defaultMethod = 'cdfTukey';
validMethods = {'cdfTukey', 'qTukey'};
addParameter(p, 'method', defaultMethod, @(x) any(validatestring(x, validMethods)));

% Parse inputs
parse(p, expectedDifference, expectedMSE, nPerGroup, kTotalGroups, alpha, varargin{:});

% Assign parsed results to local variables for clarity
diff  = p.Results.expectedDifference;
mse   = p.Results.expectedMSE;
n     = p.Results.nPerGroup;
k     = p.Results.kTotalGroups;
a     = p.Results.alpha;
method = p.Results.method;

% --- Step 1: Calculate Error Degrees of Freedom (nu) ---
% For a balanced fixed-effects model, v = k * (n - 1)
v = k * (n - 1);

% --- Step 2: Get Critical Value (q_crit) using chosen method ---
switch method
    case 'cdfTukey'
        % High-accuracy method using fzero and cdfTukey (FEX 37450)
        try
            % We need to find the value 'q' where the CDF equals (1-alpha).
            % We are solving the equation: cdfTukey(q, k, v) - (1-alpha) = 0
            target_p = 1 - a;
            fun_to_solve = @(q) vlt.stats.cdfTukey(q, k, v) - target_p;

            % Provide a reasonable starting guess for fzero (e.g., 4.0)
            q_crit = fzero(fun_to_solve, 4.0);

        catch ME
            if (strcmp(ME.identifier,'MATLAB:UndefinedFunction'))
                error('MATLAB:MissingDependency', ...
                    ['The function "cdfTukey.m" (File Exchange ID: 37450) is not on your path.\n' ...
                     'This is required for the default ''cdfTukey'' method.']);
            else
                rethrow(ME);
            end
        end

    case 'qTukey'
        % Fast approximation method using qtukey (FEX 3469)
        try
            q_crit = qtukey(1 - a, k, v);
        catch ME
            if (strcmp(ME.identifier,'MATLAB:UndefinedFunction'))
                error('MATLAB:MissingDependency', ...
                    ['The function "qtukey.m" (File Exchange ID: 3469) is not on your path.\n' ...
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
delta = diff / sqrt((2 * mse) / n);

% --- Step 4: Calculate Power ---
% Power is the probability that an observation from the non-central
% t-distribution (with non-centrality 'delta') will fall outside
% the critical region [-c, c] of the central t-distribution.
power = 1 - nctcdf(c, v, delta) + nctcdf(-c, v, delta);

end
