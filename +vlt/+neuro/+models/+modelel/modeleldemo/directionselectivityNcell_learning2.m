function out = directionselectivityNcell_learning2(varargin)
% DIRECTIONSELECTIVITYNCELL_LEARNING2
%
% OUT = vlt.neuro.models.modelel.modeleldemo.directionselectivityNcell_learning2
%
% Observe an N-input process develop direction selectivity
%
% There is a single feed-forward inhibitory neuron
%
% One can also adjust the parameters using: 
% OUT = vlt.neuro.models.modelel.modeleldemo.directionselectivity4cell_learning1(PARAM1NAME, PARAM1VALUE, ...)
%   
% The following parameters are adjustable (default value in ()):
% ---------------------------------------------------------------------
% latency (0.200)         |  Latency between 1st and 2nd columns
% lag (0.200)             |  Lag between stim hitting 1st and 2nd rows
% Gmax_max (5e-9)         |  Maximum weights
% Gmax_min (0)            |  Minimum weights
% classic_stdp (1)        |  0/1 use classic stdp
% N (1)                   |  Number of different positions
% R (1)                   |  Number of different latencies
% Gmax_initial (3e-9)     |  1xN*R matrix of initial synaptic weights
% Gmax_initial_inhib(3e-9)|  1xN*R matrix of initial synaptic weights
% synapseparams           |  synapse parameters
% synapseparams_inhib     |  synapse parameters for synapses onto inhibitory cells
%   {'V_rev',-0.080}      |
% intfireparams           |  intfire parameters
% intfireparams_inhib     |  intfire parameters for inhibitory cell
% ISyn_Gmax_initial (1.5e-9)|  Intial value of inhibitory cell synapse onto excitatory cell
% ISyn_change (1.05)      |  Multilpicative Change in inhibitory synapse conductance at each iteration
% ISyn_Max (Inf)          |  Ceiling for I to E weight
% dt (0.0001)             |  time resolution
% trials (100)            |  number of trials
% plot_as_we_go (1)       |  0/1 plot to a figure as we go?
% plasticity_method_inhib('') Method for inhibitory plasticity
% unidir (1)              |  unidirectional trainin (1) or bi-directional training (2)?
% slow (0)                |  Show stimulus at half speed?
% mask (1)
% nreps (1)
% phase ([1:N])           |  Phase?
% 

% Step 1 - build the model

latency = 0.200;
lag = latency;
%stdp_params = {}; % not used
% stdp_params             |  {'name1','value1',...} extra plasticity parameters
%                         |   (for example, {'tau_plus',0.020,'tau_minus',0.020})
Gmax_max = 5e-9;
Gmax_min = 0;
classic_stdp = 1;
N = 1;
R = 1;
Gmax_initial = 3e-9 * ones(1,N*R);
Gmax_initial_inhib = 3e-9 * ones(1,N*R);
synmeth = 'vlt.neuro.models.modelel.synapseel.plasticity_methods.synapseel_stdp';
dt = 0.0001;
trials = 100;
synapseparams = {};
intfireparams = {};
synapseparams_inhib = {'V_rev',-0.080};
intfireparams_inhib = {};
ISyn_Gmax_initial = 0.5e-9;
ISyn_change = 1.05;
%ISyn_change = 2.36e-11;
ISyn_Max = Inf;
plasticity_method_inhibff = '';
plot_as_we_go = 1;
unidir = 1;
slow = 0;
mask =1;
nreps = 1;
phase = [];
plotit = 0;
initial_simdown = 1;

  % these seem not be used currently
isi = 1;  % not used that I can tell
timesteps_per_trial = isi/dt;  % not used presently

vlt.data.assign(varargin{:});

synp = struct('Gmax_max',Gmax_max,'Gmax_min',Gmax_min,'classic_stdp',classic_stdp);
Syn_Gmax_initial = Gmax_initial;
Syn_Gmax_initial_inhib = Gmax_initial_inhib;

if numel(Syn_Gmax_initial)==1,
	Syn_Gmax_initial = Gmax_initial * ones(1,N*R);
