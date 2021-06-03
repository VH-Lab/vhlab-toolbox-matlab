# vlt.signal.point2samplelabel

```
  POINT2SAMPLE - Convert a continuous point to a sample number for regularly sampled data
 
   S = vlt.signal.point2samplelabel(TI, DT, [T0])
 
   Given an array of time values TI, returns the closest sample
   for a signal that is regularly sampled at interval DT.
   The closest sample number is determined by rounding.
   Samples are assumed to be numbered as S = T0+N*DT (Notice that
   these sample labels can be negative or 0).
 
   T0 is the time of the first sample of the signal. If T0 is not
   provided, it is assumed to be 0.
 
   Example:
     dt = 0.001;
     T = 0:dt:40;
     S = vlt.signal.point2samplelabel(T(20),dt)   % returns 20
     
   See also: vlt.signal.round2sample

```
