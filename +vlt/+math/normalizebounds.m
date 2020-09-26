function X = normalizebounds(data, lowerbound, upperbound)

% NORMALIZEBOUNDS - Normalize data to lower, upper bound
%
%  X = NORMALIZEBOUNDS(DATA, LOWERBOUND, UPPERBOUND)
%
% Normalizes the data as follows
%   X = (DATA-LOWERBOUND)/(UPPERBOUND-LOWERBOUND)
%
%  So points between LOWERBOUND and UPPERBOUND are projected
%  onto the interval [0..1] with points equal to LOWERBOUND set
%  to 0 and points set to UPPERBOUND equal to 1.  Note that it is
%  possible to have points out of bounds.

X = (data-lowerbound)/(upperbound-lowerbound);

