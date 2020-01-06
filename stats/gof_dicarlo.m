function [gf,vres,vexpl,vnoise] = gof_dicarlo(rawdata, fit, varargin)

% GOF - Goodness of Fit from DiCarlo et al. 
%
% [GF, VRES, VEXPL, VNOISE] = GOF_DICARLO(RAWDATA, FIT)
%
% Computes the "explanable variance" goodness-of-fit in
% DiCarlo et al. 1988. 
%
% Imagine a measured process Y(t) reflects some underlying
% function F(t) plus noise (due to measurement or process)
% N(t). Then the sum of squares (Y(t)^2) for all t is
% (Y(t)^2) = (F(t)^2) + (N(t))^2 + 2*F(t)*N(t). If we further
% assume that the expected value of N(t) is 0, then on average
% (Y(t)^2) = F(t)^2 + N(t)^2.
%
% Because of the noise N(t), the variation in Y(t) due to this noise
% is unexplanable by any model. The variation of Y(t) is then
% VAR(Y,1) == VAR(F,1) + VAR(N,1). 
%
% The goodness of fit GF describes how much of this explanable variance
% of Y (which is the variance of F) is explained by a fit H.
%
% Ref: DiCarlo JJ, Johnson KO, Hsaio SS. J Neurosci 1988:
% Structure of Receptive Fields in Area 3b of Primary Somatosensory Cortex in the Alert Monkey
%
% This function accepts name/value pairs that alter its behavior:
% Parameter (default)        | Description
% ------------------------------------------------------------------------------------------
% 

%
%  [GF,Vres,Vexpl,Vnoise] = GOF(TRIALDATA, FIT)
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

