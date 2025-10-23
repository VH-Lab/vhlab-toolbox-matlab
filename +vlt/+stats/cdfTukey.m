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
%   approximating the Studentized range CDF.
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
%   numerical integration method.
%
%   See also: normcdf, integral, vlt.stats.power.calculateTukeyPairwisePower

% --- Input Parsing ---
arguments
    q (1,1) double {mustBeNumeric}
    k (1,1) double {mustBeInteger, mustBeGreaterThanOrEqual(k, 2)}
    v (1,1) double {mustBeNumeric}
end

if q <= 0
    p = 0;
    return;
end

if v < 1
    warning('MATLAB:User:Warning', 'Degrees of freedom v < 1 is not supported. Using v=1.');
    v = 1;
end

% --- Main Calculation using Numerical Integration ---
% This is a standard formula for the Studentized range CDF.
% It integrates over the probability density of a variable related to
% the chi-squared distribution, weighted by the probability of the
% range of 'k' normal samples.

% This is the standard double integral for the Studentized Range CDF
outer_integrand = @(s) ( ...
    k * ( integral(@(z) normpdf(z) .* (normcdf(z+q*s) - normcdf(z)).^(k-1), -Inf, Inf) ) .* ...
    2 * (v/2).^(v/2) / gamma(v/2) .* s.^(v-1) .* exp(-v*s.^2/2) ...
);

% Integrate 's' from 0 to Inf. Use a high upper limit.
try
    p = integral(outer_integrand, 0, 100);
catch ME
    if strcmp(ME.identifier, 'MATLAB:UndefinedFunction')
        p = quad(outer_integrand, 0, 10);
    else
        rethrow(ME);
    end
end

% Ensure probability is within [0, 1]
p = max(0, min(1, p));

end
