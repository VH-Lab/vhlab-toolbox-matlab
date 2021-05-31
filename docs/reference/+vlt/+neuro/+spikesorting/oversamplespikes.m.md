# vlt.neuro.spikesorting.oversamplespikes

  OVERSAMPLESPIKES - Oversample spike waveforms using spline interpolation
 
   [SPIKESHAPESUP,TUP] = vlt.neuro.spikesorting.oversamplespikes(SPIKESHAPES, UPSAMPLEFACTOR, [T])
 
   Inputs: SPIKESHAPES: an NxMxD matrix of spikes shapes; N is the number of
              spikes, M is the number of samples per spike, and D is the number
              of dimensions (e.g., D=1 for a single channel recording).
           UPSAMPLEFACTOR: the number of times to vlt.signal.oversample (e.g., 5)
           T: (optional), the relative time values within each spike sample
              (shoudl be length M)
 
   Outputs: SPIKESHAPESUP:  An NxM*UPSCALEFACTOR*D matrix with the upsampled
           spikeshapes. N is the number of spikes, M*UPSCALEFACTOR is the number
           of samples for each spike, and D is the number of dimensions. N,M, and D 
           are unchanged from the input SPIKESHAPES.
             TUP: If T is given, TUP is the upscaled time values for each spike.
