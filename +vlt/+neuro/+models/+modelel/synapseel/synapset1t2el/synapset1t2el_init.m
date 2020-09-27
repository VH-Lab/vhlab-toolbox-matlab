function synapset1t2el = synapset1t2el_init(varargin)
% SYNAPSET1T2EL_INIT - Initialize a new synapset1t2el object
%
%
% Conductance after each presynaptic spike is modeled as 
% G = Gmax * (exp(-deltaT/tau1) - exp(-deltaT/tau2)), where
%   deltaT is the difference between now and all previous spikes
%  
% SYNAPSET1T2EL parameters are the following:
% --------------------------------------------------------------
%   V_rev (0)                |   Reversal potential (volts)
%   Gmax (10e-9)             |   Maximal conductance (Siemens)
%   G (0)                    |   The current conductance value (Siemens)
%   tau1 (0.001)             |   Tau1 (seconds)
%   tau2 (0.050)             |   Tau2 (seconds)
%   pre ([])                 |   Modelel number of presynaptic cell
%   post ([])                |   Modelel number of postsynaptic cell
%   Tpast_ignore (1)         |   How long in the past to monitor spikes (seconds)
%   plasticity_method ('')   |   Plasticity method
%   plasticity_params ([])   |   Plasticity method parameters
%   type                     |   Must be 'synapset1t2el' (not editable)


 % default parameters

V_rev = 0.00;
Gmax = 10e-9;
G = 0;
tau1 = 0.001;
tau2 = 0.050;
pre = [];
post = [];
Tpast_ignore = 1; 
plasticity_method = '';
plasticity_params = [];

vlt.data.assign(varargin{:});

if strcmp(lower(plasticity_method),'none'), plasticity_method = ''; end;

type = 'synapset1t2el';

synapset1t2elstruct = struct( ...
	'V_rev',V_rev, ...
	'Gmax',Gmax,...
	'G',G,...
	'tau1',tau1,...
	'tau2',tau2,...
	'pre',pre,...
	'post',post,...
	'Tpast_ignore',Tpast_ignore,...
	'plasticity_method', plasticity_method, ...
	'plasticity_params',plasticity_params, ...
	'type',type ...
	);

synapset1t2el = vlt.neuroscience.models.modelel.modelel.modelel_init('model',synapset1t2elstruct,varargin{:});
