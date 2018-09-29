function logp_of_data = poisson_vm_fr(vm, fr, deltaT, ratefunc, ratefuncparams)
% POISSON_VM_FR - calculate log likelihood of seeing Vm/Fr pairs given model
%
% LOGP_OF_DATA = POISSON_VM_FR(VM, FR, DELTAT, RATEFUNC, RATEFUNCPARAMS, ...)
%
% Calculate the log likelihood of observing a given set of binned membrane voltage
% measurements (VM) and corresponding binned firing rates (FR) in bins size DELTAT.
% Spikes are assumed to be generated at a Poisson rate, where the rate lambda is
% determined by RATEFUNC(VM, ...) * DELTAT. RATEFUNCPARAMS are additional parameters
% to be passed to RATEFUNC, so that the call to RATEFUNC is RATEFUNC(VM, RATEFUNCPARAMS{:});
%
% See also: MLE_POISSON_VM_FR


rates = feval(ratefunc,vm(:),ratefuncparams{:}) * deltaT;
n = round(fr(:)*deltaT);

 % derivation:
 % Likelihood of data given model: Prod (exp(-rates)*(((rates).^n)/factorial(n)))
 % Log likelihood of data given model: sum( log(exp(-rates)) + log( ((rates).^n)/factorial(n) ) )
 %      =    sum( -rates + log (rates.^n) - log(factorial(n)) )
 %      =    sum( -rates + n.*log(rates) - gammaln(n+1) )


logp_of_data = sum(  -rates + n.*log(rates)-gammaln(n+1) );
