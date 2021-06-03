# vlt.neuro.spiketrains.spiketimes2bins

```
  SPIKETIMES2BINS - Convert a list of spike times to discrete time bins
 
    SPIKE_COUNTS = vlt.neuro.spiketrains.spiketimes2bins(SPIKETIMES, TIMES)
 
    Takes a list of spike times (in units of TIMES) and calculates the
    number of spikes that fall within time bins TIMES(i) - TIMES(i+1).
    If a spike occurred at exactly time TIMES(i) then it is included in
    bin i.
 
    Note that bins can contain more than one spike.
 
    Example: Generate a list of bins in spike times, get the spike times,
             and then convert it back to bins.
 
      dt = 0.001;
      T = 0:dt:10; % 10 seconds
      R = 5*vlt.math.rectify(sin(2*pi*3*T));
      S = (rand(size(T))<R*dt); %generate spikes with probability R*dt
      spike_indexes = find(S); % find which bins have spikes
      spiketimes = T(spike_indexes);  % get the time of those bins
 
      S2 = vlt.neuro.spiketrains.spiketimes2bins(spiketimes,T); % convert back
 
      all(S==S2)    % are these vectors equal? Yes!

```
