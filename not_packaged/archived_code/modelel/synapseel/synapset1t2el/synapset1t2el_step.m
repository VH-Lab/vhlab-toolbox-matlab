function [synapset1t2el] = synapset1t2el_step(synapset1t2el, modelstruct)
% SYNAPSET1T2EL_STEP - Calculate the conductance at a list of synapses
%
%  SYNAPSET1T2EL = SYNAPSET1T2EL_STEP(SYNAPSET1T2EL, MODELSTRUCT)
%
% Given a model synapse SYNAPSET1T2EL, and the full model structure
% MODELSTRUCT, updates the conductance field.
%
% See also: SYNAPSET1T2EL_INIT


 % which spikes to include?

i = synapset1t2el.model.pre;

if isempty(i), % nothing to update, update time and get out of here
	synapset1t2el.T = synapset1t2el.T+synapset1t2el.dT;
	return;
end;

if ~isempty(synapset1t2el.model.Tpast_ignore),
	spike_include = find(modelstruct(i).model.spiketimes > (synapset1t2el.T-synapset1t2el.model.Tpast_ignore));
	deltaT = synapset1t2el.T - modelstruct(i).model.spiketimes(spike_include);
else,
	deltaT = synapset1t2el.T - modelstruct(i).model.spiketimes;
end;

if ~isempty(deltaT),
	deltaT = deltaT(find(deltaT>0)); % make sure we are positive and not going into the future
	synapset1t2el.model.G = synapset1t2el.model.Gmax * sum ( ...
		exp(-deltaT/synapset1t2el.model.tau2)-exp(-deltaT/synapset1t2el.model.tau1));
else,
	synapset1t2el.model.G = 0;
end;

if ~isempty(synapset1t2el.model.plasticity_method),
	synapset1t2el = eval([synapset1t2el.model.plasticity_method '(synapset1t2el,modelstruct);']);
end;

synapset1t2el.T = synapset1t2el.T+synapset1t2el.dT;

