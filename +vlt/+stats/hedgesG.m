function g = hedgesG(A, B)
% HEDGESG - Calculate Hedges' g effect size
%
% G = vlt.stats.hedgesG(A, B)
%
% Calculates Hedges' g effect size for two independent samples A and B.
% Hedges' g is a variation of Cohen's d that corrects for bias due to small sample sizes.
%
% Inputs:
%   A - First sample (numeric vector)
%   B - Second sample (numeric vector)
%
% Outputs:
%   G - Hedges' g effect size
%
% Notes:
%   - NaNs in the input are ignored.
%   - Returns NaN if either sample has fewer than 2 non-NaN elements (variance is undefined).
%   - The correction factor J is approximated as 1 - 3/(4*(n1+n2)-9).
%
% Example:
%   A = [1 2 3 4 5];
%   B = [2 3 4 5 6];
%   g = vlt.stats.hedgesG(A, B);
%

    % Validate inputs (basic check)
    if nargin < 2
        error('vlt:stats:hedgesG:NotEnoughInputs', 'Two input arguments are required.');
    end

    % Remove NaNs and flatten to column vectors
    A = A(:);
    B = B(:);
    A = A(~isnan(A));
    B = B(~isnan(B));

    n1 = length(A);
    n2 = length(B);

    % Check for sufficient data points
    if n1 < 2 || n2 < 2
        g = NaN;
        return;
    end

    % Calculate means
    m1 = mean(A);
    m2 = mean(B);

    % Calculate variances (using n-1 normalization, default in var)
    v1 = var(A);
    v2 = var(B);

    % Calculate pooled standard deviation
    % s_pool = sqrt( ((n1-1)*v1 + (n2-1)*v2) / (n1+n2-2) )
    df = n1 + n2 - 2;
    numerator = (n1 - 1) * v1 + (n2 - 1) * v2;
    s_pool = sqrt(numerator / df);

    % Calculate Cohen's d
    if s_pool == 0
        if m1 == m2
            d = 0;
        else
            d = Inf; % Or handle as needed, Inf is standard for 0 variance with difference
        end
    else
        d = (m1 - m2) / s_pool;
    end

    % Calculate Hedges' g correction factor J
    % Approximation: J = 1 - 3 / (4 * (n1 + n2 - 2) - 1)
    %              = 1 - 3 / (4 * df - 1)
    %              = 1 - 3 / (4 * (n1 + n2) - 9)
    J = 1 - (3 / (4 * (n1 + n2) - 9));

    % Hedges' g
    g = d * J;

end
