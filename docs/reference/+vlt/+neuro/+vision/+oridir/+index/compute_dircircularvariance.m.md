# vlt.neuro.vision.oridir.index.compute_dircircularvariance

```
  vlt.neuro.vision.oridir.index.compute_dircircularvariance
      CV = vlt.neuro.vision.oridir.index.compute_dircircularvariance( ANGLES, RATES )
 
      Takes ANGLES in degrees. ANGLES and RATES should be
      row vectors.
 
  CV = 1 - |R|
  R = (RATES * EXP(I*ANGLES)') / SUM(RATES)
 
  See Ringach et al. J.Neurosci. 2002 22:5639-5651

```
