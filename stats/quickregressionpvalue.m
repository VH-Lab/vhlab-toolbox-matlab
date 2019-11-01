function [p] = quickregressionpvalue(x,y, num_steps)

% QUICKREGRESSSIONPVALUE - Estimate p value of the null hypothesis that slope==0
%
% P = QUICKREGRESSIONPVALUE(X,Y,[NUM_STEPS])
%
% Takes NUM_STEPS to estimate the P value that the slope of the regression
% line between X and Y is 0.  This estimate is made by calling QUICKREGRESSION
% with different ALPHA values, and examining the confidence intervals.
%
% If NUM_STEPS is not provided, 30 steps are taken.
%       
% NAN entries are ignored.
%
% See also: QUICKREGRESSION, REGRESS

if nargin<3,
	num_steps = 30;
end;

alpha_current = 0.05;
alpha_bounds = [0 1];

for i=1:num_steps,
	[dummy,dummy,slope_interval] = quickregression(x,y,alpha_current);
	if prod(slope_interval)<0, % if 0 is included, increase alpha
		alpha_bounds(1) = alpha_current;
		alpha_current = mean([alpha_current alpha_bounds(2)]);
	else, % decrease alpha
		alpha_bounds(2) = alpha_current;
		alpha_current = mean([alpha_current alpha_bounds(1)]);
	end;
end;

p = alpha_current;
