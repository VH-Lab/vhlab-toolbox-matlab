function power = contrast_power_from_draws(estimate, se, df, trueValues, contrasts, options)
% CONTRAST_POWER_FROM_DRAWS - power of planned contrasts for any true values, from simulated fits
%
% POWER = vlt.stats.power.CONTRAST_POWER_FROM_DRAWS(ESTIMATE, SE, DF, TRUEVALUES, CONTRASTS, ...)
%
% Computes the power of planned contrasts of a linear mixed model from
% simulated fits, for one or more sets of true contrast values, without new
% simulations.
%
% Because the model is linear in the response, adding a constant to the true
% cell means adds the corresponding constant to every contrast estimate and
% leaves its standard error and degrees of freedom unchanged (REML variance
% estimates do not depend on the fixed effects). So, given the estimate, SE,
% and DF of each contrast from fits of data simulated with NO effect (e.g.,
% RESULTS.contrastDraws from vlt.stats.power.lme_factorial_power with an
% effect size of 0), the estimates for true contrast values V are
% ESTIMATE + V, with the same SE and DF, and the power is the fraction of
% simulations in which each test succeeds.
%
% Inputs:
%   ESTIMATE, SE, DF - nSimulations x nContrasts matrices from the simulated
%       fits (NaN for a failed fit, which counts as a failure)
%   TRUEVALUES - nScenarios x nContrasts matrix of true contrast values to
%       evaluate (one row per scenario)
%   CONTRASTS - struct array of the contrasts (as for the 'plannedContrasts'
%       option of vlt.stats.lme_factorial): uses the fields direction
%       ('greater', 'less', or 'none'/absent) and margin (equivalence margin,
%       or NaN/absent)
%
% Output:
%   POWER - structure with fields
%     powerEach - nScenarios x nContrasts: probability that each contrast's
%         two-sided test is significant (and, if a direction is predicted,
%         that the estimate has the predicted sign)
%     powerAll - nScenarios x 1: probability that ALL contrasts with a
%         predicted direction succeed in the same experiment (NaN if none
%         has a direction)
%     powerEquivalent - nScenarios x nContrasts: probability that the
%         equivalence test (two one-sided tests against +/- margin) succeeds;
%         NaN for contrasts without a margin
%
% This function also takes name/value pairs:
%   alpha (0.05) - significance level of every test
%
% See also: vlt.stats.power.lme_factorial_power, vlt.stats.lme_factorial

arguments
    estimate double
    se double
    df double
    trueValues double
    contrasts struct
    options.alpha (1,1) double {mustBeInRange(options.alpha,0,1)} = 0.05
end

nC = size(estimate,2);
if ~isequal(size(se), size(estimate)) || ~isequal(size(df), size(estimate))
    error('ESTIMATE, SE, and DF must be the same size.');
end
if size(trueValues,2) ~= nC || numel(contrasts) ~= nC
    error('TRUEVALUES must have one column, and CONTRASTS one element, per contrast (%d).', nC);
end

direction = strings(1,nC);
margin = nan(1,nC);
for i=1:nC
    direction(i) = "none";
    if isfield(contrasts,'direction') && ~isempty(contrasts(i).direction)
        direction(i) = string(contrasts(i).direction);
    end
    if isfield(contrasts,'margin') && ~isempty(contrasts(i).margin)
        margin(i) = contrasts(i).margin;
    end
end
directional = direction ~= "none";

nS = size(trueValues,1);
nSim = size(estimate,1);
powerEach = nan(nS, nC);
powerAll = nan(nS, 1);
powerEquivalent = nan(nS, nC);
alpha = options.alpha;

for k=1:nS
    shifted = estimate + trueValues(k,:);
    p = 2 * tcdf(-abs(shifted ./ se), df);
    success = p < alpha;
    success(:, direction=="greater") = success(:, direction=="greater") & shifted(:, direction=="greater") > 0;
    success(:, direction=="less") = success(:, direction=="less") & shifted(:, direction=="less") < 0;
    success(isnan(p)) = false;
    powerEach(k,:) = sum(success,1) / nSim;
    if any(directional)
        powerAll(k) = sum(all(success(:,directional),2)) / nSim;
    end
    for i=find(~isnan(margin))
        pLower = 1 - tcdf((shifted(:,i) + margin(i)) ./ se(:,i), df(:,i));
        pUpper = tcdf((shifted(:,i) - margin(i)) ./ se(:,i), df(:,i));
        equivalent = max(pLower, pUpper) < alpha;
        equivalent(isnan(pLower) | isnan(pUpper)) = false;
        powerEquivalent(k,i) = sum(equivalent) / nSim;
    end
end

power = struct('powerEach', powerEach, 'powerAll', powerAll, 'powerEquivalent', powerEquivalent);

end
