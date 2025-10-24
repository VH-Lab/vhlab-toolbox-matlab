function p = cdfTukey(q, k, v)
%vlt.stats.cdfTukey Cumulative distribution function (cdf) of the Studentized range (q)
%
%   p = vlt.stats.cdfTukey(q, k, v)
%
%   Calculates the cumulative probability (p) for the Studentized range
%   statistic (q), given 'k' groups and 'v' degrees of freedom.
%
%   This function uses a standard numerical integration approach based on
%   the normal distribution's CDF, which is a common and robust method for
%   approximating the Studentized range CDF. It also includes a direct
%   calculation using the t-distribution CDF for the special case k=2.
%
%   **********************************************************************
%   *** PACKAGE NOTE & CITATION                                        ***
%   **********************************************************************
%   This function was originally based on 'cdfTukey.m' from the MATLAB
%   File Exchange (FEX ID: 37450) by L. C. V. Malacarne, which was a
%   translation of the AS 190 algorithm. The original implementation was
%   found to contain bugs that produced incorrect probabilities.
%
%   This version has been re-written to use a more standard and reliable
%   numerical integration method for k>2 and the exact t-distribution
%   relationship for k=2.
%
%   See also: normcdf, integral, tcdf, vlt.stats.power.calculateTukeyPairwisePower
% --- Input Parsing ---
arguments
    q (1,1) double {mustBeNumeric}
    k (1,1) double {mustBeInteger, mustBeGreaterThanOrEqual(k, 2)}
    v (1,1) double {mustBeNumeric}
end

% --- Handle Edge Cases ---
if q <= 0
    p = 0;
    return;
end

if v < 1
    warning('MATLAB:User:Warning', 'Degrees of freedom v < 1 is not supported. Using v=1.');
    v = 1;
end

% --- Special Case for k=2 ---
% The Studentized range is related to the t-distribution when k=2:
% q = sqrt(2) * |t|
% P(q <= Q) = P(sqrt(2)*|t| <= Q) = P(|t| <= Q/sqrt(2))
%           = P(-Q/sqrt(2) <= t <= Q/sqrt(2))
%           = tcdf(Q/sqrt(2), v) - tcdf(-Q/sqrt(2), v)
if k == 2
    p = tcdf(q / sqrt(2), v) - tcdf(-q / sqrt(2), v);
    % Ensure probability is within [0, 1] - handles potential numerical inaccuracies
    p = max(0, min(1, p));
    return; % Calculation complete for k=2
end

% --- Main Calculation using Numerical Integration (for k > 2) ---
% This is the standard double integral for the Studentized Range CDF
% Integrate over the PDF of s (related to chi-distribution)
% weighted by the probability of the range of 'k' normal samples.

% Inner integral (over z)
inner_integrand = @(z, q_val, s_val, k_val) ...
    normpdf(z) .* (normcdf(z + q_val * s_val) - normcdf(z)).^(k_val - 1);

% Outer integral (over s)
outer_integrand = @(s) ( ...
    k * ( integral(@(z) inner_integrand(z, q, s, k), -Inf, Inf, 'ArrayValued', true) ) .* ...
    2 * (v/2).^(v/2) / gamma(v/2) .* s.^(v-1) .* exp(-v*s.^2/2) ...
);

% Integrate 's' from 0 to Inf.
try
    % Use Inf for the upper limit, which is more accurate
    p = integral(outer_integrand, 0, Inf, 'ArrayValued', true);
catch ME
    if strcmp(ME.identifier, 'MATLAB:UndefinedFunction')
        % Fallback for older MATLAB versions (quad does not support Inf)
        % Using a reasonably large upper limit (e.g., 100)
        p = quad(outer_integrand, 0, 100);
    else
        rethrow(ME);
    end
end

% Ensure probability is within [0, 1] - handles potential numerical inaccuracies
p = max(0, min(1, p));

end

