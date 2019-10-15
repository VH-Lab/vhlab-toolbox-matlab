function [mean_v, mean_fr, mean_stimid] = voltage_firingrate_observations_per_stimulus(voltage_observations, firingrate_observations, timepoints, stim_onsetoffsetid, varargin)
% VOLTAGE_FIRINGRATE_OBSERVATIONS - calculate voltage and firing rate observations for a stimulus (mean, mean at a frequency)
%
% [MEAN_V, MEAN_FR, STIMID] = VOLTAGE_FIRINGRATE_OBSERVATIONS_PER_STIMULUS(VM, SPIKERATE, TIME, STIM_ONSETOFFSETID, ...)
%
% Calculates the mean response across each stimulus presentation described in STIM_ONSETOFFSETID for both voltage (VM)
% and SPIKERATE. SPIKERATE should be the firing rate at each time point T, VM is the voltage at each time point T.
% STIM_ONSETOFFSETID should have 1 row per stimulus and each row should contain [stim_onset_time stim_offset_time stimid]
% where the times are in units of 'TIME' (such as seconds).
%
% This function also takes NAME/VALUE parameter pairs that modify its behavior.
% Parameter (default value)        | Description
% -----------------------------------------------------------------------------
% PRETIME ([])                     | If not empty, the voltage PRETIME seconds before each
%                                  |    stimulus is subtracted from the response. 
% F1 ([])                          | If not empty, then the responses is taken to be the
%                                  |    magnitude of the fourier transform at the frequency F1.
%


pretime = [];
f1 = [];

assign(varargin{:});

if ~isempty(f1),
	if f1==0,
		f1 = []; % just use mean method
	end;
end;

 % assume more than one timepoint per stimulus

mean_v = [];
mean_fr = [];
mean_stimid = [];

inbounds = find(stim_onsetoffsetid(:,1)>=timepoints(1) & stim_onsetoffsetid(:,2)<=timepoints(end));
stim_onsetoffsetid = stim_onsetoffsetid(inbounds,:);

for i=1:size(stim_onsetoffsetid,1),
	indexes = find( (timepoints >= stim_onsetoffsetid(i,1)) & (timepoints <= stim_onsetoffsetid(i,2)) );
	vo = voltage_observations(indexes);
	if ~isempty(pretime),
		preindexes = find( (timepoints>= stim_onsetoffsetid(i,1)-pretime) & timepoints<=stim_onsetoffsetid(i,1) );
		vo = vo - mean(voltage_observations(preindexes));
	end;
	if isempty(f1),
		mean_v(i) = mean(vo);
		mean_fr(i) = mean(firingrate_observations(indexes));
		mean_stimid(i) = stim_onsetoffsetid(i,3);
	else,
		si = timepoints(2)-timepoints(1); % sample interval
		mean_v(i) = abs(fouriercoeffs_tf2(vo, f1, 1/si));
		mean_fr(i) = abs(fouriercoeffs_tf2(firingrate_observations(indexes), f1, 1/si));
		mean_stimid(i) = stim_onsetoffsetid(i,3);
	end;
end;


