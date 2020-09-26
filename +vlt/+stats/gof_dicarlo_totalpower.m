function [gf, ws] = gof_dicarlo_totalpower(rawdata, fit, numfitparams, varargin)
% GOF_DICARLO_TOTALPOWER - Goodness of Fit from DiCarlo et al. 1988
%
% [GF, WS] = GOF_DICARLO_TOTALPOWER(RAWDATA, FIT, NUMFITPARAMS)
%
% Computes an analog to the "explanable variance" goodness-of-fit in
% DiCarlo et al. 1988, except using the total power of a response and
% fit (not sum of squares around the mean).
%
% Imagine a measured process Y(t) reflects some underlying
% function F(t) plus noise (due to measurement or process)
% N(t). Then the sum of squares (Y(t)^2) for all t is
% (Y(t)^2) = (F(t)^2) + (N(t))^2 + 2*F(t)*N(t). If we further
% assume that the expected value of N(t) is 0, then on average
% (Y(t)^2) = F(t)^2 + N(t)^2.
%
% Because of the noise N(t), the power (signal around 0) in Y(t) due to
% this noise is unexplanable by any model. The power of Y(t) is then
% Y(t).^2 == F(t).^2 + N(t).^2 but the explanable power (power of F) is
% F(t).^2 == Y(t).^2 - N(t).^2
%
% The goodness of fit GF describes how much of this explanable power
% of Y (which is the power of F) is explained by a fit H.
%
% GF = (FIT_EXPLAINED_POWER)/(EXPLANABLE_POWER)
%
% The entire workspace is returned as a structure in WS.
%
% Related to:
% Ref: DiCarlo JJ, Johnson KO, Hsaio SS. J Neurosci 1988:
% Structure of Receptive Fields in Area 3b of Primary Somatosensory Cortex in the Alert Monkey
%
% This function accepts name/value pairs that alter its behavior:
% Parameter (default)        | Description
% ------------------------------------------------------------------------------------------
% NoiseEstimation ('median') | How will we estimate the noise? Can be 'median' or 'std'.
%                            |   If it is 'median', then STD_FROM_MEDIAN(X) is used.
%                            |   If it is 'STD', then STD(X) is used.
%
%

NoiseEstimation = 'median';

assign(varargin{:});

res = fit-rawdata;

switch lower(NoiseEstimation),
	case 'median',
		sd = std_from_median(res);
	case 'std',
		sd = std(res);
	otherwise,
		error(['Unknown noise estimation method ''' NoiseEstimation '''.']);
end;

total_power = sum(rawdata.*rawdata)/size(rawdata,1);
fit_power = sum(fit.*fit)/size(rawdata,1);
noise_power = sd.^2; % the expected value of a gaussian process squared is its variance, duh

numdatapoints = size(rawdata,1);

discount = 0*numfitparams/size(rawdata,1);

explainable_power = total_power - noise_power;       % the amount of variation that could possibly be explained by the fit (that is, not due to independent noise)
fit_explained_power = fit_power - discount*noise_power;  % the amount of variation that is explained by the fit not due to noise

gf = fit_explained_power/explainable_power;

ws = rmfield(workspace2struct,{'rawdata','fit','numfitparams'});


