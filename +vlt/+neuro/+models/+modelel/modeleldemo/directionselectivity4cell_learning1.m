function out = directionselectivity4cell_learning1(varargin)
% DIRECTIONSELECTIVITY4CELL_LEARNING1
%
% OUT = vlt.neuroscience.models.modelel.modeleldemo.directionselectivity4cell_learning1
%
% Observe a 4-input process develop and then lose direction selectivity
%
% One can also adjust the parameters using: 
% OUT = vlt.neuroscience.models.modelel.modeleldemo.directionselectivity4cell_learning1(PARAM1NAME, PARAM1VALUE, ...)
%   
% The following parameters are adjustable (default value in ()):
% ---------------------------------------------------------------------
% latency (0.200)         |  Latency between 1st and 2nd columns
% lag (0.200)             |  Lag between stim hitting 1st and 2nd rows
% Gmax_max (5e-9)         |  Maximum weights
% Gmax_min (0)            |  Minimum weights
% classic_stdp (1)        |  0/1 use classic stdp
% Gmax_initial (3e-9)     |  1x4 matrix of initial synaptic weights
% stdp_params             |  {'name1','value1',...} extra plasticity parameters
%                         |   (for example, {'tau_plus',0.020,'tau_minus',0.020})
% synapseparams           |  synapse parameters
% intfireparams           |  intfire parameters
% dt (0.0001)             |  time resolution
% trials (100)            |  number of trials
% plot_as_we_go (1)       |  0/1 plot to a figure as we go?

% Step 1 - build the model

latency = 0.200;
lag = latency;
stdp_params = {};
Gmax_max = 5e-9;
Gmax_min = 0;
classic_stdp = 1;
Gmax_initial = 3e-9 * ones(1,4);
synmeth = 'vlt.neuroscience.models.modelel.synapseel.plasticity_methods.synapseel_stdp';
dt = 0.0001;
trials = 100;
synapseparams = {};
intfireparams = {};

plot_as_we_go = 1;

  % these seem not be used currently
  isi = 1;  % not used that I can tell
  timesteps_per_trial = isi/dt;  % not used presently

vlt.data.assign(varargin{:});

synp = struct('Gmax_max',Gmax_max,'Gmax_min',Gmax_min,'classic_stdp',classic_stdp);
Syn_Gmax_initial = Gmax_initial;

if plot_as_we_go,
	fig = figure;
else,
	fig = [];
end;

di = zeros(1,trials);
r_up = zeros(1,trials);
r_down = zeros(1,trials);
gmaxes = zeros(4,trials);

[model_initial,di(1),r_up(1),r_down(1)] = vlt.neuroscience.models.modelel.modeleldemo.directionselectivity4celldemo('dt',dt,...
	'latency',latency,'lag',lag,...
	'Syn_Gmax_initial',Syn_Gmax_initial, 'plotit',0,'synapseparams',synapseparams,'intfireparams',intfireparams);

syn_nums = vlt.neuroscience.models.modelel.synapseel.modelelgetsyn(model_initial,[1 2 3 4],[5 5 5 5]);

gmaxes(:,1) = [Syn_Gmax_initial]';

global model_current

for t=2:trials,
	disp(['Running trial ' int2str(t) ' of ' int2str(trials) '.']);
	% run in upward direction
	[dummy,dummy,r_up(t),dummy,model_current] = vlt.neuroscience.models.modelel.modeleldemo.directionselectivity4celldemo('dt',dt,...
		'latency',latency,'lag',lag,...
		'Syn_Gmax_initial',gmaxes(:,t-1)',...
		'plasticity_params',synp,'plasticity_method',synmeth,...
		'plotit',0,'simup',1,'simdown',0,'synapseparams',synapseparams,'intfireparams',intfireparams);


	% get the conductances here
	for i=1:length(syn_nums),
		gmaxes(i,t) = model_current.Model_Final_Structure(syn_nums(i)).model.Gmax;
	end;

	% figure out the 'down' spikes

	[dummy,dummy,dummy,r_down(t)] = vlt.neuroscience.models.modelel.modeleldemo.directionselectivity4celldemo('dt',dt,'latency',latency','lag',lag,...
		'Syn_Gmax_initial',gmaxes(:,t)', 'plotit',0, 'simup', 0,'synapseparams',synapseparams,'intfireparams',intfireparams);

	di = (r_up - r_down)./(r_up+r_down);

	if plot_as_we_go,
		figure(fig);
		out.di = di;
		out.r_up = r_up;
		out.r_down = r_down;
		out.gmaxes = gmaxes;
		vlt.neuroscience.models.modelel.modeleldemo.plotdirectionselectivity4cell(out);
		drawnow; % make sure it draws before we proceed
	end;
end;

out.di = di;
out.r_up = r_up;
out.r_down = r_down;
out.gmaxes = gmaxes;
