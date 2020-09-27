function [kink_vm, max_dvdt, kink_index, slope_criterion] = spikekink(spike_wave, t_vec, spike_indexes, varargin)
% SPIKEKINK - find the "kink" inflection point in spike waveforms, and maximum dv/dt after Azouz and Gray 1999
%
% [KINK_VM, MAX_DVDT, KINK_INDEX_] = vlt.neuro.membrane.spikekink(SPIKE_TRACE, T, SPIKE_INDEXES, ...)
%
% Inputs:        
% SPIKE_WAVE      | 1D vector containing values for voltage at every
%                 |    timestep in spike_wave (units V)
% T_VEC           | 1D vector containing timestamps in seconds
% SPIKE_INDEXES   | Sample index values of approximate spike peaks in SPIKE_TRACE
%                 | and can be in either row or column vector form
%
% Calculates the "kink" in spike waveforms where spike begins to take off.
% See Azouz and Gray, J. Neurosci 1999.
%
% SPIKE_LOCATIONS that are greater than 
%
% Outputs:
% KINK_VM         | Vector of voltage at each spike kink
% MAX_DVDT        | Vector of maximum DV/DT for each spike (volts/sec)
% KINK_INDEX      | Vector of times of each spike kink
% 
% This function also takes additional parameters in the form of name/value
% pairs.
%
% Parameter (default)     | Description
% ---------------------------------------------------------------
% slope_criterion (0.033) | Fraction of peak dV/dt, calibrated by visual
%                         |    inspection to match threshold
% search_interval (0.004) | How much before each spike_location to begin
%                         |    the search for the kink (in seconds)
%
% Jason Osik 2016-2017, slight mods by SDV, DPL
%

slope_criterion = 0.033;
search_interval  = 0.004;

vlt.data.assign(varargin{:});

%*******Assess biophysical spike threshold using Azouz & Gray, 1999
    %*******methods****************************************************
    %******************************************************************

sample_interval = t_vec(2)-t_vec(1);% calc sampling interval by subtracting diff in time points

  % create outputs
kink_index = [];
max_dvdt = [];

%search_samples = max(1,ceil(abs(search_interval)/sample_interval)); %calculates number of samples to search backwards from peak 

for q=1:length(spike_indexes),
	% find the max slope and index value where the kink occurs

	search_pad = 3:spike_indexes(q)-1;
        %search_pad = ceil((spike_indexes(q)-1)*.5):spike_indexes(q)-1; %searches backwards from peak to 0
	vt_slope = gradient(spike_wave,sample_interval); %make index of voltage changes between each timepoint
        [max_vt_slope,peak_ind] = max(vt_slope(search_pad));
	if peak_ind == 1,
		vt_slope_fd3 = spike_wave(peak_ind);
	end
	if peak_ind > 1,
		vt_slope_fd3 = ((-1*spike_wave(peak_ind-1))+spike_wave(peak_ind)+spike_wave(peak_ind+1))/(2*sample_interval);
	end
	max_dvdt(end+1,1) = max_vt_slope; %adds new max slope value to index
        
	% now look for the best match for the kink, but only search from peak_slope backward
	search_pad(peak_ind+1:end) = [];
	% find point closest to target slope value
	[~,th_ind] = min(abs(   (slope_criterion*max_vt_slope)-vt_slope(search_pad,1)    ));
	kink_index(end+1,1) = search_pad(1,1)+th_ind-1;
end

kink_vm = spike_wave(kink_index);

