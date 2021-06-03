# vlt.fit.gaussfit

```
  vlt.fit.gaussfit Fits data to a Gaussian
 
   [Rsp,Rp,P,sigm,FITCURVE,ERR]=vlt.fit.gaussfit(VALUES,...
          SPONTHINT, MAXRESPHINT, OTPREFHINT, WIDTHHINT,'DATA',DATA) 
 
   Finds the best fit to the function
 
   R=Rsp+Rp*EXP(-(X-P)^2)/(2*sigm^2))
   where R is the response, Rsp is the spontaneous response, Rp is 
   the response at the preferred value, P is the preferred value,
   sigm is the tuning width.
 
   VALUES are the values of X that are measured.
   DATA is the response for each value in VALUES.
   
   FITCURVE is the fit function at 1 value intervals min:max.
 
   ERR is the mean squared error.

```
