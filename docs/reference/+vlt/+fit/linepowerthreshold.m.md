# vlt.fit.linepowerthreshold

```
  LINEPOWERTHRESHOLD - compute linepowerthreshold function for values of x
 
   [CURVE] = vlt.fit.linepowerthreshold(X, SLOPE, OFFSET, THRESHOLD, EXPONENT)
 
   Calculates
 
   CURVE = OFFSET + SLOPE * vlt.math.rectify(X - THRESHOLD).^EXPONENT
 
  See also: vlt.stats.quickregression (simple linear fit), vlt.fit.linepowerthresholdfit
 
  Jason Osik and Steve Van Hooser

```
