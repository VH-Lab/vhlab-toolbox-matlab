function p = cdfTukey(q, k, v)
%vlt.stats.cdfTukey Cumulative distribution function (cdf) of the Studentized range (q)
%
%   p = vlt.stats.cdfTukey(q, k, v)
%
%   Calculates the cumulative probability (p) for the Studentized range
%   statistic (q), given 'k' groups and 'v' degrees of freedom.
%
%   Uses the standard double-integral representation, with the outer
%   integration performed over deterministic fixed-width panels rather than a
%   single adaptive call. The special case k=2 is computed exactly from the
%   t-distribution.
%
%   **********************************************************************
%   *** PACKAGE NOTE & CITATION                                        ***
%   **********************************************************************
%   Originally based on 'cdfTukey.m' from the MATLAB File Exchange
%   (FEX ID: 37450) by L. C. V. Malacarne, a translation of AS 190. That
%   implementation contained bugs producing incorrect probabilities.
%
%   The quadrature strategy here follows R's ptukey, which implements
%   Copenhaver & Holland (1988): fixed-width panels whose width narrows as v
%   grows, a log-space density constant, and an infinite-df shortcut. See
%   issue #141 for why the previous single adaptive integral over [0,Inf]
%   returned exactly 1 for k>2 once v reached about 60.
%
%   References:
%     Copenhaver, M.D. & Holland, B.S. (1988), J. Statist. Comput. Simul.
%       30, 1-15.
%     Lund, R.E. & Lund, J.R. (1983), Algorithm AS 190, Appl. Statist. 32(2).
%
%   See also: normcdf, integral, tcdf, vlt.stats.power.calculateTukeyPairwisePower

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

% --- Special Case for k=2 (exact) ---
% The Studentized range is related to the t-distribution when k=2:
%   q = sqrt(2)*|t|, so P(q <= Q) = tcdf(Q/sqrt(2),v) - tcdf(-Q/sqrt(2),v).
if k == 2
    p = tcdf(q / sqrt(2), v) - tcdf(-q / sqrt(2), v);
    p = local_clamp(p, q, k, v);
    return;
end

% --- Infinite-degrees-of-freedom limit ---
% As v -> Inf the scale factor s -> 1, so the outer integral collapses to its
% integrand at s=1. R's ptukey uses the same shortcut above df = 25000; below
% that the panel sum is already accurate, above it the integral is needlessly
% expensive and numerically delicate.
if v > 25000
    p = local_clamp(local_rangeProb(q, 1, k), q, k, v);
    return;
end

% --- Density constant, in log space ---
% The scale factor s = sqrt(chi2_v / v) has density
%   2*(v/2)^(v/2)/gamma(v/2) * s^(v-1) * exp(-v*s^2/2).
% Forming (v/2)^(v/2) directly overflows double around v = 290, so accumulate
% it logarithmically instead. See issue #141.
logConst = log(2) + (v/2)*log(v/2) - gammaln(v/2);

outer_integrand = @(s) local_rangeProb(q, s, k) .* ...
    exp(logConst + (v-1)*log(max(s,realmin)) - v*s.^2/2);

% --- Outer integration over deterministic panels ---
% The integrand concentrates near s=1 with width ~1/sqrt(2*v): at v=60 that is
% a spike of half-width about 0.09. Rather than ask an adaptive routine to
% locate it in a semi-infinite domain, march fixed-width panels outward and
% stop once they stop contributing. Panel width narrows with v exactly as in
% R's ptukey.
if v <= 100
    ulen = 1.0;
elseif v <= 800
    ulen = 0.5;
elseif v <= 5000
    ulen = 0.25;
else
    ulen = 0.125;
end

p = 0;
maxPanels = 50;
for i = 0:(maxPanels-1)
    lo = i*ulen;
    hi = (i+1)*ulen;
    part = integral(outer_integrand, lo, hi, 'ArrayValued', true, ...
        'AbsTol', 1e-12, 'RelTol', 1e-10);
    p = p + part;
    % Only permit termination once past the bulk of the density at s=1.
    if hi >= 1 && part <= 1e-14
        break;
    end
end

p = local_clamp(p, q, k, v);

end % cdfTukey

function pr = local_rangeProb(q, s, k)
% Probability that the range of k iid standard normals is at most q*s:
%   k * integral phi(z) * (Phi(z + q*s) - Phi(z))^(k-1) dz
% Tight tolerances matter here: this is the outer integrand, and an inner
% result accurate only to the default 1e-6 makes the outer quadrature's error
% estimate unreliable.
inner = @(z) normpdf(z) .* (normcdf(z + q*s) - normcdf(z)).^(k-1);
pr = k * integral(inner, -Inf, Inf, 'ArrayValued', true, ...
    'AbsTol', 1e-12, 'RelTol', 1e-10);
end

function p = local_clamp(p, q, k, v)
% Keep the result a valid probability, but say so when it happens. Silently
% clamping is what allowed the quadrature failure in issue #141 to masquerade
% as a plausible answer of exactly 1 for years.
if ~isfinite(p) || p < -1e-8 || p > 1+1e-8
    warning('vlt:cdfTukey:clamped', ...
        ['vlt.stats.cdfTukey: raw integral was %g for q=%g, k=%d, v=%g; ' ...
         'clamping to [0,1]. This indicates a numerical problem, not a ' ...
         'rounding artefact.'], p, q, k, v);
end
p = max(0, min(1, p));
end
