function [intfireleakyel] = intfireleakyel_init(varargin)
% INTFIRELEAKY_INIT - Initialize a leaky integrate and fire neuron
%
%   INTFIRELEAKYEL = INTFIRELEAKYel_INIT
%         or
%   INTFIRELEAKYEL = INTFIRELEAKYel_INIT('param1name',param1value,...);
%
%   Returns a MODELEL structure (see MODELEL_INIT) for a
%   leaky integrate and fire neuron. One can modify the default parameters
%   of both the INTFIRE structure and the inherited parameters in
%   MODELEL by passing name/value pairs as input arguments. The parameters in the
%   structure are as follows:
%
%   INTFIRE structure:
%   -------------------------------------------------------
%   Ie (0)                  | Any electrode current (Amps)
%   V (-0.075)              | The current voltage (volts)
%   V_leak (default -0.075) | Leak potential (volts) 
%   Rm      (10e6)          | Input resistance (Ohms) 
%   Taum    (10e-3)         | Membrane time constant (seconds)
%   Area    (0.1)           | Area (mm^2; for calculating specific resistance)
%   V_reset (-0.080)        | Reset potential (volts)
%   V_threshold (-0.055)    | Threshold value (volts)
%   synapse_list ([])       | List of modelel numbers that correspond to synapses
%   spiketimes ([])         | List of spike times
%   V_spike (0.010)         | Potential the neuron rises to upon spiking
%   type ('intfireleakyel') | Must be the string 'intfireleakyel'
%
%   See HELP MODELEL for the generic model element parameters.
%

Ie = 0;
V_leak = -0.075;
Rm=10e6;
Taum=10e-3;
Area = 0.1;
V_reset = -0.080;
V_threshold = -0.055;
V = -0.075;
synapse_list = [];
spiketimes = [];
V_spike = 0.010;

assign(varargin{:});

type = 'intfireleakyel';

intfire=struct('Ie',Ie,'V_leak',V_leak,'Rm',Rm,'Taum',Taum,'Area',Area,...
		'V_reset',V_reset,'V_threshold',V_threshold,'V',V,...
		'synapse_list',synapse_list,'spiketimes',spiketimes,'V_spike',V_spike,...
		'type',type);

intfireleakyel = modelel_init('model',intfire,varargin{:});

