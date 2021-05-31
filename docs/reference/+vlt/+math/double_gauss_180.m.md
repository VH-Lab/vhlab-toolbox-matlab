# vlt.math.double_gauss_180

  DOUBLE_GAUSS - Double gaussian function
  Computes a double gaussian function 
 
  DG = DOUBLE_GAUSS(X, PARAMETERS)
 
  DG=Rsp+Rp*EXP(-(X-Op)^2)/(2*sig^2))+Rn*EXP(-(X-Op+180)^2/(2*sig^2))
 
  PARAMETERS = [Rsp Rp Op sig Rn]
  
  parameters correspond to Carrandini fit parameters where
  Rsp=offset,Rp=peak parameter of first gaussian, 0p=location of first
  peak, sig=width parameter, Rn=peak parameter of second gaussian
  and takes the angle difference between the first peak and second peak
