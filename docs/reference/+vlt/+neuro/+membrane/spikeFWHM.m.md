# vlt.neuro.membrane.spikeFWHM

```
  vlt.neuro.membrane.spikeFWHM - find the full-width, half-maximum range in single spike waveforms
 
  [FWHM] = vlt.neuro.membrane.spikeFWHM(SPIKEWAVES, V_SPIKEPEAK, SPIKEPEAK_LOC,V_INITIATION,SAMPLERATE)
 
  Inputs: 
  SPIKEWAVES      | 1D vector containing voltage values for each spikewave
  V_SPIKEPEAK     | 1D vector containing maximum voltage value of every
                  | spike wave (units V)
  SPIKEPEAK_LOC   | Position value of each spike peak
  KINK_VM         | Value where action potential begins, calculated
                  | by sister function vlt.neuro.membrane.spikekink (units V)
  SAMPLERATE      | Rate of sampling for each epoch (units Hz), given by ndi_app_spikeextractor 
                   
  Outputs:
  FWHM            | Full-width half maximum value, calculated from sample rate and converted to ms
  HM_PRESK_LOC    | Position value of half-maximum value before spike peak               | 
  HM_POSTSK_LOC   | Position value of half-maximum value after spike peak
  V_hm            | Voltage value of the half-maximum points (units V)

```
