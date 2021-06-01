# vlt.neuro.membrane.voltage_firingrate_observations_per_stimulus

  VOLTAGE_FIRINGRATE_OBSERVATIONS - calculate voltage and firing rate observations for a stimulus (mean, mean at a frequency)
 
  [MEAN_V, MEAN_FR, STIMID, STIMPRES, VMOPSPERSTIM, FROBSPERSTIM] = vlt.neuro.membrane.voltage_firingrate_observations_per_stimulus(...
         VM, SPIKERATE, TIME, STIM_ONSETOFFSETID, ...)
 
  Calculates the mean response across each stimulus presentation described in STIM_ONSETOFFSETID for both voltage (VM)
  and SPIKERATE. SPIKERATE should be the firing rate at each time point T, VM is the voltage at each time point T.
  STIM_ONSETOFFSETID should have 1 row per stimulus and each row should contain [stim_onset_time stim_offset_time stimid]
  where the times are in units of 'TIME' (such as seconds). STIMPRES is the stimulus presentation number.
 
  VMOPSPERSTIM is a cell array containing the voltage observations for each stimulus (F1 empty only).
  FROBSPERSTIM is a cell array containing the voltage observations for each stimulus (F1 empty only).
 
  This function also takes NAME/VALUE parameter pairs that modify its behavior.
  Parameter (default value)        | Description
  -----------------------------------------------------------------------------
  PRETIME ([])                     | If not empty, the voltage PRETIME seconds before each
                                   |    stimulus is subtracted from the response. 
  F1 ([])                          | If not empty, then the responses is taken to be the
                                   |    magnitude of the fourier transform at the frequency F1.
