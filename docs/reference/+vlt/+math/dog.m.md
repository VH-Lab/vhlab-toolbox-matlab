# vlt.math.dog

```
  vlt.math.dog - difference of gaussians
 
  Y = vlt.math.dog(X,P_DOG)
 
  Given parameters for a difference of gaussians function: P_DOG = [ a1 b1 a2 b2], returns
  vlt.math.dog(X,P_DOG) = [ a1*exp(-X.^2/(2*b1^2) - a2*exp(-X.^2/(2*b2^2)) ]
 
  See also: vlt.math.dog2dogf

```
