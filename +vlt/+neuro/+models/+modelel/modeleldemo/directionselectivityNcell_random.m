function out = directionselectivityNcell_random(varargin)
% DIRECTIONSELECTIVITYNCELL_RANDOM
%
% OUT = vlt.neuro.models.modelel.modeleldemo.directionselectivityNcell_random
%
% Randomly choose weights for a N-input single layer network and
% calculate direction selectivity
%
% One can also adjust the parameters using: 
% OUT = vlt.neuro.models.modelel.modeleldemo.directionselectivityNcell_random(PARAM1NAME, PARAM1VALUE, ...)
%   
% The following parameters are adjustable (default value in ()):
% ---------------------------------------------------------------------
% latency (0.200)         |  Latency between 1st and 2nd columns
% lag (0.200)             |  Lag between stim hitting 1st and 2nd rows
% Gmax_max (5e-9)         |  Maximum weights
% Gmax_min (0)            |  Minimum weights
% Gmax_weightlist ([])    |  If provided, Gmax will be randomly chosen from this list
%                         |      Under this condition, Gmax_max and Gmax_min will be
%                         |      ignored.
% classic_stdp (1)        |  0/1 use classic stdp
% synapseparams           |  synapse parameters
% intfireparams           |  intfire parameters
% dt (0.0001)             |  time resolution
% trials (100)            |  number of trials
% N (2)                   |  Number of different positions
% R (2)                   |  Number of different latencies
% isi (1)                 |  Interstimulus interval (must be long enough)
% randomness (0)          |  Randomness
% plot_as_we_go (1)       |  0/1 plot to a figure as we go?

% Step 1 - build the model

latency = 0.200;
lag = latency;
Gmax_max = 5e-9;
Gmax_min = 0;
Gmax_weightlist = [];
classic_stdp = 1;
dt = 0.0001;
trials = 100;
synapseparams = {};
intfireparams = {};
N = 2;
R = 2;
randomness = 0;
spikethresholdinterval = [-0.055 -0.055];
isi = 1;

plot_as_we_go = 1;

  % these seem not be used currently
  isi = 1;  % not used that I can tell
  timesteps_per_trial = isi/dt;  % not used presently

vlt.data.assign(varargin{:});

if plot_as_we_go,
	fig = figure;
else,
	fig = [];
end;

di = zeros(1,trials);
r_up = zeros(1,trials);
r_down = zeros(1,trials);
gmaxes = zeros(N*R,trials);
T = zeros(1,trials);

for t=1:trials,
	disp(['Running trial ' int2str(t) ' of ' int2str(trials) '.']);
	% run in upward direction
	
	if isempty(Gmax_weightlist),
		theGmaxes = Gmax_min + rand(1,N*R)*(Gmax_max-Gmax_min);
	else,
		theGmaxes = Gmax_weightlist(randi(length(Gmax_weightlist),1,N*R));
	end;

	theT = spikethresholdinterval(1) + rand*(diff(spikethresholdinterval));

	intfireparams = cat(2,intfireparams, {'V_threshold',theT});

	[dummy,dummy,r_up(t),r_down(t),model_current] = vlt.neuro.models.modelel.modeleldemo.directionselectivityNcelldemo('dt',dt,...
		'latency',latency,'lag',lag,...
		'N',N,'R',R,'randomness',randomness,'isi',isi,...
		'Syn_Gmax_initial',theGmaxes,...
		'plotit',0,'synapseparams',synapseparams,'intfireparams',intfireparams);

	% get the conductances here
	for i=1:N*R,
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
		vlt.neuro.models.modelel.modeleldemo.plotdirectionselectivity4cell(out);
		drawnow; % make sure it draws before we proceed
	end;
end;

out.di = di;
out.r_up = r_up;
out.r_down = r_down;
out.gmaxes = gmaxes;
out.T = T;
