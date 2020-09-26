function y = asymmetric_gaussian(x, a, b, c, d, e)
% ASYMMETRIC_GAUSSIAN - Compute an assymmetric gaussian curve
%
%   Y = ASYMMETRIC_GAUSSIAN(X, a, b, c, d, e)
%
%   where X are the values of X at which to evaluate the function,
%   and a b c d e are the parameters of the function:
% 'a+b*exp(-((x-c).^2)/((heaviside(x-c)*(2*d^2)+(1-heaviside(x-c))*(2*(d^2)*e))))'
%
%  This function with no input arguments returns the string above.

if nargin==0,
	y = 'a+b*exp(-((x-c).^2)/((heaviside(x-c)*(2*d^2)+(1-heaviside(x-c))*(2*(d^2)*e))))'
	return;
end;

y = a+b*exp(-((x-c).^2)./((heaviside(x-c)*(2*d^2)+(1-heaviside(x-c))*(2*(d^2)*e))));
