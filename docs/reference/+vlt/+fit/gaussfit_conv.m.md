# vlt.fit.gaussfit_conv

```
  vlt.fit.otfit_carandini_conv Converts between real params and fitting params
 
    [Rsp,Rp,Op,sig]=GUASSFIT_CONV(DIR,P,VARARGIN)
 
   **This is really an internal function.  Only read if you're interested
   in modifying vlt.fit.gaussfit.**
   
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
      'data', [obs11 obs12 ...; obs21 .. ;]   Observations to compute error
 
   See also:  vlt.fit.gaussfit, vlt.fit.gaussfit_err, vlt.fit.otfit_carandini, vlt.fit.otfit_carandini_err

```
