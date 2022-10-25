function y = dog(x,p_dog)
% vlt.math.dog - difference of gaussians
%
% Y = vlt.math.dog(X,P_DOG)
%
% Given parameters for a difference of gaussians function:
% 
%    P_DOG = [ a1 b1 a2 b2],
% 
% returns
% vlt.math.dog(X,P_DOG) = [ a1*exp(-X.^2/(2*b1^2) - a2*exp(-X.^2/(2*b2^2)) ]
%
% See also: vlt.math.dog2dogf
%

a1 = p_dog(1);
b1 = p_dog(2);
a2 = p_dog(3);
b2 = p_dog(4);

y = a1*exp(-x.^2/(2*b1^2)) - a2*exp(-x.^2/(2*b2^2));

