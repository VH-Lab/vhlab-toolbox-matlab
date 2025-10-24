function b = isboolean(x)

%  B = vlt.data.isboolean(X)
%
%  Returns 1 iff X is a matrix of 0's and 1's or a logical matrix.

b = 0;
if isnumeric(x) || islogical(x), b=all( (x(:)==0) | (x(:)==1) ); end;
