# vlt.data.numornan

  NUMORNAN - Return a number, or a NaN if the number is empty
 
   N_OUT = vlt.data.numornan(N_IN)
     or 
   N_OUT = vlt.data.numornan(N_IN, DIMS)
 
   If N_IN is not empty, then N_OUT is set to N_IN.
   If N_IN is empty, then a NaN is returned.
   
   If the optional input argument DIMS is provided, then the NaN
   matrix has dimension DIMS. If N_IN is smaller than DIMS, then
   N_OUT is padded to be filled with NaN.
