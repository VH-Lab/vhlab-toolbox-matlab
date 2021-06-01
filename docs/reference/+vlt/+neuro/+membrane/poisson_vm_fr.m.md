# vlt.neuro.membrane.poisson_vm_fr

  POISSON_VM_FR - calculate log likelihood of seeing Vm/Fr pairs given model
 
  LOGP_OF_DATA = vlt.neuro.membrane.poisson_vm_fr(VM, FR, DELTAT, RATEFUNC, RATEFUNCPARAMS, ...)
 
  Calculate the log likelihood of observing a given set of binned membrane voltage
  measurements (VM) and corresponding binned firing rates (FR) in bins size DELTAT.
  Spikes are assumed to be generated at a Poisson rate, where the rate lambda is
  determined by RATEFUNC(VM, ...) * DELTAT. RATEFUNCPARAMS are additional parameters
  to be passed to RATEFUNC, so that the call to RATEFUNC is RATEFUNC(VM, RATEFUNCPARAMS{:});
 
  See also: vlt.neuro.membrane.mle_poisson_vm_fr
