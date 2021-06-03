# vlt.math.double_gaussian_plot

```
  DOUBLE_GAUSSIAN_PLOT - calculate a double gaussian
 
  Computes responses to a double gaussian curve
 
  Z = vlt.math.double_gaussian_plot(P, XI, WRAP), where
 
  P = parameters = [offset Rp Op Sigm Rn angle_offset]
  XI are the angles to be evaluated
  and WRAP is the wrap to be performed by vlt.math.angdiffwrap (usually 360)
  
  The curve is
    Z = offset + Rp*exp(-(vlt.math.angdiffwrap(xi-Op,wrap).^2)/(2*Sigm*Sigm))+...
         Rn*exp(-(vlt.math.angdiffwrap(xi-(Op+angle_offset),wrap)/(2*Sigm*Sigm)))

```
