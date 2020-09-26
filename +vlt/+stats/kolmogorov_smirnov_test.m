function [pval,ks] = kolmogorov_smirnov_test(x,hyp,dist,varargin)

% vlt.stats.kolmogorov_smirnov_test Kolmogorov-smirnov test
%
% [PVAL.KS] = vlt.stats.kolmogorov_smirnov_test(X,HYP,DIST,PARAMS)
%
% Computes liklihood data X were generated by distribution DIST with
% parameters PARAMS.  Three alternative hypotheses (HYP) are available:
%  'notequal' (the data are not equal)
%  '<' X < DIST w/ parameters PARAMS
%  '>' X > DIST w/ parameters PARAMS
%
% See CDF for information about legal DIST names and parameters.
%
% Ported from Octave version 2.1.35

n = length (x);
s = sort (x);

z = reshape(cdf(dist,s,varargin{:}),1,n);

if strcmp(hyp,'notequal'),
  ks = sqrt (n) * max (max ([abs(z - (0:(n-1))/n); abs(z - (1:n)/n)]));
  pval = 1-vlt.stats.kolmogorov_smirnov_cdf(ks);
elseif strcmp(hyp,'>'),
  ks   = sqrt (n) * max (max ([z - (0:(n-1))/n; z - (1:n)/n]));
  pval = exp (- 2 * ks^2);
elseif strcmp(hyp,'<'),
  ks   = - sqrt (n) * min (min ([z - (0:(n-1))/n; z - (1:n)/n]));
  pval = exp (- 2 * ks^2);
else, error(['Unknown hypothesis ' hyp '.']);
end;
