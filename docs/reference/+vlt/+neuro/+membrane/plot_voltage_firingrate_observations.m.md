# vlt.neuro.membrane.plot_voltage_firingrate_observations

```
  PLOT_VOLTAGE_FIRINGRATE_OBSERVATIONS - plot a list of voltage-firing rate observations against real data
 
  [H,HTEXT] = vlt.neuro.membrane.plot_voltage_firingrate_observations(V, FR, STIMID, TIMEPOINTS, VM_BASELINESUBTRACTED, T, VM, SPIKETIMES, ...)
 
  Given inputs:
            V - voltage observations returned from vlt.neuro.membrane.voltage_firingrate_observations
           FR - firing rate observations returned from vlt.neuro.membrane.voltage_firingrate_observations
       STIMID - stimulus IDs
   TIMEPOINTS - Timepoints that are averaged together
            T - time points of raw data
           VM - voltage measurements of raw data
   SPIKETIMES - time of spiking events
  
  This function can be modified by additional parameter name/value pairs:
  Parameter name (default value)  | Description
  ----------------------------------------------------------------
  binsize (0.030)                 | Sliding bin size (units of t, should be seconds)
  fr_smooth ([])                  | If not empty, the spike times are smoothed
                                  |    by Gaussian window with this standard
                                  |    deviation (in units of t).
  stim_onsetoffsetid ([])         | Each row should contain
                                  |    [stim_onset_time stim_offset_time stimid]
                                  |    where the times are in units of 't' (seconds)
  dotrialaverage (0)              | If 1, perform a trial-averaging of the spike times
                                  |    and voltage waveform
 
  See also: vlt.neuro.membrane.voltage_firingrate_observations

```
