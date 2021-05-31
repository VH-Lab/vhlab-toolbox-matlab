# vlt.fit.otfit_carandini_err2

  vlt.fit.otfit_carandini_err Computes error of Carandini/Ferster orientation fit
 
    [ERR, RFIT]=OTFIT_CARANDINI_NEWS_ERR2(P,ANGLES,VARARGIN) 
 
    This function computes the error of the Carandini/Ferster orientation
    RFIT(O)=Rsp+Rp*exp(-(O-Op)^2/2*sig^2)+Rn*(exp(-(O-Op-180)^2)/s*sig^2)
    where O is an orientation angle.  ANGLES is a vector list of angles to
    be evaluated.  If observations are provided (see below) then the
    squared error ERR is computed.  Otherwise ERR is zero.
 
     The variable arguments, given in name/value pairs, can be used
     to specify the mode.
     Valid name/value pairs:
      'widthint', e.g., [15 180]              sig must be in given interval
                                                  (default no restriction)
      'spontfixed',  e.g., 0                  Rsp fixed to given value
                                                  (default is not fixed)
      'spontint', [0 10]                      Rsp must be in given interval
                                                  (default is no restriction)
      'OnOffint', e.g., [140 220]             OnOff is offset from Op and
                                                  must be in given interval
                                                  (default is [179 181])
      'data', [obs11 obs12 ...; obs21 .. ;]   Observations to compute error
 
     P = [ Rsp Rp Op sig Rn OnOff] are parameters, where Rsp is the spontaneous
    response, Rp is the response at the preferred orientation, Op is the
    preferred angle, sig is the width of the tuning, and Rn is the response
    180 degrees away from the preferred angle.
 
    See also:  vlt.fit.otfit_carandini
