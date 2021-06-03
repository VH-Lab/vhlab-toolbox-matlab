# vlt.neuro.reverse_correlation.spike_triggered_average_stepfunc

```
  vlt.neuro.reverse_correlation.spike_triggered_average_stepfunc - Performs STA between spike times and step function stimulus
 
  AVG_STIM = vlt.neuro.reverse_correlation.spike_triggered_average_stepfunc(SPIKETIMES, STIM_OFFSETS, STIMTIMES, STIM)
 
    This function calculates the spike triggered average (STA), AKA the stimulus that was
    present (on average) at the time of a spike) analysis between a series of spike times
    and a step function stimulus.
 
    AVG_STIM is the stimulus that was present (on average) at the time of a spike
 
        SPIKETIMES is the list of spike times
        STIM_OFFSETS is a list of times relative to the spike at which to 
                   compute the stimulus.
 	The stimulus is assumed to be a step function that assumes different
        values at each step.  STIMTIMES is a list of the time of each step,
        and STIM is a matrix of row vectors, where each row corresponds to 
        one stimulus variable.
 
    See Dayan and Abbott (2005), Chapters 1-2
   
   See also:  vlt.math.stepfunc, vlt.neuro.reverse_correlation.demos.DirRFModel_example3

```
