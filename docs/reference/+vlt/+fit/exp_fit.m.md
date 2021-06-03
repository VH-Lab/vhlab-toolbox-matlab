# vlt.fit.exp_fit

```
  EXP_FIT Exponential fit
 
   [TAU,B,k,err,fit] = vlt.fit.exp_fit(T,DATA)
 
   Finds the best fit to the exponential function
     y(t) = b + k*(1-exp(-T/tau))
   where T is an increasing vector of timevalues, b is a constant offset, k
   is a scalar, and tau is the exponential time constant.

```
