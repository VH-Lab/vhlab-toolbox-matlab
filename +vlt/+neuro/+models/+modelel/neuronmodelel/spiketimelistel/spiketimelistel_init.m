function [spiketimelistel] = spiketimelistelel_init(varargin)
% SPIKETIMELISTEL_INIT - Initialize a spiketimelistel model
%
%   SPIKETIMELIST= vlt.neuroscience.models.modelel.neuronmodelel.spiketimelistel.spiketimelistel_init
%       or
%   SPIKETIMELIST = vlt.neuroscience.models.modelel.neuronmodelel.spiketimelistel.spiketimelistel_init(PARAM1NAME, PARAM1VALUE, ...)
%
%   Creates a SPIKETIMELISTEL model. A default model is created unless
%   parameters are modified by passing name, value pairs.
%
%   Name/parameter values will be passed along to the modelel class as well.
%
%   The spiketimelistel parameters:
%   -------------------------------------------------------
%   spiketimes ([])           | Spike times of the neuron (seconds), can assume sorted
%   type ('spiketimelistel')  | Type: must be 'spiketimelistel' (not modifiable)
%
%   See HELP SPIKETIMELIST for a list of valid neuron model types.
%

spiketimes = [];
vlt.data.assign(varargin{:});

type = 'spiketimelistel';
spiketimestruct = struct('spiketimes',sort(spiketimes),'type',type);
spiketimelistel = vlt.neuroscience.models.modelel.modelel.modelel_init('model',spiketimestruct,varargin{:});


