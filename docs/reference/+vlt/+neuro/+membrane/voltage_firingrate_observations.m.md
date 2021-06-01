# vlt.neuro.membrane.voltage_firingrate_observations

  VOLTAGE_FIRINGRATE_OBSERVATIONS - compile a list of voltage measurements and firing rate measurements
 
  [V,FR,STIMID,TIMEPOINTS,VM_BASELINESUBECTRACTED,EXACTBINTIME, SUBTRACTED_VALUE] = ...
           vlt.neuro.membrane.voltage_firingrate_observations(T, VM, SPIKETIMES, ...)
 
  Compiles a list of membrane voltage measurements V and firing rate measurements FR given the
  following inputs: 
     T    is a vector with the time of each sample in VM
     VM   is a vector of samples of absolute voltage measurement, should have spikes removed
     SPIKETIMES is a vector of spike times (in units of t, should be seconds)
 
  V and FR are paired, binned observations of voltage and firing rate,
  and TIMEPOINTS are the mid-point values of the bins in time.
  STIMID is a vector containing the stimulus id of each V,FR pair.
  VM_BASELINESUBTRACTED is the voltage waveform with baseline values subtracted.
  EXACTBINTIME is the time interval of each bin exactly, which varies depending upon the sampling rate of Vm.
 
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
  vm_baseline_correct ([])        | If non-empty, perform a baseline correction of the
                                  |    voltage waveform using this much pre-stimulus 
                                  |    time (units of t, should be seconds).
                                  |    (Recommended for sharp electrode recordings, not receommended
                                  |    for patch recordings.)
  vm_baseline_correct_func        | The function to use for correcting baseline (usually 'median' or 'mean').
              ('median')
