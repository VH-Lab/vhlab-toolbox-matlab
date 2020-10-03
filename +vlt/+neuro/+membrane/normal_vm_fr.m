function logp_of_data = normal_vm_fr(vm, fr, deltaT, ratefunc, ratefuncparams, sigma)
% NORMAL_VM_FR - calculate log likelihood of seeing Vm/Fr pairs given model
%
% LOGP_OF_DATA = vlt.neuro.membrane.normal_vm_fr(VM, FR, DELTAT, RATEFUNC, RATEFUNCPARAMS, SIGMA, ...)
%
% Calculate the log likelihood of observing a given set of binned membrane voltage
% measurements (VM) and corresponding binned firing rates (FR) in bins size DELTAT.
% Spikes are assumed to be generated from a normal distribution, where the rate mu 
% is determined by RATEFUNC(VM, ...) * DELTAT and the standard deviation SIGMA is
% constant and passed above. RATEFUNCPARAMS are additional parameters to be passed
% to RATEFUNC, so that the call to RATEFUNC is RATEFUNC(VM, RATEFUNCPARAMS{:});
%
% See also: vlt.neuro.membrane.mle_normal_vm_fr, vlt.neuro.membrane.poisson_vm_fr, vlt.neuro.membrane.mle_poisson_vm_fr

expected_rates = feval(ratefunc,vm(:),ratefuncparams{:});

 % derivation:
 % Likelihood of data given model: Prod ( (1/(sqrt(2*pi)*sigma)) * exp(-((x-mu).^2)/(2*sigma^2) ) )
 % Log likelihood of data given model: sum( log ((1/(sqrt(2*pi)*sigma)) * exp(-((x-mu).^2)/(2*sigma^2) ) ) )
 %      =    sum( -((x-mu).^2)/(2*sigma^2) -log ( sqrt(2*pi)*sigma) )
 %      =    sum( -((x-mu).^2)/(2*sigma^2) -log ( sqrt(2*pi*sigma^2) )
 %      =    sum( -((x-mu).^2)/(2*sigma^2) -0.5 * (log(2*pi)+2*log(sigma)) )

logp_of_data = sum( -((fr(:)-expected_rates(:)).^2)/(2*sigma^2) -0.5 * (log(2*pi)+2*log(sigma)) );

