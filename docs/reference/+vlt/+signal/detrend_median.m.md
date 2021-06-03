# vlt.signal.detrend_median

```
 DETREND_MEDIAN - Remove a median trend from data
 
   D = vlt.signal.detrend_median(S, SI, T)
 
   Removes the result of a sliding median function of duration T
   from the sampled data S with sampling interval SI. The number of
   samples used for the sliding median function will be rounded to
   the nearest whole sample. The answer is returned in D. The median
   is sampled at intervals equal to 1/10 the windowsize.
  
  See also: DETREND, vlt.math.slidingwindowfunc

```
