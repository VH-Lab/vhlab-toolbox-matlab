# vlt.signal.ztrans_discrete

  ZTRANS_DISCRETE Evaluate the discrete Z transform for a value of z
 
   OUT = vlt.signal.ztrans_discrete(N, V, Z)
 
   Given an array of sample locations N and an array of
   corresponding values V, computes the Z-transform and evaluates
   the result at Z.  Z can be an array.
 
   The Z-transform is
 
      X(Z) = sum{all_N}{V(n)*z^(-n)}
