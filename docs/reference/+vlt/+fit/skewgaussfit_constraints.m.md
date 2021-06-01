# vlt.fit.skewgaussfit_constraints

  SKEWGAUSSFIT_CONSTRAINTS - skewed gaussian fit with constraints
 
  [P,GOF,FITCURVE] = SKEWGAUSSFIT_CONSTRAINTS(X, Y, ...)
 
  Fits the data Y at positions X to:
 
  Y = a+b*exp((x-c).^2/(2*d^2)).*(1+erf(e*(x-c)/sqrt(2)));
 
  a is an offset parameter; b is a height parameter above the offset; 
  c is the peak location; d is the width; e is the degree of skewness (0 is none)
 
  The outputs are the parameters P = [a b c d e] and the goodness-of-fit values
  GOF. FITCURVE is the fit value for all values of x.
 
  Inspired by the skew normal distribution: https://en.wikipedia.org/wiki/Skew_normal_distribution
  (But this is not normalized the same way; in real skew normal, b must be 0.5 * 1/(sqrt(2*pi)*d))
 
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
  e_hint (0)                           | Skew parameter hint
  e_range ([-1 1])                     | Allows strong skewness but not infinitely strong
