# vlt.signal.xcorr_discrete

```
  XCORR_DISCRETE - Calculate the cross-correlation between two signals without FFT
 
   XC = vlt.signal.xcorr_discrete(SIGNAL1, SIGNAL2, N, NORMSTRING)
 
   Computes the cross-correlation between SIGNAL1 and SIGNAL2 for lags up to N.
 
   If NORMSTRING is left off, then the correlation is not normalized.
   Otherwise it is normalized according to the following values of NORMSTRING:
     'none' : no normalization
    'biased': divides by length of SIGNAL1
  'unbiased': divides by the absolute value of length of SIGNAL - LAG

```
