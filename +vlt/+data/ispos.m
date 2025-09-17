function b = ispos(x)
% VLT.DATA.ISPOS - Check if a matrix contains only positive numbers
%
%   B = vlt.data.ispos(X)
%
%   Returns 1 if all elements of the input matrix X are positive numbers.
%   Otherwise, it returns 0.
%
%   Example:
%       vlt.data.ispos([1 2 3])    % returns 1
%       vlt.data.ispos([1 0 3])    % returns 0
%       vlt.data.ispos([-1 2 3])   % returns 0
%
%   See also: ISNUMERIC, ISREAL, ALL
%

b = 0;
if (isnumeric(x)&isreal(x)),b=all(x>0);end;
