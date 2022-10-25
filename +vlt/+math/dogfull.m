function y = dogfull(x, p)
% vlt.math.dog - Difference of gaussian function evaluation
%
% Y = vlt.math.dogfull(X, [A B C D E F G])
%
% Evalutes the full difference of gaussian function for the given
% values of X:
%
% Y(X) = A + B*exp(-((X-C).^2)/D^2) - E*exp(-((X-F).^2)/G^2)
%
% Differs from vlt.math.dog in that nonzero values of C and F are
% permitted. (C and F are not parameters in vlt.math.dog; they must be 0.)
%

A = p(1);
B = p(2);
C = p(3);
D = p(4);
E = p(5);
F = p(6);
G = p(7);

y = A + B*exp(-((x-C).^2)/D^2) - E*exp(-((x-F).^2)/G^2);

