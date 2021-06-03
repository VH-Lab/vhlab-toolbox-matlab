# vlt.fit.tanhfit

```
  TANHFIT - Fit a curve with a hyperbolic tangent tanh
  
  [FIT_CURVE, PARAMS, GOF, FITINFO] = vlt.fit.tanhfit(X, Y, ...)
 
  Finds a, b, c, d such that the error in the equation 
 
       Y = a + b * TANH( (X-c) / d)
 
  is minimized in the least-squares sense.
 
  FIT_CURVE is a fit curve that is 100x2 (by default, see below)
  where FIT_CURVE(:,1) is 100 equally spaced points between min(X)
  and max(X), and FIT_CURVE(:,2) is the result of the fit.]
  PARAMS is the parameters returned from Matlab's FIT function.
 
   
 
  This function also takes additional parameters in the form of name/value
  pairs.
  Parameter (default)     | Description
  ---------------------------------------------------------------
  NPTS_CURVE (100)        | Number of points to produce in the fit
  a_range [-Inf Inf]      | Search range for fit parameter a
  b_range [0 Inf]         | Search range for fit parameter b
  c_range [-100 100]      | Search range for fit parameter c
  d_range [1e-12 Inf]     | Search range for fit parameter d
  startPoint [0 1 0 1]    | Starting point for the search
 
  Jason Osik 2016-2017
 
  See also: FIT, FITTYPE

```
