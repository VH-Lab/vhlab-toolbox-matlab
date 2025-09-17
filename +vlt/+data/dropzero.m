function b = dropzero(a)
% DROPZERO - return a vector with zeroentries dropped
%
%   B = vlt.data.dropzero(A)
%
%   Given a vector A, this function returns a new vector B that contains
%   all the non-zero entries of A.
%
%   Example:
%       A = [1 2 0 4 5 0];
%       B = vlt.data.dropzero(A);
%       % B will be [1 2 4 5]
%
%   See also: VLT.DATA.DROPNAN
%

if min(size(a))~=1,
	error(['This function requires a vector as input.']);
end

g = ~(a==0);
b = a(g);

