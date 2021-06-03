# vlt.fit.exp_fit_err

```
   EXP_FIT_ERR Exponential error function
 
        ERR=vlt.fit.exp_fit_err(P,T,DATA)
        P = [b tau k] 
           returns mean squared error of  y = b + k*(1-exp(-T/tau)),
        where T is a vector of timevalues to evaluate.

```
