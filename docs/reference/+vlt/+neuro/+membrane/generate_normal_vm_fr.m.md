# vlt.neuro.membrane.generate_normal_vm_fr

```
  GENERATE_POISSON_VM_FR - generate firing rate values from poisson process
 
  FR = vlt.neuro.membrane.generate_poisson_vm_fr(VM, DELTAT, RATEFUNC, RATEFUNCPARAMS, SIGMA)
 
  Generates sample firing rates for a Normally-distrubuted process modulated by voltage measurements
  (VM) bins of size DELTAT.  Firing rate is assumed to be generated according to a normal distribution,
  where the rate mu is determined by RATEFUNC(VM, ...) * DELTAT and SIGMA is given. RATEFUNCPARAMS are
  additional parameters to be passed to RATEFUNC, so that the call to RATEFUNC is RATEFUNC(VM, RATEFUNCPARAMS{:});
 
  See also: vlt.neuro.membrane.normal_vm_fr, vlt.neuro.membrane.poisson_vm_fr
 
  Example:

```
