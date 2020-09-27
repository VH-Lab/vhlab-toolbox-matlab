function [opt_threshold, detector, conv_scale, stats]=minidetectionsimulation(varargin)
% MINIDETECTIONSIMULATION
%
%  [OPT_THRESHOLD, DETECTOR, CONV_SCALE, STATS] = vlt.neuroscience.minis.minidetectionsimulation
%
%  Solves, through simulation, the optimum threshold for detecting miniature 
%  excitatory or inhibitory post-synaptic potentials or currents.
%
%  Minis are assumed to arrive on a background of pure gaussian noise with
%  a standard deviation of 1. (One can divide the threshold by the actual noise 
%  encountered in one's own data to obtain the equivalent value for real data.)
%
%  OPT_THRESHOLD - the threshold that produced the fewest overall errors of
%  detection, weighing false positives and false negatives equally (because both
%  errors have the same impact on average mini frequency and amplitude).
%
%  DETECTOR - The filter used for detection. It assumes a positively-going wave
%  (simply multiply this by -1 to switch sign).
%
%  CONV_SCALE - The amount by which the convolution of the data and the DETECTOR
%  should be scaled to reproduce the detection values used in this simulation
%  (depends on sampling rate and number of samples).
%
%  STATS - a structure with error rates for different values of threshold.
%
%  The behavior of the function can be altered by passing name/value pairs:
%
%  Parameter (default)          | Description
%  ------------------------------------------------------------------------------
%  DT (0.001)                   | The time step between adjacent samples
%  Tau_Onset  (0.0025)          | The time of the synaptic potential onset (in seconds)
%  Tau_Offset (0.0250)          | The time of the synaptic potential offset (in seconds)
%  Simulation_Duration (100)    | The simulation duration (seconds)
%  expected_rate_of_events (10) | The expected rate of real events (Hz)
%  noise_fraction (0.1)         | The fraction that Tau_Offset and Tau_Onset should be
%                               |   altered by noise in the simulation
%  threshold_steps (50)         | Threshold steps to examine
%  refractory_period (0.020)    | Refractory period (time between events can be no shorter
%                               |   than this, in seconds)
%  plotit (0)                   | Plot the threshold vs. errors curve
%

dt = 0.001;
Tau_Onset = [0.0025];
Tau_Offset = [0.0250];
Simulation_Duration = 100;
expected_rate_of_events = 10;
noise_fraction = 0.1;
threshold_steps = 50;
refractory_period = 0.020;
plotit = 0;

vlt.data.assign(varargin{:});


[mt,t,params] = vlt.neuroscience.minis.minitemplates('Max_Amplitude',3,'Amplitude_Steps',1,'Tau_Onsets',Tau_Onset,'Tau_Offsets',Tau_Offset,'dt',dt);

T = Simulation_Duration; % duration of simulation

num_samples = T/dt + 1;

Tvals = 0:dt:T;
myevent_times = 1:99;
myevent_samples = 1+(myevent_times)/dt;
events = zeros(num_samples,1);
events(myevent_samples) = 1;


D = randn(num_samples,1);
events_here = events;
for j=1:length(myevent_samples),
	noisytemplate=vlt.neuroscience.minis.minitemplates('dt',dt,'Amplitude_Steps',1,...
			'Max_Amplitude',params.Amplitude*1.5*rand,...
			'Tau_Onsets',params.Tau_Onset*(1+noise_fraction*randn),...
			'Tau_Offsets',params.Tau_Offset*(1+noise_fraction*randn));

	events_here(myevent_samples(j):myevent_samples(j)+length(noisytemplate)-1) = noisytemplate;
end;

D_here = D + events_here;

detector = [mt(1,end:-1:1) zeros(1,size(mt,2)-1)];
conv_scale = dt / size(mt,2);
	% divide by time step and number of samples of template so
        % sampling rate doesn't influence computation
        % (will influence accuracy because more samples are always better for detection)

matched = conv(D_here,detector,'same')*conv_scale; % matched filter is inverted

Thresholds = linspace(0,max(matched),threshold_steps);

stats = vlt.data.emptystruct('threshold','false_positive_rate','true_positive','false_negative','total_error_rate');

for th=1:length(Thresholds),

	[dummy,dummy2,z]=vlt.signal.threshold_crossings_epochs(matched,Thresholds(th));
	out_times = vlt.signal.refractory(Tvals(z),refractory_period);
	fp = [];
	found = [];
	for d=1:length(out_times),
		index = find(abs(myevent_times-out_times(d))<0.005);
		if length(index)>1,
			disp(['that is weird, we found more than 1 match.']);
			keyboard;
		elseif ~isempty(index),
			found(index) = 1;
		else,
			fp(end+1) = d; % we had a match but should not have
		end;
	end;
	stats(end+1) = struct('threshold',Thresholds(th),'false_positive_rate',length(fp)/T,...
		'true_positive',sum(found)/length(found),'false_negative',(length(found)-sum(found))/length(found),...
		'total_error_rate',length(fp)/T + expected_rate_of_events*(length(found)-sum(found))/length(found));
end;

[dummy,index] = min([stats.total_error_rate]);
opt_threshold = stats(index).threshold;

if plotit,
	figure;
	plot([stats.threshold],[stats.total_error_rate]);
	xlabel('Threshold');
	ylabel('Expected error rate / second');
	box off;
end;
