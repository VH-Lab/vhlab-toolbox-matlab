function i = findrowvec(a,b)
% FINDROWVEC - finds the occurrence of a complete row in a matrix
%
%   I = vlt.data.findrowvec(A,B)
%
%   Finds all rows in matrix A that are identical to the row vector B.
%
%   Inputs:
%   'A' is a matrix.
%   'B' is a row vector with the same number of columns as A.
%
%   Output:
%   'I' is a column vector containing the indices of the matching rows.
%
%   Example:
%       A = [1 2 3; 4 5 6; 1 2 3];
%       B = [1 2 3];
%       I = vlt.data.findrowvec(A, B);
%       % I will be [1; 3]
%
%   See also: FIND, REPMAT, ALL
%

if isempty(a),
	i = [];
	return;
end;

[na,ma] = size(a);
[nb,mb] = size(b);

if nb~=1,
	error(['B must be a row vector.']);
end;

if ma~=mb,
	error(['A and B must have the same number of columns.']);
end;

i = find( all(a==repmat(b,na,1), 2) );

