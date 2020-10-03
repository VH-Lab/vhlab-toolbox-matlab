function b = dropnan(a)
% DROPNAN - return a vector with NaN entries dropped
%
% B = vlt.data.dropnan(A)
%
% Given a vector A, this function will return a vector B, which will have
% all non-NaN entries of A but will exclude NaN entries.
%

if min(size(a))~=1,
	error(['This function requires a vector as input.']);
end

g = ~isnan(a);
b = a(g);

