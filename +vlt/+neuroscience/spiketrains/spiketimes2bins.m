function spike_counts = spiketimes2bins(spiketimes, times)
% SPIKETIMES2BINS - Convert a list of spike times to discrete time bins
%
%   SPIKE_COUNTS = SPIKETIMES2BINS(SPIKETIMES, TIMES)
%
%   Takes a list of spike times (in units of TIMES) and calculates the
%   number of spikes that fall within time bins TIMES(i) - TIMES(i+1).
%   If a spike occurred at exactly time TIMES(i) then it is included in
%   bin i.
%
%   Note that bins can contain more than one spike.
%
%   Example: Generate a list of bins in spike times, get the spike times,
%            and then convert it back to bins.
%
%     dt = 0.001;
%     T = 0:dt:10; % 10 seconds
%     R = 5*rectify(sin(2*pi*3*T));
%     S = (rand(size(T))<R*dt); %generate spikes with probability R*dt
%     spike_indexes = find(S); % find which bins have spikes
%     spiketimes = T(spike_indexes);  % get the time of those bins
%
%     S2 = spiketimes2bins(spiketimes,T); % convert back
%
%     all(S==S2)    % are these vectors equal? Yes!
 
spike_counts = histc(spiketimes,[-Inf;times(:)]);
spike_counts = spike_counts(2:end);

if isempty(spike_counts), 
	spike_counts = zeros(size(times));
end;

 % be nice and convert back to the same shape as the user provided 
if size(times,1)>size(times,2), spike_counts = spike_counts'; end; 

