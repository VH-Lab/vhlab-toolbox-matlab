function b = sizeeq(x,y)

% VLT.DATA.SIZEEQ - Check if two variables have the same size
%
%   B = vlt.data.sizeeq(X,Y)
%
%   Returns 1 if the size of variables X and Y are identical.
%   Otherwise, it returns 0.
%
%   Example:
%       vlt.data.sizeeq([1 2], [3 4])      % returns 1
%       vlt.data.sizeeq([1 2], [3; 4])     % returns 0
%
%   See also: SIZE, EQLEN
%

b = isequal(size(x),size(y));
