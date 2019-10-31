function [p,chi2,E] = chi2class(D)
% CHI2CLASS - Tests whether observations are distributed equally among classes
%  
%   [P,CHI2,E] = CHI2CLASS(D)
%
%   Returns the p value and chi-square value of the test of the null
%   hypothesis that cells are distributed equally among classes in several
%   groups.  E is the expected number of members of each group if there
%   are no differences among the experimental groups.
%
%   D should be the grouping matrix.  Each row of D should have the
%   class memberships for an experimental group.
%
%   Example:  Suppose we want to examine whether the gender distribution
%   of computer science majors differs from that of English majors in a 
%   small college.  Suppose that there are 90 male and 10 female computer
%   science majors and 40 male and 60 female English majors.
%
%   D = [ 90 10 ; 40 60 ];
%   [p,chi2,E] = chi2class(D)
%
%   

[c,r]=size(D);rsum=sum(D')';csum=sum(D);T=sum(sum(D));df=(r-1)*(c-1);
E = repmat(csum,c,1).*repmat(rsum,1,r)/T;
chi2=sum(sum((D-E).*(D-E)./E));
p=1-chi2cdf(chi2,df);
