function b = eqemp(x,y)

% VLT.DATA.EQEMP - Compare two variables, with special handling for empty values
%
%   B = vlt.data.eqemp(X,Y)
%
%   Compares two variables X and Y.
%   - If both X and Y are not empty, it returns the result of X == Y.
%   - If both X and Y are empty, it returns 1 (true).
%   - Otherwise (if one is empty and the other is not), it returns 0 (false).
%
%   Note: An error will occur if the '==' operator is not defined for the
%   data types of X and Y.
%
%   Example:
%       vlt.data.eqemp([], [])          % returns 1
%       vlt.data.eqemp([1 2], [1 2])    % returns [1 1]
%       vlt.data.eqemp([1 2], [])        % returns 0
%
%   See also: EQ, vlt.data.eqtot, vlt.data.eqlen
%

if isempty(x) && isempty(y),
    b = true;
elseif isempty(x) || isempty(y),
    b = false;
else,
    b = (x==y);
end
