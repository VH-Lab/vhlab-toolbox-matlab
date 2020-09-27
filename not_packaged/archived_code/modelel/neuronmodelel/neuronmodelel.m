function list = neuronmodelel
% NEURONMODELEL - A list of neuron model element classes
%
%   LIST = NEURONMODELEL
%
%   This is a list of neuron models that can be used
%   with the NEURONMODEL class of functions.
%
%   -----------------------------------------------------------
%   'spiketimelistel'  |  No model, just a list of spike times
%   'intfireleakyel'   |  Leaky integrate and fire neuron
%                      |    (see HELP INTFIRELEAKY_INIT)

list = {...
	'spiketimelistel' ...
	'intfireleakyel' ...
	};

