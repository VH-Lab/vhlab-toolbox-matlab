# vlt.neuro.membrane.vmnospikes

```
  VMNOSPIKES - Return underlying voltage with spikes removed
 
   [VMNS,T,SPIKETIMES] = vlt.neuro.membrane.vmnospikes(VM, SI)
 
   Removes spikes from the trace VM with sample interval SI.
   Optionally, one can re-sample at a higher SI (lower sampling rate).
 
   SPIKETIMES that were detected are returned in SPIKETIMES.
 
   The behavior of this function can be modified by passing name/value
   pairs:
 
   Parameter (default):     | Description:
   ---------------------------------------------------------------
   newsi (si)               | If the interval is higher than si,
                            |   then the waveform is smoothed (boxcar)
                            |   and downsampled.
   filter_algorithm         | Filter algorithm: choice of 'vlt.signal.removespikes', which employs
      ('vlt.signal.removespikes')      |   detects spikes and removes them with vlt.signal.removespikes;
                            |   or 'medfilt1' which performs a median filter using MEDFILT1
   spiketimes ([])          | Extracted spike times from the trace
                            |   (if empty, then spikes are extracted using
                            |   threshold crossing and vlt.signal.refractory period)
                            |   Spike times are in same units as SI
                            |   and are relative to Tstart
   thresh (-0.030)          | Spike threshold for spike detection (not used
                            |   if spiketimes is given)
   refract (0.0025)         | Refractory period (in same units as SI)
   MedFilterWidth           | MedFilterWidth (see MEDFILT1)
       (round(0.004/SI) )   | 
   Tstart (0)               | Time of the first sample of the VM trace
   removespikes_inputs ({}) | Any custom inputs we should pass to vlt.signal.removespikes
                            |   (see vlt.signal.removespikes)
   rm60hz (1)               | 0/1 should we filter 60Hz noise? (uses vlt.signal.remove60hz)
   rm60hz_inputs ({})       | Any custom arguments we should pass to vlt.signal.remove60hz
                            |   (see vlt.signal.remove60hz)

```
