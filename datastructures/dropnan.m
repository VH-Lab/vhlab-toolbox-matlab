function b = dropnan(a)
% DROPNAN - return a vector with NaN entries dropped
%
% B = DROPNAN(A)
%
% Given a vector A, this function will return a vector B, which will have
% all non-NaN entries of A but will exclude NaN entries.
%

arguments
    a {mustBeNumeric, vlt.validators.mustBeVectorOrEmpty}
end

g = ~isnan(a);
b = a(g);

