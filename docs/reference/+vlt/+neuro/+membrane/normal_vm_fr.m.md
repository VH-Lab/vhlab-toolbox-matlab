# vlt.neuro.membrane.normal_vm_fr

  NORMAL_VM_FR - calculate log likelihood of seeing Vm/Fr pairs given model
 
  LOGP_OF_DATA = vlt.neuro.membrane.normal_vm_fr(VM, FR, DELTAT, RATEFUNC, RATEFUNCPARAMS, SIGMA, ...)
 
  Calculate the log likelihood of observing a given set of binned membrane voltage
  measurements (VM) and corresponding binned firing rates (FR) in bins size DELTAT.
  Spikes are assumed to be generated from a normal distribution, where the rate mu 
  is determined by RATEFUNC(VM, ...) * DELTAT and the standard deviation SIGMA is
  constant and passed above. RATEFUNCPARAMS are additional parameters to be passed
  to RATEFUNC, so that the call to RATEFUNC is RATEFUNC(VM, RATEFUNCPARAMS{:});
 
  See also: vlt.neuro.membrane.mle_normal_vm_fr, vlt.neuro.membrane.poisson_vm_fr, vlt.neuro.membrane.mle_poisson_vm_fr
