# vlt.fit.otfit_carandini

```
  vlt.fit.otfit_carandini Fits orientation curves like Carandini/Ferster 2000
 
   [Rsp,Rp,Op,sigm,Rn,FITCURVE,ERR]=vlt.fit.otfit_carandini(ANGLES,...
          SPONTHINT, MAXRESPHINT, OTPREFHINT, WIDTHHINT,'DATA',DATA) 
 
   Finds the best fit to the function
 
   R=Rsp+Rp*EXP(-(X-Op)^2)/(2*sig^2))+Rn*EXP(-(X-Op+180)^2/(2*sig^2))
   where R is the response, Rsp is the spontaneous response, Rp is 
   the response at the preferred angle, Op is the preferred angle,
   sigm is the tuning width, Rn is the firing rate at 180+Op.
 
   
   
   FITCURVE is the fit function at 1 degree intervals (0:1:359).

```
