function b = dropzero(a)
% DROPZERO - return a vector with zero entries dropped
%
% B = vlt.data.dropzero(A)
%
% Given a vector A, this function returns a vector B, which will have
% all non-zero entries of A but will exclude zero entries.
%
% This function now uses a custom arguments block for validation that
% accepts empty vectors.
%

arguments
    a {vlt.validators.mustBeVectorOrEmpty}
end

g = ~(a==0);
b = a(g);
