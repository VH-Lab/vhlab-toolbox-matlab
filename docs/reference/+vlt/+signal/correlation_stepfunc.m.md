# vlt.signal.correlation_stepfunc

```
  vlt.signal.correlation_stepfunc - Perform correlation between a time series and a step function
 
  CORR = CORRELATION(T1, SIGNAL1, CORR_TIMES, T2, SIGNAL2)
 
   Computes the discrete approximation to the correlation
    between a signal (SIGNAL1), which is sampled at times T1,
    and up to N step-function signals in the columns SIGNAL2,
    which change values at times T2.  SIGNAL2 does not have to
    have the same sample interval (sample rate) as SIGNAL1.
    Note that values of SIGNAL2 that are out of the range
    are set to 0.
 
   WARNING: At present, this function produces tiny differences between
   XCORR of the step function and SIGNAL1. I am at a loss to explain it...
 
   The correlation function is:
 
       Integral({t from T1(1) to T1(end)}, dt * SIGNAL1*SIGNAL2)
 	(Dayan and Abbott 2005, equation in chapter 1)
 
   and the discrete version is:
       Let dt = T1(2)-T1(1)  (use signal 1's sample interval)
       CORR(tau) = sum over all times t in T1: dt*SIGNAL1(t)*SIGNAL2(t-tau)
       where TAU assumes all values listed in the vector CORR_TIMES.
 
   See also: XCORR, vlt.math.stepfunc, vlt.signal.xcorr_stepfunc

```
