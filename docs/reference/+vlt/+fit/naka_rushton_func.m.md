# vlt.fit.naka_rushton_func

  vlt.fit.naka_rushton_func - Evaluate Naka Rushton function
 
   R=vlt.fit.naka_rushton_func (C, C50, N, S)
 
   Returns Naka Rushton function:  C^N/(C^(N*S)+c50^(N*S))
 
   If S is not specified, S is assumed to be 1.
   If C is negative, the result is negative.
