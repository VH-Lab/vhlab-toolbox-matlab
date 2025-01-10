function sub_indexes = ind2subD(matrix_size, X, N)
% IND2SUBD - retrieve the sub-indexes for only a particular dimension
%
% SUB_INDIXES = IND2SUBD(MATRIX_SIZE, X, N)
%
% Given a linear index X in a multi-dimensional matrix with dimensions specified by 
% MATRIX_SIZE, this function returns the corresponding sub-index in dimension N.
%
% Inputs:
%   MATRIX_SIZE: A vector specifying the size of each dimension of the matrix.
%   X: The linear index.
%   N: The dimension for which to return the sub-index.
%
% Output:
%   SUB_INDEXES: The sub-index in dimension N, in uint64 format.

if N < 1 || N > numel(matrix_size)
    error('Invalid dimension N.');
end

stride = prod([1 matrix_size(N-1:-1:1)]);

sub_indexes = uint64(round(mod(floor( (double(X) - 1)/ stride), matrix_size(N) ) + 1));

