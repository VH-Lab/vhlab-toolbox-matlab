function [ x, fval ] = MLE_PoisGauss(t,dt,responses_observed,SPs,stimlist,model,fixparam,g_params,s_i_parameters,smoothness)
%MLE_PoisGauss - Calculate maximum likelihood of gain and average stimulus responses given raw responses
%   
%   [PARAMS,FVAL] = vlt.neuro.mledenoise.MLE_PoisGauss(STIM_CENTER_TIMES, STIM_DURATIONS, RESPONSES_OBSERVED, ...
%         SP, STIMLIST, MODEL, FIXPARAM, G_PARAMS, S_I_PARAMS, SMOOTHNESS);
%
%  Inputs:
%   STIM_CENTER_TIMES - The time points at which the stimuli were presented (middle of the stimuli)
%                       Note that this vector should be as long as the number of stimuli times the
%                       number of repetitions of those stimuli.
%   STIM_DURATIONS -    The duration of each stimulus (should be a vector)
%   RESPONSES_OBSERVED- The observed spike counts (for Poisson model) or rates (for Gaussian model)
%                        that occurred for stimulus presentation i
%                        (should be vector as long as number of stimui times number of repetitions)
%   SP - Sinwave parameters
%   STIMLIST - Stim ID numbers for all presented stimuli
%   MODEL - 'Poisson' or 'Gaussian'
%   FIXPARAM - Is the fixed parameter g (FIXPARAM==1) or s_i (FIXPARAM==0)?
%   G_PARAMS - A list of amplitudes for the 4 sinwaves
%   S_I_PARAMS - The estimated mean firing rate for the i different types of stimuli that were 
%                presented (note that this is as long as the number of unique stimuli).
%   SMOOTHNESS - A constraint on the 2nd derivative (must be smoother than SMOOTHNESS)
%                If Inf is provided, or empty ([]), then this constraint is not used.
%
%  Outputs: 
%    PARAMS - The estimated parameters, either s_i (FIXPARAM==1) or g (FIXPARAM==0)
%    Fval - the value of the function to be minimized
 
options = optimset('fmincon');
options.Algorithm = 'sqp';

if fixparam == 1
	lb = 0*s_i_parameters;
	ub = lb + Inf;
	x0 = s_i_parameters;
	if isempty(smoothness), smoothness = Inf; end;
	if smoothness<Inf,
		[x,fval] = fmincon(@nestedfun,x0,[],[],[],[],lb,ub,@mycon, options);
	else,
		[x,fval] = fmincon(@nestedfun,x0,[],[],[],[],lb,ub,[], options);
	end;
else
	lb = 0*g_params;
	ub = lb + Inf;
	x0 = g_params;
	[x,fval] = fmincon(@nestedfun,x0,[],[],[],[],lb,ub,[],options);
end
        
function y = nestedfun(x0)
% given r, g, and s, calculate the likelihood
	if fixparam==1,
		stim_responses_i=x0; % given model mean response of each stim, calculate predicted response
		g_params_value = g_params;
	else,
		stim_responses_i=s_i_parameters; % given model mean response of each stim, calculate predicted response
		g_params_value = x0;
	end;

	r_estimated = vlt.neuro.mledenoise.response_gaindrift_model(t,dt,stimlist,SPs,g_params_value,stim_responses_i);
	%figure(100);
	%plot(t,r_estimated,'b'); 
	%pause(1);
	if strcmp(model,'Poisson'),
		y = -vlt.neuro.spiketrains.loglikelihood_spiketrain(r_estimated, dt, responses_observed);
	else,
		y = -vlt.neuro.spiketrains.loglikelihood_spikerate(r_estimated, dt, responses_observed, 1);
	end;


	% for debugging: %figure(100); %plot(t,r_estimated); %if y<357, %	x0, %end; %ans = -y; %global my_nested_workspace; %my_nested_workspace = vlt.data.workspace2struct;

end  % function
        
function [c, ceq] = mycon(x)
	ceq = 0*x;  % do not use the equation constant ceq
	% calculate the discrete 2nd derivative (see http://en.wikipedia.org/wiki/Finite_difference)
	% we assume equal spacing of x locations;
        % this function is undefined at the boundaries
	deriv2 = [0 x(1:end-2)+x(3:end)-2*x(2:end-1) 0];
	c = abs(deriv2) - smoothness;  % constrain 2nd derivative to be less than smoothness
end % function
        
end % vlt.neuro.mledenoise.archived_code.MLE_Pois



