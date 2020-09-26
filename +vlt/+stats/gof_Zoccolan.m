function [gf,vres,vexpl,vnoise] = gof_Zoccolan(rawdata, fit)

% GOF_ZOCCOLAN - Goodness of Fit from Zoccolan et al., 2005
%
%  [GF,Vres,Vexpl,Vnoise] = GOF_ZOCCOLAN(TRIALDATA, FIT)
%
% Returns goodness of fit that describes how much of the explainable
% variation (i.e., that not due to noise across trials) is explained
% by a given fit.
% 
% TRIALDATA should have M columns and N rows.  Each column should have
%   individual responses for one particular stimulus.  If any values are
%   NAN then these trials are excluded.
%
% FIT is a fit to the mean response to each stimulus and should be 1xN.
%
% GF is the goodness of fit measure from 0 to 1
% Vres is the residual variance left over from the fit
% Vexpl is the explainable variance
% Vnoise is the variance of the noise
%
% Ref:  Zoccolan DE, Cox DD, DiCarlo, JJ.  J Neurosci 25:8150-8164 2005.

error('This code is untested; needs to be tested.');

[rowstotrim,cols] = find(isnan(rawdata));

rawdata = rawdata(setdiff(1:size(rawdata,1),rowstotrim),:);

trials = size(rawdata,1);
numgroups = size(rawdata,2);

Sw = sum(sum((rawdata-repmat(mean(rawdata),trials,1)).^2));
Sb = trials*sum((mean(rawdata)-mean(rawdata(:))).^2);

vnoise = Sw/((trials-1)*numgroups);
vexpl = Sb/((trials)*(numgroups-1)) - Sw/((trials-1)*numgroups*trials);

% now the residule variance

Res = rawdata - repmat(fit,trials,1);

Swr = sum(sum((Res-repmat(mean(Res),trials,1)).^2));
Sbr = trials*sum((mean(Res)-mean(Res(:))).^2);

vres = Sbr/((trials)*(numgroups-1)) - Swr/((trials-1)*numgroups*trials);

gf = 1-vres/vexpl;

