function [sd, sde] = sample_difference_error(x1, x2, varargin)
% SAMPLE_DIFFERENCE_ERROR - calculate the uncertainty in the difference between 2 samples
%
% [SD, SDE] = vlt.math.sample_difference_error(X1, X2, ...)
%
% Computes the mean sample difference SD and the "error" or "uncertainty" in that
% difference SDE in the mean of X2 minus the mean of X1.
% 
% This function takes name/value pairs that modify the behavior of the function.
% Parameter (default)            | Description
% --------------------------------------------------------------------------------
% algorithm ('assume_normality') | If 'assume_normality', then
%                                |  uses standard error based on 'normal' assumption
%                                |  (that is, SDE = sqrt(SME1^2 + SME2^2), where
%                                |   SME is standard error of the mean.
%                                | If 'bootstrap', then 
%                                |  simulations are performed that draw from samples X1
%                                |  and X2 with replacement (sample sizes remain fixed)
%                                |  and the difference in means computed.
% bootstrap_samples (10000)      | Number of simulations to perform when bootstrap is used
% bootstrap_confidence ...       | The bootstrap confidence interval to report for SDE
%     ([cdf('norm',-1,0,1) ...   |   (the default is the percentiles that correspond to
%       cdf('norm', 1,0,1)])     |    +/-1 standard deviation around the normal
%                                |    distribution). SDE is half of this
%                                |    confidence interval.
% meanfunction ('nanmean')       | The mean function to use (could use 'nanmedian')
%
%
% Example:
%    x1 = randn(50,1) + 5;
%    x2 = randn(50,1) + 0;
%    [sd,sde]=vlt.math.sample_difference_error(x1,x2),
%    % show the bootstrap version is similar to standard when data is normally distributed
%    [sdb,sdeb]=vlt.math.sample_difference_error(x1,x2,'algorithm','bootstrap'), 


algorithm = 'assume_normality';
bootstrap_samples = 10000;
bootstrap_confidence = [ cdf('norm',-1,0,1) cdf('norm',1,0,1) ];
meanfunction = 'nanmean';

vlt.data.assign(varargin{:});

x1 = x1(:); % make a column vector
x2 = x2(:); % make a column vector

sd = feval(meanfunction,x2,1) - feval(meanfunction,x1,1);

switch lower(algorithm),
	case 'assume_normality',
		sde = sqrt(vlt.data.nanstderr(x1).^2+vlt.data.nanstderr(x2).^2);
	case 'bootstrap',
		Z1 = randi(numel(x1),numel(x1),bootstrap_samples);
		Z2 = randi(numel(x2),numel(x2),bootstrap_samples);
		mn1 = feval(meanfunction,x1(Z1),1);
		mn2 = feval(meanfunction,x2(Z2),1);
		sde = 0.5*diff(prctile(mn2-mn1,100*bootstrap_confidence));
	otherwise,
		error(['Unknown algorithm ' lower(algorithm) '.']);

end
