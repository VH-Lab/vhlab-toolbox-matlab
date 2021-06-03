# vlt.fit.linepowerthresholdfit

```
  LINEPOWERTHRESHOLDFIT - Fit a linear function, raised to a power, with a threshold
 
   [SLOPE, OFFSET, THRESHOLD, EXPONENT, CURVE, GOF, FITINFO] = 
       vlt.fit.linepowerthresholdfit(X, Y, ...)
 
   Performs a nonlinear fit to find the best parameters for a function of the form
   Y = OFFSET + SLOPE * vlt.math.rectify(X - THRESHOLD).^EXPONENT
 
   X and Y should be vectors with the same length. SLOPE, OFFSET, THRESHOLD, and
   EXPONENT are the best fit values.  CURVE is the fit values of Y for the values of
   X used to generate the fit. GOF and FITINFO are the Matlab goodness-of-fit
   and fitinfo structures that are returned by the Matlab function FIT.
 
   Initial parameters and ranges can be modified by passing name/value pairs.
 
  This function can also take name/value pairs that modify default behaviors:
  Parameter (default)               | Description
  ---------------------------------------------------------------------------
  threshold_start (min(x))               | Iniitial starting point for THRESHOLD fit
  threshold_range [(min(x)-1) max(x)+1)] | THRESHOLD fit range
  slope_start (from vlt.stats.quickregression)     | Initial starting point for SLOPE fit
  slope_range [-Inf Inf]                 | SLOPE fit range
  offset_start (from vlt.stats.quickregression)    | Initial OFFSET starting point
  offset_range ([-Inf Inf])              | OFFSET parameter range
  exponent_start (1)                     | Initial EXPONENT start point
  exponent_range ([-Inf Inf])            | EXPONENT search space
  weights ([])                           | Weigh the error at each point by a value
  
 
  Example:
      x = sort(rand(20,1));
      y = vlt.fit.linepowerthreshold(x,3,0.3,0.5,1);
         % limit search to exponents = 1
      [slope,offset,t,exponent,thefit]=vlt.fit.linepowerthresholdfit(x,y,'exponent_start',1,'exponent_range',[1 1]);
      figure;
      plot(x,y,'bo');
      hold on;
      plot(x,thefit,'rx');
      box off;
      
  See also: vlt.stats.quickregression (simple linear fit), FIT, vlt.fit.linepowerthreshold
 
  Jason Osik and Steve Van Hooser

```