end;

if numel(Syn_Gmax_initial_inhib)==1,
	Syn_Gmax_initial_inhib = Gmax_initial_inhib * ones(1,N*R);
end;

if plot_as_we_go,
	fig = figure;
else,
	fig = [];
end;

total_trials = trials;
if unidir==0, total_trials = 2 * trials; end;
 
  % convert trials to total_trials

di = NaN(1,total_trials);
r_up = NaN(1,total_trials);
r_down = NaN(1,total_trials);
gmaxes = NaN(N*R,total_trials);
inhib_gmaxes = NaN(N*R,total_trials);
ctx_inhib = NaN(1,total_trials);
inhib_r_up = NaN(1,total_trials);
inhib_r_down = NaN(1,total_trials);

[model_initial,di(1),r_up(1),r_down(1),dummy,dummy,inhib_r_up(1),inhib_r_down(1)] = vlt.neuro.models.modelel.modeleldemo.directionselectivityNcelldemo_inhib('dt',dt,...
	'latency',latency,'lag',lag,'slow',slow,'mask',mask,...
	'N',N,'R',R,...
	'isi',isi,'nreps',nreps,...
	'Syn_Gmax_initial',Syn_Gmax_initial, 'Syn_Gmax_initial_inhib',Syn_Gmax_initial_inhib, 'plotit',plotit,...
	'synapseparams',synapseparams,'intfireparams',intfireparams,...
	'intfireparams_inhib',intfireparams_inhib,'synapseparams_inhib',synapseparams_inhib,...
	'ISyn_Gmax_initial',ISyn_Gmax_initial,'phase',phase,'simdown','initial_simdown'...
	);

syn_nums = vlt.neuro.models.modelel.synapseel.modelelgetsyn(model_initial,[1:N*R],N*R+ones(1,N*R));
inhibsyn_nums = vlt.neuro.models.modelel.synapseel.modelelgetsyn(model_initial,[1:N*R],N*R+1+ones(1,N*R));

gmaxes(:,1) = [Syn_Gmax_initial]';
inhib_gmaxes(:,1) = [Syn_Gmax_initial_inhib]';
ctx_inhib(1) = ISyn_Gmax_initial;

trialstepsize = 1; 
if unidir==0, trialstepsize = 1; end;

plasticity_arguments = {'plasticity_params',synp,'plasticity_method',synmeth,'plasticity_method_inhibff',plasticity_method_inhibff};


