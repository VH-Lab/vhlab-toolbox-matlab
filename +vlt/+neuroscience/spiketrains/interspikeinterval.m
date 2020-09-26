function [isi] = interspikeinterval(spiketimes, bins)
% INTERSPIKEINTERVAL - Calculate interspike interval distribution for spiketrain
%
%  ISI = INTERSPIKEINTERVAL(SPIKETIMES, BINS)
%
%  Calculates the distribution of interspike intervals for the list of
%  spikes SPIKETIMES. SPIKETIMES should be in the same time units as BINS.
%
%  If the function is called without a BINS argument:
%  ISI = INTERSPIKEINTERVAL(SPIKETIMES)
%     then BINS is taken to be [0:0.001:0.100]
%     (that is, 1ms bins from 0 to 0.100 seconds)
%    
%  Example:
%    % Poisson spike train at 3Hz
%    dt = 0.001;
%    t = 0:dt:100;
%    rate = 3; 
%    spikebins = rand(size(t))<rate*dt; % 0's and 1's
%    spikebin_indexes = find(spikebins); % find locations of spikes
%    spiketimes = t(spikebin_indexes); % get the corresponding time values
%    bins = 0:0.001:0.1;
%    ISI = interspikeinterval(spiketimes,bins);
%    % plot as a fraction of total
%    bar(bins+0.001/2,ISI/sum(ISI));
%

if nargin<2,
	bins = 0:0.001:0.1;
end;

intervals = diff(spiketimes);
if isempty(intervals),
	isi = zeros(size(bins));
else,
	isi = histc(intervals,bins);
end;
