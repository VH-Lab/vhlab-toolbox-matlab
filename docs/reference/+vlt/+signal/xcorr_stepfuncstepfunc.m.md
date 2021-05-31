# vlt.signal.xcorr_stepfuncstepfunc

  XCORR_STEPFUNC - Perform correlation between a step function and a step function
 
  [CORR,LAGS] = vlt.signal.xcorr_stepfuncstepfunc(TE, T1, SIGNAL1, MAXLAG, T2, SIGNAL2)
 
   Computes the discrete approximation to the correlation
    between an N step-function SIGNAL1 that changes values at times T1
    and is at times T1, and the N step-function signal SIGNAL2,
    which change values at times T2.  SIGNAL2 does not have to
    have the same sample interval (sample rate) as SIGNAL1.
    Note that values of SIGNAL1 and SIGNAL2 that are out of the range
    are set to 0.
 
    TE are the times over which to evalute the step functions, and
    the time between successive values of TE is equal to 1 sample in the
    returned cross-correlation.
    
    MAXLAG is the maximum lag to examine (in samples of TE). The XCORR
    normalization is 'biased'.
 
    The correlation is returned in CORR. It has 1 column per dimension of the
    two step functions.
 
    (Programmer note: there is a probably a better algorithm for this.)
 
   See also: XCORR, vlt.signal.xcorr_stepfunc, vlt.math.stepfunc, vlt.signal.correlation_stepfunc
