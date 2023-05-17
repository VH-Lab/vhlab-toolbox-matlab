function y = gausslog(x, p)
% GAUSSLOG - calculate the gaussian log function
%
% Y = GAUSSLOG(X, P)
%
% Evaluates 
%    Y = a+b*exp((log10(x)-log10(c)).^2/(2*d^2))
%
% a is an offset parameter; b is a height parameter above the offset;
% c is the peak location; d is the width; e is the degree of skewness (0 is none)
% 
% The parameters are specified in a vector P = [a b c d]
% 
% See also: vlt.fit.gausslogfit
%

a = p(1);
b = p(2);
c = p(3);
d = p(4);

y = a+b*exp(-((log10(x)-log10(c)).^2)/((2*d^2)));
