function V = complex2vector(C)

% COMPLEX2VECTOR - Convert a complex variable into a 2D vector
%
%  V = COMPLEX2VECTOR(C)
%
%  Converts a complex quantity C = A + sqrt(-1) * B into a vector
%  V = [A B].
%

V = [real(C) imag(C)];
