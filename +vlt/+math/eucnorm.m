function [d] = eucnorm(x)
% EUCNORM(X)
%
%   d = vlt.math.eucnorm(X)
%
%  Returns the Euclidean norm for each column in X.
%

xx = x.*x;
d = sum(xx,1)./sqrt(sum(xx,1));
