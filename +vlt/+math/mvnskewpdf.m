function Y = mvnskewpdf(X, Mu, Sigma, alpha)
% MVNSKEWPDF - Multivariate normal skewed probability density function (pdf)
%  Y=vlt.math.mvnskewpdf(X,MU,SIGMA,ALPHA) returns the probability density of the multivariate
%  normal distribution with mean MU, covariance SIGMA, and skewness ALPHA, evaluated at
%  each row of X. Rows of the N-by-D matrix X correspond to observations (or points), and 
%  columns correspond to variables or coordinate. Y is an N by 1 vector.
%
%  The multivariate skewed distribution is defined as in Azzalini and Dalla Valle (1996):
%
%   For each value of x:
%   vlt.math.mvnskewpdf(X,MU,SIGMA,ALPHA) = 2*MVNPDF(X, MU, SIGMA) * NORMCDF(ALPHA'*(X-MU)')
%

[N,D] = size(X);

n = alpha' * [ X-repmat(Mu(:)',N,1)  ]';

Y = 2 * mvnpdf(X,Mu,Sigma) .* normcdf(n(:),0,1);


