# vlt.fit.linethresholdfit

```
  LINETHRESHOLDFIT - Fit a linear function with a threshold
 
   [SLOPE, THRESHOLD, CURVE, GOF, FITINFO] = 
       vlt.fit.linethresholdfit(X, Y, ...)
 
   Performs a nonlinear fit to find the best parameters for a function of the form
   Y = SLOPE * vlt.math.rectify(X - THRESHOLD)
 
   X and Y should be vectors with the same length. SLOPE and THRESHOLD are the
   best fit values.  CURVE is the fit values of Y for the values of
   X used to generate the fit. GOF and FITINFO are the Matlab goodness-of-fit
   and fitinfo structures that are returned by the Matlab function FIT.
 
   Initial parameters and ranges can be modified by passing name/value pairs.
 
  This function can also take name/value pairs that modify default behaviors:
  Parameter (default)               | Description
  ---------------------------------------------------------------------------
  threshold_start (min(x))               | Iniitial starting point for THRESHOLD fit
  thresholdrange [(min(x)-1) max(x)+1)]  | THRESHOLD fit range
  slope_start (from vlt.stats.quickregression)     | Initial starting point for SLOPE fit
  slope_range [-Inf Inf]                 | SLOPE fit range
  
 
  Example:
      x = sort(rand(20,1));
      y = vlt.fit.linepowerthreshold(x,3,0,0.5,1);
         % limit search to exponents = 1
      [slope,t,thefit]=vlt.fit.linethresholdfit(x,y);
      figure;
      plot(x,y,'bo');
      hold on;
      plot(x,thefit,'rx-');
      box off;
      
  See also: vlt.stats.quickregression (simple linear fit), FIT, vlt.fit.linepowerthreshold, vlt.fit.linepowerthresholdfit
 
  Jason Osik and Steve Van Hooser

```
