function [R,C,Rmean,Cmean] = sparse_noise_responses(spiketimes, stim_times, stim_position_index, t0, t1)
% vlt.neuro.reverse_correlation.sparse_noise_responses - calculate responses to sparse noise stimulation
%
% [R,C,Rmean,Cmean] = vlt.neuro.reverse_correlation.sparse_noise_responses(spike_times, stim_times, ...
%          stim_position_index, t0, t1)
%
% Calculates the response rate R and spike count C at each position. 
%
% Inputs: 
%    spike_times          - the time of each spike (unit: seconds)
%    stim_times           - the time of each stimulus frame (vector: 1 entry per frame; unit: seconds)
%    stim_position_index  - The stimulus position index that was stimulated for each frame
%                             (vector: 1 entry per frame)
%    t0                   - the time relative to each frame to start counting spikes (scalar, unit: seconds)
%    t1                   - the time relative to each from to stop counting spikes (scalar, unit: seconds)
%
% Outputs:
%    R                    - spike rates (spike count divided by (t1-t0)) for each position
%                             (cell: 1 vector per stim_position_index value; each
%                             vector holds the observation for each stimulus presentation)
%    C                    - spike counts in the interval [t0,t1] relative to each frame for each position
%                             (cell: 1 vector per stim_position_index value; each
%                             vector holds the observation for each stimulus presentation)
%    Rmean                - A vector of the mean response across trials (vector: 1 entry per unique
%                             stim_position_index value)
%    Cmean                - A vector of the mean response across trials (vector: 1 entry per unique
%                             stim_position_index)
%
% 

stim_position_index_values = unique(stim_position_index);

R = {};
C = {};
Rmean = [];
Cmean = [];

for i=1:numel(stim_position_index_values),

	value_here = stim_position_index_values(i);

	stim_indexes = find(stim_position_index==value_here);

	R{i} = [];
	C{i} = [];

	for j=1:numel(stim_indexes),
		thisstimtime = stim_times(stim_indexes(j));
		C{i}(j) = numel(find(spiketimes>= thisstimtime+t0 & spiketimes<=thisstimtime+t1));
		R{i}(j) = C{i}(j)/(t1-t0);
	end;
	Rmean(i) = mean(R{i});
	Cmean(i) = mean(C{i});
end;


