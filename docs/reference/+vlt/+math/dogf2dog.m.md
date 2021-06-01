# vlt.math.dogf2dog

  vlt.math.dogf2dog - convert difference of gaussian parameters in frequency space to real space 
 
  P_DOG = vlt.math.dogf2dog(P_DOGF)
 
  Given parameters for a difference of gaussians function in frequency space, where f is cycles/units
  P_DOGF = [ a1 b1 a2 b2], where
  vlt.math.dog(F,P_DOG) = [ a1*exp(-f.^2/(2*b1^2)) - a2*exp(-f.^2/(2*b2^2)) ], 
  this function computes the parameters for calculating the curve in real space (1/f units)
  which is
 
  sqrt(2*pi)*[a1*b1*exp(-0.5*b1^2*x^2)-a1*b2*exp(-0.5*b2^2*x^2)
 
  This function is itself a difference of gaussian function. Therefore, to express these values in 
  terms of the original P_DOG, the parameters are converted to be
  P_DOGF = [sqrt(2*pi)*a1*b1 1/(2*pi*b1) sqrt(2*pi)*a2*b2 1/(2*pi*b2)]
 
  Through the miracle of math, this function is also it's own inverse:
  p_dog = vlt.math.dog2dofg(vlt.math.dog2dogf(p_dog))
 
  This function just calls vlt.math.dog2dogf, as it is its own inverse.
 
  See also: vlt.math.dog, vlt.math.dog2dogf
