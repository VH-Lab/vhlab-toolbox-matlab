function b = isspiking(neuronmodelel, Time)
% ISSPIKING - Is a NEURONMODELEL neuron spiking right now?
%
%   B = vlt.neuro.models.modelel.neuronmodelel.isspiking(vlt.neuro.models.modelel.neuronmodelel.neuronmodelel)
%
%   Returns 1 if the vlt.neuro.models.modelel.neuronmodelel.neuronmodelel has exhibited a spike between now
%   and the last time step (that is, in the interval
%   (vlt.neuro.models.modelel.neuronmodelel.neuronmodelel.T-vlt.neuro.models.modelel.neuronmodelel.neuronmodelel.dT, vlt.neuro.models.modelel.neuronmodelel.neuronmodelel.T]), and 0
%   otherwise.
%
%  A list of valid neuron model types is available by typing
%  vlt.neuro.models.modelel.neuronmodelel.neuronmodelel
%  
%  See also:  vlt.neuro.models.modelel.neuronmodelel.neuronmodelel
%

b = 0;

eps = 1e-10;

%if nargin==2,
%	tt = Time;
%else,
%	tt = vlt.neuro.models.modelel.neuronmodelel.neuronmodelel.T;
%end;

if ~isempty(vlt.neuro.models.modelel.neuronmodelel.neuronmodelel.model.spiketimes),
	if vlt.neuro.models.modelel.neuronmodelel.neuronmodelel.model.spiketimes(end) <= vlt.neuro.models.modelel.neuronmodelel.neuronmodelel.T,
		% if we've only spiked now or in the last dT, evaluate the last spike
		b = (vlt.neuro.models.modelel.neuronmodelel.neuronmodelel.T-vlt.neuro.models.modelel.neuronmodelel.neuronmodelel.model.spiketimes(end))<(vlt.neuro.models.modelel.neuronmodelel.neuronmodelel.dT-eps);
	else,
		% we might have a long list of spikes to examine, including spikes in the future
		alldiffs = vlt.neuro.models.modelel.neuronmodelel.neuronmodelel.T-vlt.neuro.models.modelel.neuronmodelel.neuronmodelel.model.spiketimes;
		%[mn,loc] = min(abs(alldiffs));
		%alldiffs(loc),
		b = any(   alldiffs>=-eps & alldiffs<(vlt.neuro.models.modelel.neuronmodelel.neuronmodelel.dT-eps) );
	end;
end;

