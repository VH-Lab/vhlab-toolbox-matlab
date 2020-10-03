function [modelel] = modelel_init(varargin)
% MODELEL_INIT - Initialize a model element
%
%   MODELEL= MODELEL_INIT
%       or
%   MODELEL = MODELEL_INIT(PARAM1NAME, PARAM1VALUE, ...)
%
%   Creates a MODELEL structure. A default model is created unless
%   parameters are modified by passing name, value pairs. This framework
%   can describe any element that has a time T and an integration step time
%   dT.
%
%   Returns a structure MODELEL describing a neuron:
%   -------------------------------------------------------
%   T (0)                   | Current time (seconds)
%   dT  (1e-4)              | Step time (seconds)
%   name ('')               | Name of the neuron (character string)
%   type ('modelel')        | Type: must be 'modelel' (not modifiable)
%   model ('none')          | Structure for the model such as
%                           |    that returned by 'intfireleaky'
%
%   See HELP MODELELS for a list of valid neuron model types.
%
%   Examples:
%      intfire=intfireleaky_init; % create a default LI&F neuron
%      
%

T = 0;
dT = 1e-4;
spiketimes = [];
name = '';
model = 'none';

assign(varargin{:});

type = 'modelel';

modelel = struct('T',T,'dT',dT,'spiketimes',spiketimes,'name',name,'type',type,'model',model);


