function b = isboolean(x)

% VLT.DATA.ISBOOLEAN - Check if a matrix contains only 0s and 1s
%
%   B = vlt.data.isboolean(X)
%
%   Returns 1 if the input matrix X contains only the values 0 and 1.
%   Otherwise, it returns 0.
%
%   Example:
%       vlt.data.isboolean([0 1 0 1])   % returns 1
%       vlt.data.isboolean([0 1 2])     % returns 0
%
%   See also: ISLOGICAL, ALL
%

if isnumeric(x),
	b=all(x(:)==0 | x(:)==1);
else,
	b = false;
end;
