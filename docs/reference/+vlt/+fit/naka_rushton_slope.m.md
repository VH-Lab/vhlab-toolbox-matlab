# vlt.fit.naka_rushton_slope

  vlt.fit.naka_rushton_slope - Evaluate slope of Naka Rushton function
 
   R=vlt.fit.naka_rushton_slope (C, C50, N, S)
 
   Returns the derivative of the Naka Rushton
      function: d[C^N/(C^(N*S)+c50^(N*S))]/dc.
 
   If S is not specified, S is assumed to be 1.
   If C is negative, the result is negative.
