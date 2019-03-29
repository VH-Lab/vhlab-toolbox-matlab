function [h,htext] = plot_voltage_firingrate_observations(v, fr, stimid, timepoints, vm_baselinesubtracted, t, vm, varargin)
% PLOT_VOLTAGE_FIRINGRATE_OBSERVATIONS - plot a list of voltage-firing rate observations against real data
%
% [H,HTEXT] = PLOT_VOLTAGE_FIRINGRATE_OBSERVATIONS(V, FR, STIMID, TIMEPOINTS, VM_BASELINESUBTRACTED, T, VM, SPIKETIMES, ...)
%
% Given inputs:
%           V - voltage observations returned from VOLTAGE_FIRINGRATE_OBSERVATIONS
%          FR - firing rate observations returned from VOLTAGE_FIRINGRATE_OBSERVATIONS
%      STIMID - stimulus IDs
%  TIMEPOINTS - Timepoints that are averaged together
%           T - time points of raw data
%          VM - voltage measurements of raw data
%  SPIKETIMES - time of spiking events
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
%
% See also: VOLTAGE_FIRINGRATE_OBSERVATIONS


binsize = 0.030; 
fr_smooth = [];
stim_onsetoffsetid = [];
dotrialaverage = 0;

assign(varargin{:});

vm = vm(:)'; % row vector
t =   t(:)'; % row vector
dt = t(2)-t(1);
bin_samples = round(binsize/dt); % size of the bins in terms of samples
if ~mod(bin_samples,2), bin_samples = bin_samples+1; end; % make sure it is odd
bin_time = bin_samples * dt;


h = [];

figure;

h(end+1) = plot(v(:),fr(:),'o');
xlabel('Vm - baseline')
ylabel('Firing rate');
hold on
box off


[sortedtimepoints, inds] = sort(timepoints(:));

figure

spike_counts = round(fr * (bin_time));

h(end+1) = plot(timepoints(inds), v(inds),'b-');
hold on

xlocs_spikes = [];
xlocs_nospikes = timepoints(inds( find(spike_counts(inds)<1)  ));;
ylocs_spikes = [];
ylocs_nospikes = v(inds( find(spike_counts(inds)<1)  ));;

maxsp = max(spike_counts);

for i=1:maxsp,
	xlocs{i} = linspace(-binsize/8,binsize/8,i+2);
	xlocs{i} = xlocs{i}(2:end-1);
	xlocs{i} = xlocs{i}(:); % column
	ylocs{i} = ones(i,1);
end;

for i=1:numel(inds),
	if 0&(mod(i,1000)==0),
		disp(['Finished ' int2str(i) ' of ' int2str(numel(inds)) '...']);
	end
	if spike_counts(inds(i))==0,
	else,
		xlocs_spikes = cat(1,xlocs_spikes(:),timepoints(inds(i))+xlocs{spike_counts(inds(i))});
		ylocs_spikes = cat(1,ylocs_spikes(:),v(inds(i))*ylocs{spike_counts(inds(i))});
	end
end

h_here = plot(xlocs_nospikes, ylocs_nospikes, ['ro'] );
h = cat(1,h(:),h_here(:));
h_here = plot(xlocs_spikes, ylocs_spikes, ['rx'] );
h = cat(1,h(:),h_here(:));

ylabel('Voltage (mV)');
xlabel('Time (s)');
title(['''o'' means no spikes in that bin, ''x'' means spikes in that bin']);
[newh,newhtext]=plot_stimulus_timeseries(mean(v(inds)),stim_onsetoffsetid(:,1),...
		stim_onsetoffsetid(:,2),'stimid',stim_onsetoffsetid(:,3));

h(end+1) = plot(t,vm_baselinesubtracted,'g-');

box off

h = cat(1,h(:),newh(:));
htext = newhtext;

