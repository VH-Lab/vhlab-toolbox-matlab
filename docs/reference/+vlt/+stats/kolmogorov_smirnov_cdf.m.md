# vlt.stats.kolmogorov_smirnov_cdf

```
  vlt.stats.kolmogorov_smirnov_cdf (X, TOL)
  Return the CDF at X of the Kolmogorov-Smirnov distribution,
 	        Inf
 	Q(x) =  SUM    (-1)^k exp(-2 k^2 x^2)
 		  k = -Inf
  for X > 0.
 
  The optional parameter TOL specifies the precision up to which the
  series should be evaluated;  the default is TOL = `eps'.
 
  Ported from octave 2.1.35

```
