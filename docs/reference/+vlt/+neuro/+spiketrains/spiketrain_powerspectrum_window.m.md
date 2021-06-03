# vlt.neuro.spiketrains.spiketrain_powerspectrum_window

```
  SPIKETRAIN_POWERSPECTRUM_WINDOW - calculate the power spectrum of a spike train using a sliding window
 
   [Pxx,Fxx, BANDVALUES, BANDS] = vlt.neuro.spiketrains.spiketrain_powerspectrum_window(SPIKETRAIN,...
          [START WINDOWSIZE STEP STOP], ...)
 
   Returns the power spectrum Pxx at different frequencies Fxx.  The power spectrum is
   calculated from time START to STOP using sliding windows of size WINDOWSIZE.  The
   window is advanced STEP units each time.
 
   The power spectrum is calculated by calling the function vlt.neuro.spiketrains.spiketrain_powerspectrum.
 
   One can modify the default parameters by adding name/value pairs to the function:
   Parameter (default value)  :  Description
   --------------------------------------------------------------------------------
   BINSIZE (0.002)            :  Bin size for spike trains (seconds)
   NFFT (2^15)               :  Number of FFT values to use in powerspectrum
   bands ([0.1 4;,...         :  Frequency bands for averaging.
           4 8; ...
           8 12; ...
          12 30]);
 
 
 
  0.1-4 Hz, theta 4-8, alpha 8-12, beta 12-30
   
 
   See also: vlt.neuro.spiketrains.spiketrain_powerspectrum

```
