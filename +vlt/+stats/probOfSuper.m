function p = probOfSuper(A, B)
% vlt.stats.probOfSuper - Probability of Superiority of B over A
%
% P = vlt.stats.probOfSuper(A, B)
%
% Calculates the probability that a randomly selected element from vector B
% is greater than a randomly selected element from vector A.
%
% P = P(B > A) + 0.5 * P(B == A)
%
% This metric is also known as the Common Language Effect Size (CLES) or
% the Area Under the Receiver Operating Characteristic Curve (AUC).
%
% It is calculated using the U-statistic from the Mann-Whitney U test.
%
% Inputs:
%   A - a numeric vector of data points for group A
%   B - a numeric vector of data points for group B
%
% Outputs:
%   P - The probability of superiority (scalar double between 0 and 1).
%       If either A or B is empty (after removing NaNs), NaN is returned.
%
% Example:
%   A = [1, 2, 3];
%   B = [2, 3, 4];
%   p = vlt.stats.probOfSuper(A, B);
%
% See also: vlt.stats.ranks2, vlt.stats.mwustat

arguments
    A double {mustBeReal}
    B double {mustBeReal}
end

% Force column vectors
A = A(:);
B = B(:);

% Remove NaNs
A(isnan(A)) = [];
B(isnan(B)) = [];

nA = length(A);
nB = length(B);

if nA == 0 || nB == 0
    p = NaN;
    return;
end

% Combine data
data = [A; B];

% Compute ranks (handling ties)
% Using vlt.stats.ranks2 which is O(N log N) but assumes ties are rare.
% If precision requires it, we could use vlt.stats.ranks (O(N^2)).
% Given general use, ranks2 is preferred for performance.
all_ranks = vlt.stats.ranks2(data);

% Ranks corresponding to B (B was appended after A)
ranksB = all_ranks(nA + 1 : end);

% Calculate U statistic for B
% U_B = Sum(Ranks_B) - nB*(nB+1)/2
sumRankB = sum(ranksB);
U_B = sumRankB - (nB * (nB + 1)) / 2;

% Probability of Superiority
p = U_B / (nA * nB);

end
