function [d] = eucnorm(x)
% EUCNORM(X)
%
%   d = EUCNORM(X)
%
%  Returns the Euclidean norm for each column in X.
%

d = sqrt(sum(abs(x).^2,1));
