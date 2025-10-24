function b = isint(X)

%  B = ISINT(X)
%
%  B = 1 iff X is a matrix of integers.

b=0;
if (isnumeric(X)&isreal(X)),b=all(isfinite(X(:)))&all(X(:)==fix(X(:)));end;
