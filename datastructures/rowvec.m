function y = rowvec(x)
% ROWVEC - return a matrix reshaped as a row vector
%
%  Y = ROWVEC(X)
%
%  Returns the contents of the matrix X as a row vector Y that is Mx1,
%  where M is the product of all the sizes of the dimensions of X
%  (M = PROD(SIZE(X))).
% 
%  ROWVEC is equivalent to Y = X(:)';
%
%  This function is useful for addressing all of the elements of a matrix
%  as a vector when X is a subset of another matrix.
%
%  See also: COLVEC
%
%  Example: 
%    A = rand(5,5)
%    Y = rowvec(A(1:3,1:2)) % returns points in rows 1:3, columns 1:2
%

y = x(:)';
