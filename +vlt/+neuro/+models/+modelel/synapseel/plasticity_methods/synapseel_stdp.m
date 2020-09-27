function synapseel = synapseel_stdp(synapseel, modelstruct)
% SYNAPSEEL_CLASSICSTDP - Apply classic stdp to a SYNAPSEEL synapse
%
%   SYNAPSEEL = vlt.neuroscience.models.modelel.synapseel.plasticity_methods.synapseel_stdp(SYNAPSEEL, MODELSTRUCT)
%
%   Apply stdp to a SYNAPSEEL object.
%
%   This requires that the SYNAPSEEL object have a field 'plasticity_params' with 
%   several fields:
%   --------------------------------------------------------------------------
%   Gmax_max             |  The maximum value that the maximum conductance can take
%                        |    (that is, a ceiling value). Use Inf for none.
%   Gmax_min             |  The minimum value that the maximum conductance can take
%                        |    (that is, a floor value). Use -Inf for none.
%   classic_stdp         |  0/1 should we use classic stdp or triplet stdp?
%   params               |  {'name1,'value1',...} parameters to pass along to 
%                        |     vlt.neuroscience.stdp.stdp_apply or vlt.neuroscience.stdp.stdp_triplet_apply (optional)
%       
%   
%
%   See also: SYNAPSEEL_INIT

eps = 1e-10; % epsilon, for math rounding

prespike = vlt.neuroscience.models.modelel.neuronmodelel.isspiking(modelstruct(synapseel.model.pre));
postspike = vlt.neuroscience.models.modelel.neuronmodelel.isspiking(modelstruct(synapseel.model.post));

if ~isfield(synapseel.model.plasticity_params,'params'),
	synapseel.model.plasticity_params.params = {};
end;

if isfield(synapseel.model.plasticity_params,'scaleDW'),
	scaleDW = synapseel.model.scaleDW;
else,
	scaleDW = 1;
end;


if prespike|postspike,
	Tnow = synapseel.T;
	tpre_exclude = find(modelstruct(synapseel.model.pre).model.spiketimes-eps>Tnow,1,'first');
	if isempty(tpre_exclude), tpre_exclude = 1+length(modelstruct(synapseel.model.pre).model.spiketimes); end;
	tpost_exclude = find(modelstruct(synapseel.model.post).model.spiketimes-eps>Tnow,1,'first');
	if isempty(tpost_exclude), tpost_exclude = 1+length(modelstruct(synapseel.model.post).model.spiketimes); end;

	if synapseel.model.plasticity_params.classic_stdp,
		dW = vlt.neuroscience.stdp.stdp_apply( modelstruct(synapseel.model.pre).model.spiketimes(1:tpre_exclude-1),...
			 modelstruct(synapseel.model.post).model.spiketimes(1:tpost_exclude-1),...
			'T0',Tnow-eps,synapseel.model.plasticity_params.params{:});
		%if postspike,
		%	Tnow, dW,
		%	if dW==0,
		%		keyboard;
		%	end;
		%end;
	else,
		dW = vlt.neuroscience.stdp.stdp_triplet_apply( modelstruct(synapseel.model.pre).model.spiketimes(1:tpre_exclude-1),...
			 modelstruct(synapseel.model.post).model.spiketimes(1:tpost_exclude-1),...
			'T0',Tnow-eps,synapseel.model.plasticity_params.params{:});
	end;
	synapseel.model.Gmax = synapseel.model.Gmax + synapseel.model.plasticity_params.Gmax_max * dW * scaleDW;
	synapseel.model.Gmax = min(synapseel.model.Gmax,synapseel.model.plasticity_params.Gmax_max); % ceiling
	synapseel.model.Gmax = max(synapseel.model.Gmax,synapseel.model.plasticity_params.Gmax_min); % floor
end;
