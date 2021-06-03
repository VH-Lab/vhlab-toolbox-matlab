# vlt.neuro.vision.oridir.index.fit2fitdibr

```
  vlt.neuro.vision.oridir.index.fit2fitdibr - Direction index from double gaussian fit (blank rectified) 
 
   DSI = vlt.neuro.vision.oridir.index.fit2fitdibr(FITPARAMS, BLANKRESP)
 
   Computes the "direction selectivity index", or the fraction of the total response
   that is in the preferred direction compared to the opposite direction.
 
   FITPARAMS is a 5-value vector describing a double gaussian fit to a
   direction tuning curve (FITPARAMS(1) is offset, FITPARAMS(2) is weight
   of first gaussian peak, FITPARAMS(3) is the peak tuning position,
   FITPARAMS(4) is the variance around the peak, FITPARAMS(%) is the
   weight of the 'null' direction peak):
   Resp = -BLANK + fitparams(1)+...
     fitparams(2)*exp(-vlt.math.angdiff(fitparams(3)-angs).^2/(2*fitparams(4)^2)) +...
     fitparams(5)*exp(-vlt.math.angdiff(fitparams(3)+180-angs).^2/(2*fitparams(4)^2));
 
   The DSI is defined as DSI = (Rpref - Rnull) / Rpref
 
   See also: vlt.fit.otfit_carandini, vlt.neuro.vision.oridir.index.fit2fitoi, vlt.neuro.vision.oridir.index.fit2fitdibr

```
