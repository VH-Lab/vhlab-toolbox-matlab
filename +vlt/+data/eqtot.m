function b = eqtot(x,y)

% VLT.DATA.EQTOT - Check if two variables are totally equal
%
%   B = vlt.data.eqtot(X,Y)
%
%   This function checks for equality between two variables X and Y. It first
%   calls vlt.data.eqemp(X,Y). If the result is an array of boolean values, it
%   returns the logical AND of all the results.
%
%   This is useful for determining if two arrays are identical in content,
%   even if their sizes differ (in which case '==' would produce an error).
%
%   Example:
%       vlt.data.eqtot([4 4 4], [4 4 4])   % returns 1
%       vlt.data.eqtot([1], [1 1])         % returns 1, because [1]==[1 1] is [true true]
%
%   See also: vlt.data.eqemp, vlt.data.eqlen, EQ
%

b=double(vlt.data.eqemp(x,y));
b=prod(reshape(b,1,prod(size(b))));
