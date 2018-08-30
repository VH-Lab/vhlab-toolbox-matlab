function [v, fr, stimid] = voltage_firingrate_observations(t, vm, spiketimes, varargin)
% VOLTAGE_FIRINGRATE_OBSERVATIONS - compile a list of voltage measurements and firing rate measurements
%
% [V,FR,STIMID] = VOLTAGE_FIRINGRATE_OBSERVATIONS(T, VM, SPIKETIMES, ...)
%
% Compiles a list of membrane voltage measurements V and firing rate measurements FR given the
% following inputs: 
%    T    is a vector with the time of each sample in VM
%    VM   is a vector of samples of absolute voltage measurement, should have spikes removed
%    SPIKETIMES is a vector of spike times (in units of t, should be seconds)
%
% STIMID is a vector containing the stimulus id of each V,FR pair.
%
% This function can be modified by additional parameter name/value pairs:
% Parameter name (default value)  | Description
% ----------------------------------------------------------------
% binsize (0.030)                 | Sliding bin size (units of t, should be seconds)
% fr_smooth ([])                  | If not empty, the spike times are smoothed
%                                 |    by Gaussian window with this standard
%                                 |    deviation (in units of t).
% stim_onsetoffsetid ([])         | Each row should contain
%                                 |    [stim_onset_time stim_offset_time stimid]
%                                 |    where the times are in units of 't' (seconds)
% dotrialaverage (0)              | If 1, perform a trial-averaging of the spike times
%                                 |    and voltage waveform
% vm_baseline_correct ([])        | If non-empty, perform a baseline correction of the
%                                 |    voltage waveform using this much pre-stimulus 
%                                 |    time (units of t, should be seconds).
%                                 |    (Recommended for sharp electrode recordings, not receommended
%                                 |    for patch recordings.)


%error('untested, still in development');

keyboard

binsize = 0.030; 
fr_smooth = [];
stim_onsetoffsetid = [];
dotrialaverage = 0;
vm_baseline_correct = [];

assign(varargin{:});

vm = vm(:)'; % row vector
t = t(:)'; % row vector

v = [];
fr = [];
stimids = [];

dt = t(2)-t(1);
bin_samples = round(binsize/dt); % size of the bins in terms of samples
if mod(bin_samples,2), bin_samples = bin_samples+1; end; % make sure it is odd

  % Step 1: check validity of inputs before doing work

if isempty(stim_onsetoffsetid),
	if ~dotrialaverage
		error(['No stimulus data was specified, but trial averaging was requested. These inputs are not conguent.']);
	end;

	if ~isempty(vm_baseline_correct),
		stim_onsetoffsetid = [ t(1)+baseline_correct+dt t(end) 1 ];
	else,
		stim_onsetoffsetid = [ t(1) t(end) 1 ];
	end
end

  % Step 2: prepare the firing rate information, smoothing with Gaussian if needed

spikes = spiketimes2bins(spiketimes,t);
spikes = spikes(:)'; % ensure row vector
gaussian_samples = round(fr_smooth/dt);  % size of gaussian blur sigma, in samples rather than in units of time
if ~isempty(fr_smooth),
	spikes = imgaussfilt(spikes/dt,gaussian_samples);
else,
	spikes = conv(spikes/dt,ones(1,bin_samples)/bin_samples,'same'); % boxcar filter, average the spikes in the bin
end

  % Step 3: correct baseline if needed

if ~isempty(vm_baseline_correct),
	vm_baseline_correct_samples = max([1 round(vm_baseline_correct/dt)]); % make sure at least one sample

	for i=1:size(stim_onsetoffsetid,1), % for each stimulus
		sample_start = point2samplelabel(stim_onsetoffsetid(i,1),dt,t(1));
		sample_stop = point2samplelabel(stim_onsetoffsetid(i,2),dt,t(1));

		t_baseline = sample_start - vm_baseline_correct_samples;
		baseline = mean(vm(t_baseline:sample_start-1));
		vm(sample_start:sample_stop) = vm(sample_start:sample_stop) - baseline;
	end
end

  % Step 4: smooth the data


 % because we are averaging and not doing something more complicated, probably faster just to filter with boxcar and then
 % grab samples we need rather than calling SLIDINGWINDOWFUNC; these data sets could get large

vm_filtered = conv(vm,ones(1,bin_samples)/bin_samples,'same');

  % Step 5: calculate trial-averaged signals

stimids = unique(stim_onsetoffsetid(:,3));

for s = 1:numel(stimids),
	v_trials = [];
	f_trials = [];
	do = find(stim_onsetoffsetid(:,3)==stimids(s));
	for o=1:numel(do),
		sample_start = point2samplelabel(stim_onsetoffsetid(i,1),dt,t(1));
		sample_stop = point2samplelabel(stim_onsetoffsetid(i,2),dt,t(1));
		v_here = vm(sample_start+(bin_samples-1)/2:bin_samples:sample_stop-(bin_samples-1)/2);
		fr_here = spikes(sample_start+(bin_samples-1)/2:bin_samples:sample_stop-(bin_samples-1)/2);

		if dotrialaverage,
			v_trials(end+1,:) = v_here;
			fr_trials(end+1,:) = f_here;
		else,
			% add the entries now
			v = cat(2,v,v_here(:));
			fr = cat(2,fr,fr_here(:));
			stimid = cat(2,stimid,stimids(s)*ones(numel(v_here),1));
		end
	end
	if dotrialaverage,
		v_here = mean(v_trials,1);
		fr_here = mean(fr_trials,1);
		v = cat(2,v,v_here(:));
		fr = cat(2,fr,fr_here(:));
		stimid = cat(2,stimid,stimids(s)*ones(numel(v_here),1));
	end
end


