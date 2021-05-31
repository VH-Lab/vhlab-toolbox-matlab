# vlt.neuro.membrane.spikewavetrimmer

  SPIKEWAVETRIMMER - remove the zero padding from spikewave and yield the time preceding spike peaks
  [SPIKEWAVE_VTRIM] = vlt.neuro.membrane.spikewavetrimmer(SPIKEWAVE, SPIKEPEAK_LOC)
 
  Inputs:        
  SPIKEWAVE          | 1D vector containing values for voltage at every
                     | timestep in spike_trace (units V)
  SPIKEPEAK_LOC      | Position of spike peak location
 
  Outputs:
  SPIKEWAVE_VTRIM    | A trimmed vector of spikewave voltages with all
                     |  0 padding removed and replaced with the leading (or
                     |  trailing) non-zero data points at the beginning and
                     |  end of the wave, respectively.
