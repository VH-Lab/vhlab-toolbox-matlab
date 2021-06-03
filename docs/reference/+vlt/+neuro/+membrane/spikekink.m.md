# vlt.neuro.membrane.spikekink

```
  SPIKEKINK - find the "kink" inflection point in spike waveforms, and maximum dv/dt after Azouz and Gray 1999
 
  [KINK_VM, MAX_DVDT, KINK_INDEX_] = vlt.neuro.membrane.spikekink(SPIKE_TRACE, T, SPIKE_INDEXES, ...)
 
  Inputs:        
  SPIKE_WAVE      | 1D vector containing values for voltage at every
                  |    timestep in spike_wave (units V)
  T_VEC           | 1D vector containing timestamps in seconds
  SPIKE_INDEXES   | Sample index values of approximate spike peaks in SPIKE_TRACE
                  | and can be in either row or column vector form
 
  Calculates the "kink" in spike waveforms where spike begins to take off.
  See Azouz and Gray, J. Neurosci 1999.
 
  SPIKE_LOCATIONS that are greater than 
 
  Outputs:
  KINK_VM         | Vector of voltage at each spike kink
  MAX_DVDT        | Vector of maximum DV/DT for each spike (volts/sec)
  KINK_INDEX      | Vector of times of each spike kink
  
  This function also takes additional parameters in the form of name/value
  pairs.
 
  Parameter (default)     | Description
  ---------------------------------------------------------------
  slope_criterion (0.033) | Fraction of peak dV/dt, calibrated by visual
                          |    inspection to match threshold
  search_interval (0.004) | How much before each spike_location to begin
                          |    the search for the kink (in seconds)
 
  Jason Osik 2016-2017, slight mods by SDV, DPL

```
