# vlt.neuro.spiketrains.spiketrain_timingcorrelated

  SPIKETRAIN_TIMINGCORRELATED - Make spike train that is correlated in spike timing with an input spike train
 
    [CORRELATED_TRAIN, CORR] = vlt.neuro.spiketrains.spiketrain_timingcorrelated(INPUT_TRAIN, C)
 
   Creates a spike train that is correlated with the spike train INPUT_TRAIN.
   INPUT_TRAIN should be a list of spike times in seconds.
   C indicates how correlated the spike trains should be in terms of 1ms spike timing,
   from 0 (all spikes different) to 1 (all spikes the same).  CORRELATED_TRAIN will have the
   same number of spikes as INPUT_TRAIN.
   
   CORR is the actual correlation that was achieved.  This may differ slightly from the requested
   correlation if the fraction correlation requested times the number of spikes is not an integer.
