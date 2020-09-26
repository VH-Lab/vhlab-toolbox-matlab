function [H,P]=hotellingt2test(X,mu,alpha)

% HOTELLINGT2TEST - Hotelling T^2 test for multivariate samples
%
%  [H,P] = HOTELLINGT2TEST(X,MU)
%  [H,P] = HOTELLINGT2TEST(X,MU,ALPHA)
%
%  Performs Hotelling's T^2 test on multivariate samples X to determine
%  if the data have mean MU.  X should be a NxP matrix with N observations
%  of P-dimensional data, and the mean MU to be tested should be 1xP.
%  ALPHA, the significance level, is 0.05 by default.
%
%  H is 1 if the null hypothesis (that the mean of X is equal to MU) can be
%  rejected at significance level ALPHA.  P is the actual P value.
%
%  The code is based on HotellingT2.m by A. Trujillo-Ortiz and
%  R. Hernandez-Walls.  That software is available at TheMathWorks
%  free file exchange site.

if nargin<3,
	alpha = 0.05;
end;

[n,p]=size(X);

m = mean(X); S = cov(X);
T2 = n*(m-mu)*inv(S)*(m-mu)';

if n>= 50, % Chi-square approximation
	X2 = T2;
        v = p;
	P = 1-chi2cdf(X2,v);
else, % F approximation
	F = (n-p)/((n-1)*p)*T2;
	v1 = p;
	v2 = n-p;
	P = 1-fcdf(F,v1,v2);
end;

H = P<alpha;
