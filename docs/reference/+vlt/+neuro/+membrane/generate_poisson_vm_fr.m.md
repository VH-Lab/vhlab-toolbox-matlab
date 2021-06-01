# vlt.neuro.membrane.generate_poisson_vm_fr

  GENERATE_POISSON_VM_FR - generate firing rate values from poisson process
 
  FR = vlt.neuro.membrane.generate_poisson_vm_fr(VM, DELTAT, RATEFUNC, RATEFUNCPARAMS, ...)
 
  Generates sample firing rates for a Poisson process modulated by voltage measurements
  (VM) bins of size DELTAT.  Spikes are assumed to be generated at a Poisson rate, where the rate lambda is
  determined by RATEFUNC(VM, ...) * DELTAT. RATEFUNCPARAMS are additional parameters
  to be passed to RATEFUNC, so that the call to RATEFUNC is RATEFUNC(VM, RATEFUNCPARAMS{:});
 
  See also: vlt.neuro.membrane.poisson_vm_fr
 
  Example:
