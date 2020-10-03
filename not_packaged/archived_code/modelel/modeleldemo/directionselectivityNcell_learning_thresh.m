function out = directionselectivityNcell_learning_thresh(varargin)
% DIRECTIONSELECTIVITYNCELL_LEARNING_THRESH
%
% OUT = DIRECTIONSELECTIVITYNCELL_LEARNING_THRESH
%
% Observe an N-input process develop direction selectivity
%
% No inhibition, threshold increases after each trial
%
% One can also adjust the parameters using: 
% OUT = DIRECTIONSELECTIVITY4CELL_LEARNING_THRESH(PARAM1NAME, PARAM1VALUE, ...)
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
% synapseparams           |  synapse parameters
%   {'V_rev',-0.080}      |
% intfireparams           |  intfire parameters
% dt (0.0001)             |  time resolution
% trials (100)            |  number of trials
% plot_as_we_go (1)       |  0/1 plot to a figure as we go?
% unidir (1)              |  unidirectional trainin (1) or bi-directional training (2)?
% slow (0)                |  Show stimulus at half speed?
% V_threshold_initial     |  Starting threshold value (volts)
%   (-0.055)           
% V_threshold_change      |  Multilpicative change in threshold at each iteration must be <1
%   (0.95)
% V_threshold_max (-0.04) |  Ceiling output cell threshold can reach
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
synmeth = 'synapseel_stdp';
dt = 0.0001;
trials = 100;
synapseparams = {};
intfireparams = {};
plot_as_we_go = 1;
unidir = 1;
slow = 0;
V_threshold_initial = -0.055;
V_threshold_change = 0.95;
V_threshold_max = -0.04;
mask =1;
nreps = 1;
phase = [];
plotit = 0;
initial_simdown = 1;

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

total_trials = trials;
if unidir==0, total_trials = 2 * trials; end;
 
  % convert trials to total_trials

di = NaN(1,total_trials);
r_up = NaN(1,total_trials);
r_down = NaN(1,total_trials);
gmaxes = NaN(N*R,total_trials);
V_threshold = NaN(1,total_trials);


[model_initial,di(1),r_up(1),r_down(1),dummy,dummy] = directionselectivityNcelldemo_thresh('dt',dt,...
	'latency',latency,'lag',lag,'slow',slow,'mask',mask,...
	'N',N,'R',R,...
	'isi',isi,'nreps',nreps,...
	'Syn_Gmax_initial',Syn_Gmax_initial, 'plotit',plotit,...
	'synapseparams',synapseparams,'intfireparams',intfireparams,...
	'V_threshold',V_threshold_initial,'phase',phase,'simdown','initial_simdown'...
	);

syn_nums = modelelgetsyn(model_initial,[1:N*R],N*R+ones(1,N*R));

gmaxes(:,1) = [Syn_Gmax_initial]';
V_threshold(1) = V_threshold_initial;

trialstepsize = 1; 
if unidir==0, trialstepsize = 1; end;

plasticity_arguments = {'plasticity_params',synp,'plasticity_method',synmeth};


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
		[dummy,dummy,r_up(t),dummy,model_current,dummy] = directionselectivityNcelldemo_thresh('dt',dt,...
		'R', R, 'N', N, 'isi', isi, 'nreps',nreps,...
		'latency',latency,'lag',lag,'slow',slow,'mask',mask,...
		'Syn_Gmax_initial',gmaxes(:,t-1)',...
		'plotit',plotit,'simup',1,'simdown',0,...
		'synapseparams',synapseparams,'intfireparams',intfireparams, ...
		'V_threshold',V_threshold(t-1), plasticity_arguments_up{:},'phase',phase ...
		);

		% get the conductances here
		for i=1:length(syn_nums),
			gmaxes(i,t) = model_current.Model_Final_Structure(syn_nums(i)).model.Gmax;
		end;

		V_threshold(t) = V_threshold(t-1) + V_threshold_change;
		if V_threshold(t) > V_threshold_max,
			V_threshold(t) = V_threshold_max;
		end;
	end;

	% figure out the 'down' spikes

		[dummy,dummy,dummy,r_down(t),dummy,model_current] = directionselectivityNcelldemo_thresh('dt',dt,...
		'R', R, 'N', N, 'isi', isi, 'nreps',nreps,...
		'latency',latency','lag',lag,'slow',slow,...
		'Syn_Gmax_initial',gmaxes(:,t+input_select)', ...
		'plotit',plotit, 'simup', 0, 'simdown', 1, 'mask',mask,...
		'synapseparams',synapseparams,'intfireparams',intfireparams, ...
		'V_threshold',V_threshold(t+input_select), plasticity_arguments_down{:},'phase',phase ...
		);

	if (unidir==0 & (mod(t,2)==1)),
		for i=1:length(syn_nums),
			gmaxes(i,t) = model_current.Model_Final_Structure(syn_nums(i)).model.Gmax;
		end;
		V_threshold(t) = V_threshold(t-1) * V_threshold_change;
		if V_threshold(t) > V_threshold_max,
			V_threshold(t) = V_threshold_max;
		end;

		% test with upward direction to get hypothetical selectivity
		[dummy,dummy,r_up(t),dummy,model_current,dummy] = directionselectivityNcelldemo_thresh('dt',dt,...
		'R', R, 'N', N, 'isi', isi, 'slow',slow,'mask',mask,'nreps',nreps,...
		'latency',latency,'lag',lag,...
		'Syn_Gmax_initial',gmaxes(:,t)',...
		'plotit',plotit,'simup',1,'simdown',0,...
		'synapseparams',synapseparams,'intfireparams',intfireparams, ...
		'V_threshold',V_threshold(t), plasticity_arguments_up{:},'phase',phase ...
		);
	end;

	di = (r_up - r_down)./(r_up+r_down);

	if plot_as_we_go,
		figure(fig);
        out.di = di;
        out.r_up = r_up;
        out.r_down = r_down;
        out.gmaxes = gmaxes;
        out.V_threshold = V_threshold;
		plotdirectionselectivity4cell_thresh(out);
		drawnow; % make sure it draws before we proceed
	end;
end;

out.di = di;
out.r_up = r_up;
out.r_down = r_down;
out.gmaxes = gmaxes;
out.V_threshold = V_threshold;
