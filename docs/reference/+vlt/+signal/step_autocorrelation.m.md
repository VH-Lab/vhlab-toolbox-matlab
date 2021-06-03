# vlt.signal.step_autocorrelation

```
  STEP_AUTOCORRELATION - Mathematical function describing autocorrelation of a step function
 
   SAC = vlt.signal.step_autocorrelation(ALPHA, N, n)
 
   Produces the mathematically determined autocorrelation function of a process
   that, with probability alpha, produces a unit pulse of width N samples.
 
   n is the lag of the autocorrelation to be computed, and can be a vector.
 
   Example:  
      alpha = 0.2; 
      N = 10;
      n = -50:50;
      sac = vlt.signal.step_autocorrelation(alpha, N, n);
      figure;
      plot(n,sac,'-o');

```
