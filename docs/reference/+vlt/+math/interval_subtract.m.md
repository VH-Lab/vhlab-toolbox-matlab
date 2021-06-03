# vlt.math.interval_subtract

```
  INTERVAL_SUBTRACT - remove an interval from a larger interval
  
  I_OUT = vlt.math.interval_subtract(I_IN, I_SUB)
 
  Given a matrix of intervals I_IN = [T1_0 T1_1; T2_0 T2_1 ; ... ] 
  where T is increasing (that is, where T(i)_0 > T(i-1)_0 and Ti_0<Ti_1 for all i),
  produce another matrix of intervals I_OUT that excludes the interval I_SUB = [S0 S1].
 
  Examples:
     i_out = vlt.math.interval_subtract([0 10],[1 2]) % yields [ 0 1; 2 10]
     i_out = vlt.math.interval_subtract([0 10],[0 2]) % yields [ 2 10]

```
