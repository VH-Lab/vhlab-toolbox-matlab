# vlt.math.clip

  CLIP - Clip values between a low and a high limit
 
  B = vlt.math.clip(A, [LOW HIGH])
 
  Return a variable B, the same size as A, except that all values of
  A that are below LOW are set to the value LOW, and all values that
  are above HIGH are set to HIGH.
 
  See also: vlt.math.rectify
 
  Example: 
      b = vlt.math.clip([-Inf 0 1 2 3 Inf],[1 2])
         % returns b = [1 1 1 2 2 2]
