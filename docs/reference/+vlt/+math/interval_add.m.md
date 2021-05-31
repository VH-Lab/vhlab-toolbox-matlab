# vlt.math.interval_add

  INTERVAL_ADD - add intervals 
  
  I_OUT = vlt.math.interval_add(I_IN, I_ADD)
 
  Given a matrix of intervals I_IN = [T1_0 T1_1; T2_0 T2_1 ; ... ] 
  where T is increasing (that is, where T(i)_0 > T(i-1)_0 and Ti_0<Ti_1 for all i),
  produce another matrix of intervals I_OUT that includes the interval I_ADD = [S0 S1].
  I_IN can be empty.
 
  Examples:
     i_out = vlt.math.interval_add([0 3],[3 6])  % yields [ 0 6]
     i_out = vlt.math.interval_add([0 2],[3 4])  % yields [ 0 2; 3 4]
     i_out = vlt.math.interval_add([0 10],[0 2]) % yields [ 0 10]
