# vlt.fit.otfit_carandini0

  vlt.fit.otfit_carandini0 Fits orientation curves like Carandini/Ferster 2000
 
   [Rsp,Rp,Op,sigm,FITCURVE,ERR]=vlt.fit.otfit_carandini0(ANGLES,...
          SPONTHINT, MAXRESPHINT, OTPREFHINT, WIDTHHINT,'DATA',DATA) 
 
   Finds the best fit to the function
 
   R=Rsp+Rp*EXP(-(X-Op)^2)/(2*sig^2))+Rp*EXP(-(X-Op+180)^2/(2*sig^2))
   where R is the response, Rsp is the spontaneous response, Rp is 
   the response at the preferred orientation, Op is the preferred angle,
   sigm is the tuning width.
 
   This function differs from vlt.fit.otfit_carandini in that the response
   180 degrees away from Op is constrained to be Rp.  In
   vlt.fit.otfit_carandini, it can have its own value Rn.
 
   
   
   FITCURVE is the fit function at 1 degree intervals (0:1:359).
