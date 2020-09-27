function V = complex2vector(C)

% vlt.math.complex2vector - Convert a complex variable into a 2D vector
%
%  V = vlt.math.complex2vector(C)
%
%  Converts a complex quantity C = A + sqrt(-1) * B into a vector
%  V = [A B].
%

V = [real(C) imag(C)];
