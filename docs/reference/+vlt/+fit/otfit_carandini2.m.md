# vlt.fit.otfit_carandini2

```
  vlt.fit.otfit_carandini Fits orientation curves like Carandini/Ferster 2000
 
   [Rsp,Rp,Op,sigm,Rn,OnOff,FITCURVE,ERR,R2]=vlt.fit.otfit_carandini(ANGLES,...
          SPONTHINT, MAXRESPHINT, OTPREFHINT, WIDTHHINT,'DATA',DATA,...) 
 
   Finds the best fit to the function
 
   R=Rsp+Rp*EXP(-(X-Op)^2)/(2*sig^2))+Rn*EXP(-(X-On)^2/(2*sig^2))
   where R is the response, Rsp is the spontaneous response, Rp is 
   the response at the preferred angle, Op is the preferred angle,
   sigm is the tuning width, Rn is the firing rate at 180+Op,
   OnOff is the offset of the null angle from the preferred.
 
   One can restrict the range of these parameters by providing
   descriptor/interval pairs as additional arguments (e.g.,
   'OnOffInt',[130 230] ).  See vlt.fit.otfit_carandini_conv2 for a list
   of interval names.
 
   ERR is the squared error between the fit and the data.
 
   R2 is the R^2 value of the fit.
 
   
   FITCURVE is the fit function at 1 degree intervals (0:1:359).

```
