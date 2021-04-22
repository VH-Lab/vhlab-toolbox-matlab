function b = dropzero(a)
% DROPZERO - return a vector with zeroentries dropped
%
% B = vlt.data.dropzero(A)
%
% Given a vector A, this function will return a vector B, which will have
% all non-zero entries of A but will exclude zero entries.
%

if min(size(a))~=1,
	error(['This function requires a vector as input.']);
end

g = ~(a==0);
b = a(g);

