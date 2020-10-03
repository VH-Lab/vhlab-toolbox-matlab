function out = directionselectivityNcell_learning1(varargin)
% DIRECTIONSELECTIVITYNCELL_LEARNING1
%
% OUT = DIRECTIONSELECTIVITYNCELL_LEARNING1
%
% Observe a 4-input process develop and then lose direction selectivity
%
% One can also adjust the parameters using: 
% OUT = DIRECTIONSELECTIVITY4CELL_LEARNING1(PARAM1NAME, PARAM1VALUE, ...)
%   
% The following parameters are adjustable (default value in ()):
% ---------------------------------------------------------------------
% latency (0.200)         |  Latency between 1st and 2nd columns
% lag (0.200)             |  Lag between stim hitting 1st and 2nd rows
% Gmax_max (5e-9)         |  Maximum weights
% Gmax_min (0)            |  Minimum weights
% classic_stdp (1)        |  0/1 use classic stdp
% N (2)                   |  Number of different positions
% R (2)                   |  Number of different latencies
% Gmax_initial (3e-9)     |  1xN*R matrix of initial synaptic weights
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
N = 1;
R = 1;
Gmax_initial = 3e-9 * ones(1,N*R);
synmeth = 'synapseel_stdp';
dt = 0.0001;
nreps = 1;
trials = 100;
synapseparams = {};
intfireparams = {};

plot_as_we_go = 1;

  % these seem not be used currently
isi = 1;  % not used that I can tell
timesteps_per_trial = isi/dt;  % not used presently

assign(varargin{:});

synp = struct('Gmax_max',Gmax_max,'Gmax_min',Gmax_min,'classic_stdp',classic_stdp);
Syn_Gmax_initial = Gmax_initial;

if numel(Syn_Gmax_initial)==1,
	Syn_Gmax_initial = Gmax_initial * ones(1,N*R);
end;

if plot_as_we_go,
	fig = figure;
else,
	fig = [];
end;

di = NaN(1,trials);
r_up = NaN(1,trials);
r_down = NaN(1,trials);
gmaxes = NaN(N*R,trials);

[model_initial,di(1),r_up(1),r_down(1)] = directionselectivityNcelldemo('dt',dt,...
	'latency',latency,'lag',lag,...
	'N',N,'R',R,...
	'isi',isi,...
	'Syn_Gmax_initial',Syn_Gmax_initial, 'plotit',0,...
	'synapseparams',synapseparams,'intfireparams',intfireparams,'nreps',nreps);

syn_nums = modelelgetsyn(model_initial,[1:N*R],N*R+ones(1,N*R));

gmaxes(:,1) = [Syn_Gmax_initial]';

for t=2:trials,
	disp(['Running trial ' int2str(t) ' of ' int2str(trials) '.']);
	% run in upward direction
	[dummy,dummy,r_up(t),dummy,model_current] = directionselectivityNcelldemo('dt',dt,...
		'R', R, 'N', N, 'isi', isi, ...
		'latency',latency,'lag',lag,...
		'Syn_Gmax_initial',gmaxes(:,t-1)',...
		'plasticity_params',synp,'plasticity_method',synmeth,...
		'plotit',0,'simup',1,'simdown',0,'synapseparams',synapseparams,'intfireparams',intfireparams,'nreps',nreps);

	% get the conductances here
	for i=1:length(syn_nums),
		gmaxes(i,t) = model_current.Model_Final_Structure(syn_nums(i)).model.Gmax;
	end;

	% figure out the 'down' spikes

	[dummy,dummy,dummy,r_down(t)] = directionselectivityNcelldemo('dt',dt,'latency',latency','lag',lag,...
		'Syn_Gmax_initial',gmaxes(:,t)', 'plotit',0, 'simup', 0, ...
		'synapseparams',synapseparams,'intfireparams',intfireparams, ...
		'N',N,'R',R,'isi',isi,'nreps',nreps);

	di = (r_up - r_down)./(r_up+r_down);

	if plot_as_we_go,
		figure(fig);
		out.di = di;
		out.r_up = r_up;
		out.r_down = r_down;
		out.gmaxes = gmaxes;
		plotdirectionselectivity4cell(out);
		drawnow; % make sure it draws before we proceed
	end;
end;

out.di = di;
out.r_up = r_up;
out.r_down = r_down;
out.gmaxes = gmaxes;
