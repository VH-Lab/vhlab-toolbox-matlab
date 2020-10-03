function [sd] = std_from_median(x, varargin)
% STD_FROM_MEDIAN - calculate standard deviation of gaussian process from median
%
% SD = vlt.stats.std_from_median(X, ...)
%
% Estimates the standard deviation SD of a gaussian process that generated
% samples X using the median method.
%
% SD = MEDIAN(ABS(X),...)/0.6745
%
% Any additional arguments to vlt.stats.std_from_median are passed to MEDIAN, so
% that the median can be taken across rows, columns, or other dimensions
% (see HELP MEDIAN).
%
% Proof: 
%   Recall: the median is the 0.5 point of a cumulative density function.
%   The cumulative density function for a gaussian-distributed random variable
%   is 0.5 * [1 + ERF(X/SQRT(2*sd^2))]. This CDF is based on the symmetry of
%   the ERF() function. It starst at 0.5 and adds or substracts the value of
%   ERF as necessary. For the CDF of the absolute value of X, we can simply take
%   twice the portion that depends on ERF(X):
%   CDF(|X|) = ERF(X/(SQRT(2*SD^2))). Now we want to find the X that corresponds
%   to the median or:
%   CDF(|X|) == 0.5 == ERF(X/SQRT(2*SD^2)). 
%   Let x = N * SD. Then,
%   0.5 == ERF(N*SD/SQRT(2*SD^2)) == ERF(N/SQRT(2)). This is solved
%   numerically and N = 0.6745. So at the median X is 0.6745 * SD.
%   Analyically, MEDIAN(|X|) = 0.6745 * SD, or SD = MEDIAN(|X|)/0.6745.
%   
% Ref:  Quiroga RQ, Nadasdy Z, Ben-Shaul Y.
%       Neural Comput. 2004 Aug;16(8):1661-87.
%       Unsupervised spike detection and sorting with wavelets and
%       superparamagnetic clustering.
%
% See also: MEDIAN

sd = median(abs(x),varargin{:})/0.6745;
