function [gf, total_power, fit_power, res_power, res] = gof_totalpower(s, f)
% GOF_TOTALPOWER - Simple computation of how much 'power' of a signal is accounted for by a fit
%
% [GF, TOTAL_POWER, FIT_POWER, RES_POWER, RES] = GOF_TOTALPOWER(S, F)
%
% Computes the amount of total power of a signal, the total power of
% a F of S, and the fraction of the total power that is described
% by the fit. No effort is made to account for how much of the signal S
% may be noise.
%
% Total power is computed by taking the average value of the square of
% the signal S and the square of the signal F. This differs from the coefficient of
% determination, where the mean is subtracted.
% 
% GF = (FIT_POWER)/(TOTAL_POWER)
%
% RES_POWER is the power of the residual RES which is S - F.
%
% S and F are expected to be vectors.
%

s = s(:);
f = f(:);
res = s-f;

total_power = mean(s.^2);
fit_power = mean(f.^2);
res_power = mean(res.^2);

gf = fit_power/total_power;

