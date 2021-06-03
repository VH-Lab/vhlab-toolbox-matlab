# vlt.neuro.vision.oridir.index.compute_tuningwidth

```
  vlt.neuro.vision.oridir.index.compute_tuningwidth
      TUNINGWIDTH = vlt.neuro.vision.oridir.index.compute_tuningwidth( ANGLES, RATES )
 
      Takes ANGLES in degrees
 
      linearly interpolates rates
      and returns the half of the distance
      between the two points sandwiching the maximum
      where the response is 1/sqrt(2) of the maximum rate.
      returns 90, when function does not come below the point
 
  See Rinach et al. J.Neurosci. 2002 22:5639-5651

```
