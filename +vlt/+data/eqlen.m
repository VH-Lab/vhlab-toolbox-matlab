function b = eqlen(x,y)

% VLT.DATA.EQLEN - Check if two variables are equal in both size and content
%
%   B = vlt.data.eqlen(X,Y)
%
%   Returns 1 if and only if X and Y have the same size and all of their
%   corresponding entries are equal.
%
%   This function is useful for ensuring that two variables are truly
%   identical, as opposed to the element-wise comparison of '==' which
%   can return true for arrays of different sizes.
%
%   Example:
%       vlt.data.eqlen([1], [1 1])      % returns 0
%       vlt.data.eqlen([1 1], [1 1])    % returns 1
%       vlt.data.eqlen([], [])          % returns 1
%
%   See also: vlt.data.eqtot, vlt.data.eqemp, vlt.data.sizeeq, EQ
%

if vlt.data.sizeeq(x,y),
	b = vlt.data.eqtot(x,y);
else,
	b = false;
end;

