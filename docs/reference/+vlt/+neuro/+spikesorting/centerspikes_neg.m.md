# vlt.neuro.spikesorting.centerspikes_neg

  CENTERSPIKES_NEG Center negative-going spike waveforms based on minimum
   [CENTEREDSPIKES, SHIFTS] = vlt.neuro.spikesorting.centerspikes_neg(SPIKESHAPES, CENTER_RANGE)
 
   Inputs: SPIKESHAPES: an NxMxD vector where N is the number of spikes, M is the number of
            samples that comprise each spike waveform, and D is dimensions (i.e., number of
            channels).
           CENTER_RANGE: the range, in samples, around the center sample that the program
            should search to identify the center (e.g., 10)
   Outputs: 
           CENTEREDSPIKES: the re-centered spikes; if the center of a spike has shifted, then
            the edges will be zero padded.
           SHIFTS: the number of samples the spike has been shifted. Negative means the centered spike
            was shifted to the left, positive is shifted to the right.
