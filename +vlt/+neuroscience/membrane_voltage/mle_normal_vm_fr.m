function [params] = mle_normal_vm_fr(vm, fr, deltaT, varargin)
% MLE_NORMAL_VM_FR - use maximum likelihood analysis to compute Poisson rate model of voltage -> firing rate
% 
% PARAMS = MLE_NORMAL_VM_FR(VM, FR, DELTAT,  ...)
%
% Estimate the parameters of a Normal rate function for fitting spike counts in bins and
% voltage values in bins.
%
% VM should be measurements of membrane potential in bins of size DELTAT
% FR should be measurements of firing rate (N_SPIKES/DELTAT)
%
% It returns the free PARAMS for each fit function type.
% For 'linearthreshold', PARAMS is [slope threshold sigma] (see help LINEPOWERTHRESHOLD)
% For 'linepowerthreshold', PARAMS is [slope threshold exponent sigma]
% For 'Normal', PARAMS is [rate sigma]
%
% This function also accepts name/value pairs that alter its behavior:
% Parameters (default)              | Description
% -----------------------------------------------------------------
% fit_function ('linearthreshold')  | Uses function 'linearthreshold'
%                                   |  that has form R(v) = rectify(V-V0)
%                                   | The name of any function that takes X, Y
%                                   | as inputs and then name/value pairs can be used
% fit_function_params               | Cell array of name/value pairs for the fit function.
%  {'threshold_start',0}            |
%
%
% Note: This function has been tested with some known values but has not been tested
% to publication standard because the line of questioning petered out.
% SDV thinks it is right but more testing would be good.
%
%
% Example: (simple test, without voltage dependence)
%   deltaT = 0.030; % 30 ms bins
%   fr = icdf('Normal',rand(500,1),2,1); % generate rates, rate of 2, standard deviation of 1
%   p_out =mle_normal_vm_fr(0*fr,fr,deltaT,'fit_function','Normal')  
%   p_out_matlab = mle(fr,'distribution','Normal' ) % they match

fit_function = 'linearthreshold';
nspace = 5;

assign(varargin{:});

switch lower(fit_function),
	case 'normal',
		lower_bounds = [0 min(0.1/deltaT,0.1*std(fr))];
		upper_bounds = [10*max(fr) 10/deltaT];
		rateFunc = 'linepowerthreshold';
		fitfun = @(x) -normal_vm_fr(vm,fr,deltaT,rateFunc, {1 x(1) 0 1}, x(2));
	case 'linearthreshold',
		lower_bounds = [0 0 min(0.1/deltaT,0.1*std(fr))];
		upper_bounds = [10*max(fr)/max(vm) max(vm) 10/deltaT] ;
		rateFunc = 'linepowerthreshold';
		fitfun = @(x) -normal_vm_fr(vm,fr,deltaT,rateFunc, {x(1) eps x(2) 1}, x(3));
	case 'linepowerthreshold',
		lower_bounds = [0 0 0.5 min(0.1/deltaT,0.1*std(fr))];
		upper_bounds = [10*max(fr)/max(vm) max(vm) 5 10/deltaT] ;
		rateFunc = 'linepowerthreshold';
		fitfun = @(x) -normal_vm_fr(vm,fr,deltaT,rateFunc, {x(1) eps x(2) x(3)}, x(4));
	otherwise,
		error(['Unknown fit function']);
end;

x0v = fitsearchspace(lower_bounds,upper_bounds,nspace);

smallest = Inf;
best_x = [];

for i=1:size(x0v,2),
	x0 = x0v(:,i);
	[x,fval] = fmincon(fitfun, x0, [], [], [], [], lower_bounds, upper_bounds);
	if fval < smallest,
		smallest = fval;
		params = x;
	end;
end


