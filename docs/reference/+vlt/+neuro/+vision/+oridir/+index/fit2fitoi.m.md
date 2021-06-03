# vlt.neuro.vision.oridir.index.fit2fitoi

```
  FIT2FITOI - Calculate orientation index from a double gaussian fit of direction tuning curve
 
   OIIND = vlt.neuro.vision.oridir.index.fit2fitoi(R)
 
     Calculates the orientation selectivity index (OSI) from a double gaussian fit
     of a direction tuning curve.
     The OSI is defined as OSI = (Rpref - Rorth) / Rpref
     where Rpref is the average response to the preferred direction and the opposite
     direction (that is, the preferred orientations), and Rorth is the average
     response to the 2 directions orthogonal to the preferred direction (that is, the
     orthogonal orientation..
 
     R is a 2-row vector. The first row is the directions that were evaluated by the
     fit (e.g., [0:359] is the most common for 1 degree steps between 0 and 359), and
     the second row is the response of the fit for each angle.
 
     See also: vlt.fit.otfit_carandini, vlt.neuro.vision.oridir.index.fit2fitoi, vlt.neuro.vision.oridir.index.fit2fitdibr

```
