# vlt.signal.xcorr_stepfunc

```
  XCORR_STEPFUNC - Perform correlation between a time series and a step function
 
  [CORR,LAGS] = vlt.signal.xcorr_stepfunc(T1, SIGNAL1, MAXLAG, T2, SIGNAL2)
 
   Computes the discrete approximation to the correlation
    between a signal (SIGNAL1), which is sampled at times T1,
    and up to N step-function signals in the columns SIGNAL2,
    which change values at times T2.  SIGNAL2 does not have to
    have the same sample interval (sample rate) as SIGNAL1.
    Note that values of SIGNAL2 that are out of the range
    are set to 0.
    
    MAXLAG is the maximum lag to examine (in samples of SIGNAL1)
 
   See also: XCORR, vlt.math.stepfunc, vlt.signal.correlation_stepfunc

```
