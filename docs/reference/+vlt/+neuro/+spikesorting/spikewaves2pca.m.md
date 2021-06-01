# vlt.neuro.spikesorting.spikewaves2pca

  SPIKEWAVES2PCA - Compute first N principle components of spike waveforms
 
   FEATURES = vlt.neuro.spikesorting.spikewaves2pca(WAVES, N, [RANGE])
 
   Creates a set of "features" of the spike waveform WAVES by
   calculating the values of the first N principle components.
 
   Inputs:
   WAVES: A NumSamples x NumChannels x NumSpikes list of spike
    waveforms. 
   N:  the number of principle components to include
   Optional input:
   RANGE: A 2 element vector with the START and STOP range to examine
 
   Outputs:
   FEATURES:   An N x NumSpikes list of features.
