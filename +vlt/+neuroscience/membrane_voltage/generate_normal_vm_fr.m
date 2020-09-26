function fr = generate_normal_vm_fr(vm, deltaT, ratefunc, ratefuncparams, sigma)
% GENERATE_POISSON_VM_FR - generate firing rate values from poisson process
%
% FR = GENERATE_POISSON_VM_FR(VM, DELTAT, RATEFUNC, RATEFUNCPARAMS, SIGMA)
%
% Generates sample firing rates for a Normally-distrubuted process modulated by voltage measurements
% (VM) bins of size DELTAT.  Firing rate is assumed to be generated according to a normal distribution,
% where the rate mu is determined by RATEFUNC(VM, ...) * DELTAT and SIGMA is given. RATEFUNCPARAMS are
% additional parameters to be passed to RATEFUNC, so that the call to RATEFUNC is RATEFUNC(VM, RATEFUNCPARAMS{:});
%
% See also: NORMAL_VM_FR, POISSON_VM_FR
%
% Example:

rate_per_bin = feval(ratefunc,vm(:),ratefuncparams{:});
r = rand(numel(vm),1);
sim_rates = icdf('Normal', r, rate_per_bin, sigma);
corresponding_spike_counts = rectify(round(sim_rates * deltaT));
fr = corresponding_spike_counts / deltaT;

