# vlt.neuro.membrane.mle_normal_vm_fr

  MLE_NORMAL_VM_FR - use maximum likelihood analysis to compute Poisson rate model of voltage -> firing rate
  
  PARAMS = vlt.neuro.membrane.mle_normal_vm_fr(VM, FR, DELTAT,  ...)
 
  Estimate the parameters of a Normal rate function for fitting spike counts in bins and
  voltage values in bins.
 
  VM should be measurements of membrane potential in bins of size DELTAT
  FR should be measurements of firing rate (N_SPIKES/DELTAT)
 
  It returns the free PARAMS for each fit function type.
  For 'linearthreshold', PARAMS is [slope threshold sigma] (see help vlt.fit.linepowerthreshold)
  For 'vlt.fit.linepowerthreshold', PARAMS is [slope threshold exponent sigma]
  For 'Normal', PARAMS is [rate sigma]
 
  This function also accepts name/value pairs that alter its behavior:
  Parameters (default)              | Description
  -----------------------------------------------------------------
  fit_function ('linearthreshold')  | Uses function 'linearthreshold'
                                    |  that has form R(v) = vlt.math.rectify(V-V0)
                                    | The name of any function that takes X, Y
                                    | as inputs and then name/value pairs can be used
  fit_function_params               | Cell array of name/value pairs for the fit function.
   {'threshold_start',0}            |
 
 
  Note: This function has been tested with some known values but has not been tested
  to publication standard because the line of questioning petered out.
  SDV thinks it is right but more testing would be good.
 
 
  Example: (simple test, without voltage dependence)
    deltaT = 0.030; % 30 ms bins
    fr = icdf('Normal',rand(500,1),2,1); % generate rates, rate of 2, standard deviation of 1
    p_out =vlt.neuro.membrane.mle_normal_vm_fr(0*fr,fr,deltaT,'fit_function','Normal')  
    p_out_matlab = mle(fr,'distribution','Normal' ) % they match
