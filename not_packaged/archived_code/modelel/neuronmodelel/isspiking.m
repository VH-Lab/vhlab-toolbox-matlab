function b = isspiking(neuronmodelel, Time)
% ISSPIKING - Is a NEURONMODELEL neuron spiking right now?
%
%   B = ISSPIKING(NEURONMODELEL)
%
%   Returns 1 if the neuronmodelel has exhibited a spike between now
%   and the last time step (that is, in the interval
%   (neuronmodelel.T-neuronmodelel.dT, neuronmodelel.T]), and 0
%   otherwise.
%
%  A list of valid neuron model types is available by typing
%  NEURONMODELEL
%  
%  See also:  NEURONMODELEL
%

b = 0;

eps = 1e-10;

%if nargin==2,
%	tt = Time;
%else,
%	tt = neuronmodelel.T;
%end;

if ~isempty(neuronmodelel.model.spiketimes),
	if neuronmodelel.model.spiketimes(end) <= neuronmodelel.T,
		% if we've only spiked now or in the last dT, evaluate the last spike
		b = (neuronmodelel.T-neuronmodelel.model.spiketimes(end))<(neuronmodelel.dT-eps);
	else,
		% we might have a long list of spikes to examine, including spikes in the future
		alldiffs = neuronmodelel.T-neuronmodelel.model.spiketimes;
		%[mn,loc] = min(abs(alldiffs));
		%alldiffs(loc),
		b = any(   alldiffs>=-eps & alldiffs<(neuronmodelel.dT-eps) );
	end;
end;

