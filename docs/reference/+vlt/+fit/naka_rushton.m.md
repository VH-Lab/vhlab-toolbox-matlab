# vlt.fit.naka_rushton

  NAKA_RUSHTON Naka-Rushton fit (for contrast curves)
 
   [RM,B] = vlt.fit.naka_rushton(C,DATA)
 
   Finds the best fit to the Naka-Rushton function
     R(c) = Rm*c/(b+c)
   where C is contrast (0-1), Rm is the maximum response, and b is the
   half-maximum contrast.
 
   [RM,B,N] = vlt.fit.naka_rushton(C,DATA)
 
   Finds the best fit to the Naka-Rushton function
     R(c) = Rm*c^n/(b+c^n)
   where C is contrast (0-1), Rm is the maximum response, and b is the
   half-maximum contrast.
 
   [RM,B,N,S] = vlt.fit.naka_rushton(C,DATA)
 
   Finds the best fit to the Naka-Rushton function
     R(c) = Rm*c^n/(b^(s*n)+c^(s*n))
   where C is contrast (0-1), Rm is the maximum response, and b is the
   half-maximum contrast, and s is a saturation factor.
   
   References:
     Naka_Rushton fit was first described in 
     Naka, Rushton, J.Physiol. London 185: 536-555, 1966
     and used to fit contrast data of cortical cells in  
     Albrecht and Hamilton, J. Neurophys. 48: 217-237, 1982
     The saturation form was described in Peirce 2007 J Vision
