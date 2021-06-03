# vlt.stats.gof_dicarlo_totalpower

```
  GOF_DICARLO_TOTALPOWER - Goodness of Fit from DiCarlo et al. 1988
 
  [GF, WS] = vlt.stats.gof_dicarlo_totalpower(RAWDATA, FIT, NUMFITPARAMS)
 
  Computes an analog to the "explanable variance" goodness-of-fit in
  DiCarlo et al. 1988, except using the total power of a response and
  fit (not sum of squares around the mean).
 
  Imagine a measured process Y(t) reflects some underlying
  function F(t) plus noise (due to measurement or process)
  N(t). Then the sum of squares (Y(t)^2) for all t is
  (Y(t)^2) = (F(t)^2) + (N(t))^2 + 2*F(t)*N(t). If we further
  assume that the expected value of N(t) is 0, then on average
  (Y(t)^2) = F(t)^2 + N(t)^2.
 
  Because of the noise N(t), the power (signal around 0) in Y(t) due to
  this noise is unexplanable by any model. The power of Y(t) is then
  Y(t).^2 == F(t).^2 + N(t).^2 but the explanable power (power of F) is
  F(t).^2 == Y(t).^2 - N(t).^2
 
  The goodness of fit GF describes how much of this explanable power
  of Y (which is the power of F) is explained by a fit H.
 
  GF = (FIT_EXPLAINED_POWER)/(EXPLANABLE_POWER)
 
  The entire workspace is returned as a structure in WS.
 
  Related to:
  Ref: DiCarlo JJ, Johnson KO, Hsaio SS. J Neurosci 1988:
  Structure of Receptive Fields in Area 3b of Primary Somatosensory Cortex in the Alert Monkey
 
  This function accepts name/value pairs that alter its behavior:
  Parameter (default)        | Description
  ------------------------------------------------------------------------------------------
  NoiseEstimation ('median') | How will we estimate the noise? Can be 'median' or 'std'.
                             |   If it is 'median', then vlt.stats.std_from_median(X) is used.
                             |   If it is 'STD', then STD(X) is used.

```
