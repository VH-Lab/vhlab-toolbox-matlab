function b = dropnan(a)
% DROPNAN - return a vector with NaN entries dropped
%
%   B = vlt.data.dropnan(A)
%
%   Given a vector A, this function returns a new vector B that contains
%   all the non-NaN entries of A.
%
%   Example:
%       A = [1 2 NaN 4 5 NaN];
%       B = vlt.data.dropnan(A);
%       % B will be [1 2 4 5]
%
%   See also: ISNAN, VLT.DATA.DROPZERO
%

if min(size(a))~=1 && ~isempty(a),
	error(['This function requires a vector as input.']);
end

g = ~isnan(a);
b = a(g);

