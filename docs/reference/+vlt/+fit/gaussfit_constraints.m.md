# vlt.fit.gaussfit_constraints

  GAUSSFIT_CONSTRAINTS - gaussian fit with constraints
 
  [P,GOF,FITCURVE] = GAUSSFIT_CONSTRAINTS(X, Y, ...)
 
  Fits the data Y at positions X to:
 
  Y = a+b*exp((x-c).^2/(2*d^2))
 
  a is an offset parameter; b is a height parameter above the offset; 
  c is the peak location; d is the width
 
  The outputs are the parameters P = [a b c d] and the goodness-of-fit values
  GOF. FITCURVE is the fit value for all values of x.
 
  The user can pass initial guesses and constraints as name/value pairs:
  Parameter (default)              | Description
  ----------------------------------------------------------------------
  a_hint (0)                           | Offset initial guess
  a_range ([min(y) max(y)])            | Offset allowed range
  b_hint (max(y))                      | Height inital guess
  b_range [0 2*max(y)]                 | Height range
  c_hint (vlt.math.center_of_mass(x,y) | Initial guess for peak location
  c_range ([min(x) max(x)])            | Peak location range
  d_hint (0.1*(max(x)-min(x)))         | Initial guess of width
  d_range [0.01*(max(x)-min(x)) ...    | Width range
          [1*(max(x)-min(x))]          |
