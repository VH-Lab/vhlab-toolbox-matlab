# vlt.fit.otfit_carandini_conv2

```
  vlt.fit.otfit_carandini_conv Converts between real params and fitting params
 
    [Rsp,Rp,Op,sig,Rn,OnOff]=vlt.fit.otfit_carandini_conv2(DIR,P,VARARGIN)
 
   **This is really an internal function.  Only read if you're interested
   in modifying vlt.fit.otfit_carandini2.**
   
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
      'spontint', [0 maxdata]                 Rsp must be in given interval
                                                  (default is no restriction)
      'OnOffint', e.g., [130 230]             OnOff is offset from Op and
                                                  must be in given interval
                                                  (default is [179 181])
                                              High and low value for this
                                                  interval should be the
                                                  same modulo 360
      'Rpint', e.g., [0 2*maxdata]            Rp must bein given interval
                                                  (default is no restriction)
      'Rnint', e.g., [0 2*maxdata]            Rp must bein given interval
                                                  (default is no restriction)
      'data', [obs11 obs12 ...; obs21 .. ;]   Observations to compute error
 
   See also:  vlt.fit.otfit_carandini, vlt.fit.otfit_carandini_err

```
