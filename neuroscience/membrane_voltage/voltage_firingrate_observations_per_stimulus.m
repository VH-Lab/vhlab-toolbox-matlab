function [mean_v, mean_fr, mean_stimid] = voltage_firingrate_observations_per_stimulus(voltage_observations, firingrate_observations, timepoints, stimid, stim_onsetoffsetid)

% stim_onsetoffsetid ([])         | Each row should contain
%                                 |    [stim_onset_time stim_offset_time stimid]
%                                 |    where the times are in units of 't' (seconds)


 % assume more than one timepoint per stimulus

mean_v = [];
mean_fr = [];
mean_stimid = [];

inbounds = find(stim_onsetoffsetid(:,1)>=timepoints(1) & stim_onsetoffsetid(:,2)<=timepoints(end));
stim_onsetoffsetid = stim_onsetoffsetid(inbounds,:);

for i=1:size(stim_onsetoffsetid),
	indexes = find( (timepoints >= stim_onsetoffsetid(i,1)) & (timepoints <= stim_onsetoffsetid(i,2)) );
	mean_v(i) = mean(voltage_observations(indexes));
	mean_fr(i) = mean(firingrate_observations(indexes));
	mean_stimid(i) = stim_onsetoffsetid(i);
end;


