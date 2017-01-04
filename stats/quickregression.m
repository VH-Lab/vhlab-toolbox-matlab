function [slope, offset, slope_interval, resid, residint, stats ] = quickregression(x,y, alpha)

% QUICKREGRESSSION - Computes best fit to a line and confidence interval on
% slope
%
% [SLOPE,OFFSET,SLOPE_CONFINTERVAL, ...
%       RESID, RESIDINT, STATS] = QUICKREGRESSION(X,Y, ALPHA)
%
%  Returns the best fit Y = SLOPE * X + OFFSET
%
%  Also returns (1-ALPHA) confidence intervals around SLOPE and residuals,
%  residual intervals, and STATS.
%
%  NAN entries are ignored.
%
%  See also: POLYFIT, REGRESS, QUICKREGRESIONPVALUE

nnaninds = find((~isnan(x))&(~isnan(y)));
x = x(nnaninds);
y = y(nnaninds);

[pn,sn] = polyfit(x,y,1);

slope = pn(1); offset = pn(2);

[sl,slope_interval,resid, residint, stats]=regress(y-pn(2),x,alpha);
