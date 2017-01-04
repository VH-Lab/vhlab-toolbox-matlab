function [p,v,df] = chi2uniformtest(D)
% CHI2UNIFORMTEST - Test for uniformity of distribution of data in bins
%
%  [P,V,DF] = CHI2UNIFORMTEST(D)
%
%  For data classified in discrete bins D(1), D(2), this returns the
%  probability of the null hypothesis that the "true" number of data
%  points in D(1) == D(2) == D(3) etc and that the observed differences are
%  due to statistical sampling.
%  

E = sum(D)/length(D);

v = sum( ((D-E).^2)./(E^2));

df = length(D) - 1;

p = 1-chi2cdf(v,df);
