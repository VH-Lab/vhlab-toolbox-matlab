# vlt.fit.otfit_carandini_conv

  vlt.fit.otfit_carandini_conv Converts between real params and fitting params
 
    [Rsp,Rp,Op,sig,Rn]=vlt.fit.otfit_carandini_conv(DIR,P,VARARGIN)
 
   **This is really an internal function.  Only read if you're interested
   in modifying vlt.fit.otfit_carandini.**
   
   Converts between the real parameters in the carandini fitting
   function and those used by Matlab to find the minimum in the error
   function.  For example, if the user specifies that Rsp must be
   in the interval [0 10], then the fitting variable Rsp_ will take
   values from -realmax to realmax but this value will be mapped onto
   the interval [0 10]. 
 
   DIR indicates direction of conversion.  'TOREAL' converts from
   fitting variables to real, whereas 'TOFITTING' converts from
   real variables to fitting variables.
 
   The variable arguments, given in name/value pairs, are used to
   specify restrictions.
     Valid name/value pairs:
      'widthint', e.g., [15 180]              sig must be in given interval
                                                  (default no restriction)
      'spontfixed',  e.g., 0                  Rsp fixed to given value
                                                  (default is not fixed)
      'spontint', [0 10]                      Rsp must be in given interval
                                                  (default is no restriction)
      'Rpint', e.g., [0 2*maxdata]            Rp must bein given interval
                                                  (default is no restriction)
      'Rnint', e.g., [0 2*maxdata]            Rp must bein given interval
                                                  (default is no restriction)
      'data', [obs11 obs12 ...; obs21 .. ;]   Observations to compute error
 
      'stddev', [stddev1 stddev2 stddev3 ...] Standard deviation; if provided,
                                                  squared error is normalized
                                                  by standard deviation
 
   See also:  vlt.fit.otfit_carandini, vlt.fit.otfit_carandini_err
