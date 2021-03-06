# vlt.neuro.membrane.mle_poisson_vm_fr

```
  MLE_POISSON_VM_FR - use maximum likelihood analysis to compute Poisson rate model of voltage -> firing rate
  
  PARAMS = vlt.neuro.membrane.mle_poisson_vm_fr(VM, FR, DELTAT,  ...)
 
  Estimate the parameters of a Poisson rate function for fitting spike counts in bins and
  voltage values in bins.
 
  VM should be measurements of membrane potential in bins of size DELTAT
  FR should be measurements of firing rate (N_SPIKES/DELTAT)
 
  It returns the free PARAMS for each fit function type.
  For 'vlt.fit.linepowerthreshold', PARAMS is [slope threshold] (see help vlt.fit.linepowerthreshold)
  For 'vlt.fit.linepowerthreshold', PARAMS is [slope threshold exponent]
  For 'Poisson', PARAMS is [rate]
 
  This function also accepts name/value pairs that alter its behavior:
  Parameters (default)              | Description
  -----------------------------------------------------------------
  fit_function                      | Uses function 'vlt.fit.linearpowerthreshold'
    ('vlt.fit.linepowerthreshold')  | that has form R(v) = vlt.math.rectify(V-V0)
                                    | The name of any function that takes X, Y
                                    | as inputs and then name/value pairs can be used
  fit_function_params               | Cell array of name/value pairs for the fit function.
   {'threshold_start',0}            |
 
 
  Note: This function has been tested with some known values but has not been tested
  to publication standard because the line of questioning petered out.
  SDV thinks it is right but more testing would be good.
 
 
  Example: (simple test, without voltage dependence)
    deltaT = 0.030; % 30 ms bins
    n = icdf('Poisson',rand(500,1),2); % generate spike counts in bins, rate of 2
    fr = n / deltaT; % convert to rates
    p_out =vlt.neuro.membrane.mle_poisson_vm_fr(0*fr,fr,deltaT,'fit_function','Poisson')  
    p_out_matlab = mle(round(fr*deltaT),'distribution','Poisson' ) / deltaT % they match

```
