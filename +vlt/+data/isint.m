function b = isint(X)

% VLT.DATA.ISINT - Check if a matrix contains only integers
%
%   B = vlt.data.isint(X)
%
%   Returns 1 if the input matrix X contains only integer values.
%   Otherwise, it returns 0.
%
%   Example:
%       vlt.data.isint([1 2 3])      % returns 1
%       vlt.data.isint([1 2.5 3])    % returns 0
%
%   See also: ISINTEGER, ISNUMERIC, ISREAL, FIX
%

if isnumeric(X) && isreal(X),
    b = all(X(:)==fix(X(:)));
else,
    b = false;
end;
