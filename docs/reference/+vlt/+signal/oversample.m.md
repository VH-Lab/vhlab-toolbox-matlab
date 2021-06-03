# vlt.signal.oversample

```
  OVERSAMPLE - Calculate sample values for oversampling
 
    XN = vlt.signal.oversample(X, N)
 
   For a signal X that takes values X(1), X(2), etc, this function
   calculates the linearly interpolated values of X with N times
   oversampling. 
 
   Example:
       X = [ 0 1];
       Xn = vlt.signal.oversample(X,5) % Xn is [0 0.25 0.5 0.75 1.0]

```
