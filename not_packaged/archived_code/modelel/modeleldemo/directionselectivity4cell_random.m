function out = directionselectivity4cell_random(varargin)
% DIRECTIONSELECTIVITY4CELL_RANDOM
%
% OUT = DIRECTIONSELECTIVITY4CELL_RANDOM
%
% Randomly choose weights for a 4-input single layer network and
% calculate direction selectivity
%
% One can also adjust the parameters using: 
% OUT = DIRECTIONSELECTIVITY4CELL_RANDOM(PARAM1NAME, PARAM1VALUE, ...)
%   
% The following parameters are adjustable (default value in ()):
% ---------------------------------------------------------------------
% latency (0.200)         |  Latency between 1st and 2nd columns
% lag (0.200)             |  Lag between stim hitting 1st and 2nd rows
% Gmax_max (5e-9)         |  Maximum weights
% Gmax_min (0)            |  Minimum weights
% classic_stdp (1)        |  0/1 use classic stdp
% synapseparams           |  synapse parameters
% intfireparams           |  intfire parameters
% dt (0.0001)             |  time resolution
% trials (100)            |  number of trials
% plot_as_we_go (1)       |  0/1 plot to a figure as we go?

% Step 1 - build the model

latency = 0.200;
lag = latency;
Gmax_max = 5e-9;
Gmax_min = 0;
classic_stdp = 1;
dt = 0.0001;
trials = 100;
synapseparams = {};
intfireparams = {};
spikethresholdinterval = [-0.055 -0.055];

plot_as_we_go = 1;

  % these seem not be used currently
  isi = 1;  % not used that I can tell
  timesteps_per_trial = isi/dt;  % not used presently

assign(varargin{:});

if plot_as_we_go,
	fig = figure;
else,
	fig = [];
end;

di = zeros(1,trials);
r_up = zeros(1,trials);
r_down = zeros(1,trials);
gmaxes = zeros(4,trials);
T = zeros(1,trials);

for t=1:trials,
	disp(['Running trial ' int2str(t) ' of ' int2str(trials) '.']);
	% run in upward direction

	theGmaxes = Gmax_min + rand(1,4)*(Gmax_max-Gmax_min);

	theT = spikethresholdinterval(1) + rand*(diff(spikethresholdinterval));

	intfireparams = cat(2,intfireparams, {'V_threshold',theT});

	[dummy,dummy,r_up(t),r_down(t),model_current] = directionselectivity4celldemo('dt',dt,...
		'latency',latency,'lag',lag,...
		'Syn_Gmax_initial',theGmaxes,...
		'plotit',0,'synapseparams',synapseparams,'intfireparams',intfireparams);

	% get the conductances here
	for i=1:4,
		gmaxes(i,t) = theGmaxes(i);
	end;

	T(t) = theT;

	% figure out the 'down' spikes

	di = (r_up - r_down)./(r_up+r_down);

	if plot_as_we_go,
		figure(fig);
		out.di = di;
		out.r_up = r_up;
		out.r_down = r_down;
		out.gmaxes = gmaxes;
		out.T = T;
		plotdirectionselectivity4cell(out);
		drawnow; % make sure it draws before we proceed
	end;
end;

out.di = di;
out.r_up = r_up;
out.r_down = r_down;
out.gmaxes = gmaxes;
out.T = T;
