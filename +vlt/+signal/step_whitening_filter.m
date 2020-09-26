function [Rinv,R] = step_whitening_filter(alpha, N, M)
% STEP_WHITENING_FILTER - Compute the optimal FIR filter for Wiener filtering a step 
%
%  [RINV,R] = STEP_WHITENING_FILTER(ALPHA, N, M)
%
%   Computes the inverse of the correlation matrix of a STEP signal for a Wiener filter.
%
%   Suppose we have a signal d[n], and we wish to make the best linear projection
%   y[n] from a signal x[n] onto d[n]. What is the optimal filter h[n] such that
%  
%   y[n] = sum( h[1:M] . * x[n-[1:M]] ) 
%
%   Suppose further that we know that x[n] is comprised of STEPs of
%   -1, 0, or 1, with probability alpha, 1-2*alpha, and alpha, respectively, and
%   exhibits duration N.
%
%   Then the auto-correlation matrix of the signal x[n] is returned in R.
%   R(i+1,j+1) = expectation( x[n-i] x[n-j] )
%   And Rinv is the inverse of this matrix.
%
%   This matrix can be used to find the optimal filter h[n]:
%
%   h[n] = Rinv * P, where P is the correlation of d[n] with x[n].  
%    


n = repmat([0:-1:-M+1]',1,M)+repmat([0:M-1],M,1);

R = step_autocorrelation(2*alpha, N, n); % 2*alpha because the probability the signal has a non-zero value is 2*alpha (alpha for -1, alpha for 1)

Rinv = inv(R);
