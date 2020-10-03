function [timeseries, timestamps, stimonsetoffsetid] = generate_test_stimulus_responses(varargin)
% GENERATE_TEST_STIMULUS_RESPONSES - generate test stimuli and responses to test analysis code
%
% [TIMESERIES, TIMESTAMPS, STIMONSETOFFSETID] = GENERATE_TEST_STIMULUS_RESPONSE(...)
%
% Generates a timeseries (with timestamps) that exhibits responses to a stimulus (described
% using options below). 
% 
% This function accepts additional arguments as name/value pairs that modify the default behavior:
% Parameter (default value)                  | Description
% -----------------------------------------------------------------------------------------------
% N (10)                                     | Number of stimuli
% control_stim (1)                           | 0/1 Use a control stimulus? Value will just be 0.
% reps (5)                                   | Number of full pseudorandom repetitions
% userandom (1)                              | Display in random order?
% f (1)                                      | Frequency component for stimfunc
% DC (1)                                     | DC component for stimfunc
% AC (1)                                     | Modulated component for stimfunc
% stimfunc('sin(pi*(n-1)/N)*...              | n is the stimulus number from 1..N, t is the stimulus time
%     (DC+AC*sin(2*pi*f*t))')                |    
% ctrlfunc('0*t')                            | Function to evaluate for control stimulus
% randomness(0.3)                            | Additive randomness to all stims (multiplies randn)
% dt (0.001)                                 | Time step (in seconds)
% T (2)                                      | Stimulus duration in seconds
% ISI (2)                                    | Stimulus interstimulus interval
% PoissonProcess (0)                         | Should the function produce a Poisson process? 
%                                            |   If so, TIMESTAMPS will only contain the values when the 
%                                            |   process is triggered and TIMESERIES will be a vector of 1s.
% PoissonProcessMultiplier (10)              | The value that stimfunc should be multiplied by before checking whether
%                                            |   each dt of the Poisson process is a 'hit'.
%
%
% Example:
%   % continuous signal example
%   figure;
%   [timeseries, timestamps, stimonsetoffsetid] = vlt.neuro.stimulus.generate_test_stimulus_responses('reps',10);
%   plot(timestamps,timeseries,'k-');
%   hold on;
%   vlt.neuro.stimulus.plot_stimulus_timeseries(3, stimonsetoffsetid(:,1), stimonsetoffsetid(:,2), 'stimid', stimonsetoffsetid(:,3));
%   axis([timestamps(1) timestamps(end) -2 3+2]);
%   ylabel('Activity');
%   xlabel('Time (s)');
%   R=vlt.neuro.stimulus.stimulus_response_scalar(timeseries, timestamps, stimonsetoffsetid, 'control_stimid', 11, 'freq_response', 1);
%   S=vlt.neuro.stimulus.stimulus_response_stats(R,'control_normalization','subtract');
%   figure;
%   vlt.plot.myerrorbar(1:10,abs(S.mean),S.stderr,S.stderr);  % F1 response is complex, convert to magnitude
%   xlabel('Stim ID');
%   ylabel('F1 response');
%
%   % spike example
%   [timeseries, timestamps, stimonsetoffsetid] = vlt.neuro.stimulus.generate_test_stimulus_responses('PoissonProcess',1,'reps',10);
%   vlt.neuro.spiketrains.spiketimes_plot(timestamps);
%   hold on;
%   vlt.neuro.stimulus.plot_stimulus_timeseries(3, stimonsetoffsetid(:,1), stimonsetoffsetid(:,2), 'stimid', stimonsetoffsetid(:,3));
%   axis([timestamps(1) timestamps(end) -2 3+2]);
%   ylabel('Activity');
%   xlabel('Time (s)');
%   R=vlt.neuro.stimulus.stimulus_response_scalar(timeseries, timestamps, stimonsetoffsetid, 'control_stimid', 11, 'freq_response', 1,'isspike',1);
%   S=vlt.neuro.stimulus.stimulus_response_stats(R,'control_normalization','subtract');
%   figure;
%   vlt.plot.myerrorbar(1:10,abs(S.mean),S.stderr,S.stderr);  % F1 response is complex, convert to magnitude
%   xlabel('Stim ID');
%   ylabel('F1 response');
%
 
N = 10;
control_stim = logical(1);
reps = 5;
userandom = 1;
f = 1;
DC = 1;
AC = 1;
stimfunc = 'sin(pi*(n-1)/N)*(DC+AC*sin(2*pi*f*t))';
ctrlfunc = '0*t';
randomness = 0.3;
dt = 0.001;
T = 2;
ISI = 2;
PoissonProcess = 0;
PoissonProcessMultiplier = 10;

vlt.data.assign(varargin{:});

stimid = vlt.stats.pseudorandomorder(N+double(control_stim),  reps);

T_end = 0;
timestamps = [];
timeseries = [];

stimonsetoffsetid = [];

for i=1:numel(stimid),
	t = [dt:dt:T]';
	t_isi = [dt:dt:ISI]';
	n = stimid(i);

	if n<=N,
		v_here = eval([stimfunc ';']);
	else,
		v_here = eval([ctrlfunc ';']);
	end;

	v_extra = 0*t_isi;

	t_total = [t(:);T+t_isi(:)];

	r_here = randomness * randn(size(t_total));
	v_total = [v_here(:); v_extra(:)] + r_here(:);

	stimonsetoffsetid(i,:) = [T_end T_end+T stimid(i)];

	if PoissonProcess,
		spikes = find(dt*v_total*PoissonProcessMultiplier > rand(size(t_total)));
		timestamps = [timestamps(:); t_total(spikes)+T_end];
		timeseries = [timeseries(:); ones(numel(spikes),1)];
	else,
		timestamps = [timestamps(:); [t;T+t_isi;]+T_end];
		timeseries = [timeseries(:); [v_here(:); v_extra(:)]+r_here(:)];
	end;

	T_end = T_end + T+ISI;
end;