for t=2:trialstepsize:total_trials,
	disp(['Running trial ' int2str(t) ' of ' int2str(total_trials) '.']);

	input_select = 0;
	if unidir==0,
		if mod(t,2),
			plasticity_arguments_down = plasticity_arguments;
			plasticity_arguments_up = {};
			input_select = -1;
		else,
			plasticity_arguments_up = plasticity_arguments;
			plasticity_arguments_down = {};
			input_select = 0;
		end;
	else,
		input_select = 0;
		plasticity_arguments_down = {};
		plasticity_arguments_up = plasticity_arguments;
	end;

	if unidir==1 | (mod(t,2)==0),
		% run in upward direction
		[dummy,dummy,r_up(t),dummy,model_current,dummy,inhib_r_up(t)] = vlt.neuro.models.modelel.modeleldemo.directionselectivityNcelldemo_inhib('dt',dt,...
		'R', R, 'N', N, 'isi', isi, 'nreps',nreps,...
		'latency',latency,'lag',lag,'slow',slow,'mask',mask,...
		'Syn_Gmax_initial',gmaxes(:,t-1)',...
		'plotit',plotit,'simup',1,'simdown',0,...
		'synapseparams',synapseparams,'intfireparams',intfireparams, ...
		'Syn_Gmax_initial_inhib',inhib_gmaxes(:,t-1)',...
		'intfireparams_inhib',intfireparams_inhib,'synapseparams_inhib',synapseparams_inhib,...
		'ISyn_Gmax_initial',ctx_inhib(t-1), plasticity_arguments_up{:},'phase',phase ...
		);

		% get the conductances here
		for i=1:length(syn_nums),
			gmaxes(i,t) = model_current.Model_Final_Structure(syn_nums(i)).model.Gmax;
			inhib_gmaxes(i,t) = model_current.Model_Final_Structure(inhibsyn_nums(i)).model.Gmax;
		end;

		ctx_inhib(t) = ctx_inhib(t-1) * ISyn_change;
		if ctx_inhib(t) > ISyn_Max,
			ctx_inhib(t) = ISyn_Max;
		end;
	end;

	% figure out the 'down' spikes

		[dummy,dummy,dummy,r_down(t),dummy,model_current,dummy,inhib_r_down(t)] = vlt.neuro.models.modelel.modeleldemo.directionselectivityNcelldemo_inhib('dt',dt,...
		'R', R, 'N', N, 'isi', isi, 'nreps',nreps,...
		'latency',latency','lag',lag,'slow',slow,...
		'Syn_Gmax_initial',gmaxes(:,t+input_select)', ...
		'plotit',plotit, 'simup', 0, 'simdown', 1, 'mask',mask,...
		'synapseparams',synapseparams,'intfireparams',intfireparams, ...
		'Syn_Gmax_initial_inhib',inhib_gmaxes(:,t+input_select)',...
		'intfireparams_inhib',intfireparams_inhib,'synapseparams_inhib',synapseparams_inhib,...
		'ISyn_Gmax_initial',ctx_inhib(t+input_select), plasticity_arguments_down{:},'phase',phase ...
		);

	if (unidir==0 & (mod(t,2)==1)),
		for i=1:length(syn_nums),
			gmaxes(i,t) = model_current.Model_Final_Structure(syn_nums(i)).model.Gmax;
			inhib_gmaxes(i,t) = model_current.Model_Final_Structure(inhibsyn_nums(i)).model.Gmax;
		end;
		ctx_inhib(t) = ctx_inhib(t-1) * ISyn_change;
		if ctx_inhib(t) > ISyn_Max,
			ctx_inhib(t) = ISyn_Max;
		end;

		% test with upward direction to get hypothetical selectivity
		[dummy,dummy,r_up(t),dummy,model_current,dummy,inhib_r_up(t)] = vlt.neuro.models.modelel.modeleldemo.directionselectivityNcelldemo_inhib('dt',dt,...
		'R', R, 'N', N, 'isi', isi, 'slow',slow,'mask',mask,'nreps',nreps,...
		'latency',latency,'lag',lag,...
		'Syn_Gmax_initial',gmaxes(:,t)',...
		'plotit',plotit,'simup',1,'simdown',0,...
		'synapseparams',synapseparams,'intfireparams',intfireparams, ...
		'Syn_Gmax_initial_inhib',inhib_gmaxes(:,t)',...
		'intfireparams_inhib',intfireparams_inhib,'synapseparams_inhib',synapseparams_inhib,...
		'ISyn_Gmax_initial',ctx_inhib(t), plasticity_arguments_up{:},'phase',phase ...
		);
	end;

	di = (r_up - r_down)./(r_up+r_down);

	if plot_as_we_go,
		figure(fig);
		out.di = di;
		out.r_up = r_up;
		out.r_down = r_down;
		out.gmaxes = gmaxes;
		out.inhib_gmaxes = inhib_gmaxes;
		out.ctx_inhib = ctx_inhib;
		out.inhib_r_up = inhib_r_up;
		out.inhib_r_down = inhib_r_down;
		vlt.neuro.models.modelel.modeleldemo.plotdirectionselectivity4cell(out);
		drawnow; % make sure it draws before we proceed
	end;
end;

out.di = di;
out.r_up = r_up;
out.r_down = r_down;
out.gmaxes = gmaxes;
out.inhib_gmaxes = inhib_gmaxes;
out.ctx_inhib = ctx_inhib;
out.inhib_r_up = inhib_r_up;
out.inhib_r_down = inhib_r_down;
