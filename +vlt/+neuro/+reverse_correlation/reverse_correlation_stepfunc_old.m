function avgstim = reverse_correlation_stepfunc(spiketimes, kerneltimes, stimtimes, stim)

% vlt.neuro.reverse_correlation.reverse_correlation_stepfunc - Performs RC between spike times and step function stimulus
%
% AVG_STIM = vlt.neuro.reverse_correlation.reverse_correlation_stepfunc(SPIKETIMES, STIM_OFFSETS, STIMTIMES, STIM)
%
%   This function performs reverse correlation (AKA the spike triggered average, STA,
%   AKA the stimulus that was present (on average) at the time of a spike)
%   analysis between a series of spike times and a step function stimulus.
%
%   AVG_STIM is the stimulus that was present (on average) at the time of a spike
%
%       SPIKETIMES is the list of spike times
%       STIM_OFFSETS is a list of times relative to the spike at which to 
%                  compute the stimulus.
%	The stimulus is assumed to be a step function that assumes different
%       values at each step.  STIMTIMES is a list of the time of each step,
%       and STIM is a matrix of row vectors, where each row corresponds to 
%       one stimulus variable.
%
%   See Dayan and Abbott (2005), Chapters 1-2
%  
%  See also:  vlt.math.stepfunc, vlt.neuro.reverse_correlation.demos.DirRFModel_example3

   % KERNELTIMES corresponds to STIM_OFFSETS in the docs

avgstim = zeros(length(kerneltimes),size(stim,2));

for s=1:length(spiketimes),
	avgstim = avgstim + vlt.math.stepfunc(stimtimes,stim',spiketimes(s)-kerneltimes,0)'/length(spiketimes);
end;

return;

















avgs = zeros(length(kerneltimes), size(stim,2), length(spiketimes));

for s=1:length(spiketimes),
	mydata = stepunc(stimtimes,stim',spiketimes(s)-kerneltimes,0);
	avgs(:,:,s) = vlt.math.stepfunc(stimtimes,stim',spiketimes(s)-kerneltimes,0)';
end;

avgstim = mean(avgs,3);

