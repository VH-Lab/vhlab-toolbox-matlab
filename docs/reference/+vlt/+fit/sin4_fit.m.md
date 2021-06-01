# vlt.fit.sin4_fit

  SIN4_FIT - Fit a 4 term sine wave to data
 
    [FITVALUES,COEFFS] = vlt.fit.sin4_fit(X, Y, MAXFREQUENCY, INCLUDECONSTANT)
 
   Inputs:
     X - A vector of X values
     Y - A vector of Y values
     MAXFREQUENCY - The maximum frequency of the fit, in Hz (can be Inf)
     INCLUDECONSTANT - 0/1 should we include a constant term in the fit?
        This constant is included by setting it to the signal mean.
 
   Outputs:
     FITVALUES - The fit values of Y for all values of the input X.
     COEFFS - The coefficients for the sine waves.
          These are [a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13] where the
          fit function is 
          a1*sin(a2*x+a3)+a4*sin(a5*x+a6)+a7*sin(a8*x+a9)+a10*sin(a11*x+a12)+a13
          a13 is only present if INCLUDECONSTANT is 1.
