function [Xhat, Yhat] = imposeCorrelationByReordering(X, Y, c)
% IMPOSECORRELATIONBYREORDERING - Re-pairs vectors X and Y to have a specified rank correlation.
%
%   [Xhat, Yhat] = vlt.stats.power.imposeCorrelationByReordering(X, Y, c)
%
%   Re-orders the pairings of the elements in X and Y to produce two new
%   vectors, Xhat and Yhat, that have a Spearman's (rank) correlation
%   approximately equal to the target value 'c'.
%
%   This method is particularly useful for generating surrogate data for power
%   analysis because it exactly preserves the marginal distributions of X and Y.
%   That is, the set of values in Xhat is identical to the set of values in X,
%   and the same for Y; only the (x_i, y_i) pairings are modified.
%
%   The algorithm works by:
%   1. Generating two temporary, normally-distributed vectors ('A' and 'B')
%      that have a Pearson correlation of 'c'. This pair is known as a
%      Gaussian copula and serves as a template for the rank structure.
%   2. Sorting the original data X and Y.
%   3. Re-ordering the sorted X and Y data according to the rank order of
%      the temporary vectors A and B, respectively.
%
%   Inputs:
%     X - A numerical vector (Nx1 or 1xN).
%     Y - A numerical vector with the same number of elements as X.
%     c - A scalar value between -1 and 1 representing the desired
%         Spearman's rank correlation coefficient.
%
%   Outputs:
%     Xhat - The re-paired X data. It contains the exact same values as X.
%     Yhat - The re-paired Y data. It contains the exact same values as Y.
%
%   Example:
%     % 1. Create two independent, non-normal datasets
%     n_samples = 500;
%     X_orig = rand(n_samples, 1).^3; % Skewed right
%     Y_orig = gamrnd(2, 1, n_samples, 1); % Gamma distributed
%
%     % 2. Check their initial correlation (should be near 0)
%     fprintf('Initial Spearman corr: %.4f\n', corr(X_orig, Y_orig, 'Type', 'Spearman'));
%
%     % 3. Impose a new correlation of -0.8
%     target_corr = -0.8;
%     [X_new, Y_new] = vlt.stats.power.imposeCorrelationByReordering(X_orig, Y_orig, target_corr);
%
%     % 4. Verify the result
%     final_corr_s = corr(X_new, Y_new, 'Type', 'Spearman');
%     fprintf('Target Spearman corr:  %.4f\n', target_corr);
%     fprintf('Final Spearman corr:   %.4f\n', final_corr_s);
%
%     % 5. Verify that the marginals are preserved
%     disp(['Values of X preserved: ' num2str(all(sort(X_orig)==sort(X_new)))]);
%     disp(['Values of Y preserved: ' num2str(all(sort(Y_orig)==sort(Y_new)))]);
%
%     % 6. Plot to visualize
%     figure;
%     subplot(1, 2, 1);
%     scatter(X_orig, Y_orig, 'filled');
%     title('Original (Independent)');
%     xlabel('X'); ylabel('Y');
%
%     subplot(1, 2, 2);
%     scatter(X_new, Y_new, 'r', 'filled');
%     title(['New (Correlated \rho_s \approx ' num2str(target_corr) ')']);
%     xlabel('Xhat'); ylabel('Yhat');
%
%   See also: CORR, SORT, RANDN, COPULARND

% --- Input Validation ---
if numel(X) ~= numel(Y)
    error('Vectors X and Y must have the same number of elements.');
end

if ~isscalar(c) || c < -1 || c > 1
    error('Target correlation c must be a scalar between -1 and 1.');
end

% Ensure inputs are column vectors for consistency
X = X(:);
Y = Y(:);
n_samples = numel(X);

% --- 1. Generate the Gaussian Copula (Rank Structure Template) ---
% Create two correlated, normally-distributed variables, A and B.
A = randn(n_samples, 1);
Noise = randn(n_samples, 1);
B = c * A + sqrt(1 - c^2) * Noise;

% --- 2. Get the Rank Order from the Copula ---
% We only need the indices that would sort A and B.
[~, idx_A] = sort(A);
[~, idx_B] = sort(B);

% --- 3. Sort the Original Data ---
X_sorted = sort(X);
Y_sorted = sort(Y);

% --- 4. Re-order Original Data using the Copula's Rank Structure ---
% Pre-allocate output arrays.
Xhat = zeros(n_samples, 1);
Yhat = zeros(n_samples, 1);

% This is the core step: we "un-sort" the original data according to the
% rank ordering of the copula. For example, the smallest value of X is placed
% in the position where the smallest value of A was found.
Xhat(idx_A) = X_sorted;
Yhat(idx_B) = Y_sorted;

end
