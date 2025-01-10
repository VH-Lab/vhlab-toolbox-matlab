function [rho, rho_perm, percentile] = corrcoefResample(X, Y, N)
%CORRCOEFRESAMPLE Calculates the correlation coefficient and its significance using resampling.
%
%   [RHO, RHO_PERM, PERCENTILE] = CORRCOEFRESAMPLE(X, Y, N) calculates the
%   Pearson correlation coefficient RHO between vectors X and Y. It then
%   performs N resamples by permuting X and calculating the correlation
%   coefficient with Y for each permutation, storing the results in RHO_PERM.
%   Finally, it calculates the percentile of the actual RHO within the
%   distribution of RHO_PERM.
%
%   Inputs:
%       X         - A vector of data.
%       Y         - Another vector of data with the same length as X.
%       N         - The number of resamples to perform.
%
%   Outputs:
%       rho       - The Pearson correlation coefficient between X and Y.
%       rho_perm  - A vector of N correlation coefficients calculated from
%                   permutations of X.
%       percentile - The percentile of RHO within the distribution of RHO_PERM.

arguments
  X (:,1) double {mustBeVector}
  Y (:,1) double {mustBeVector, mustBeEqualSize(X,Y)}
  N (1,1) double {mustBeInteger, mustBePositive}
end

% Calculate the actual correlation coefficient
rho = corrcoef(X, Y);
rho = rho(1, 2);  % Extract the relevant value from the matrix

% Preallocate the array for permutation results
rho_perm = zeros(N, 1);

% Perform resampling
for i = 1:N
  % Permute X
  X_perm = X(randperm(length(X)));
  
  % Calculate the correlation coefficient with the permuted X
  rho_here = corrcoef(X_perm,Y);
  rho_perm(i) = rho_here(1,2);
end

% Calculate the percentile of the actual rho in the permutation distribution
percentile = sum(rho_perm >= rho) / N * 100;

end
