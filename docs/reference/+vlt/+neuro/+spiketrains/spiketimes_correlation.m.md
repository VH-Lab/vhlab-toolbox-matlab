# vlt.neuro.spiketrains.spiketimes_correlation

  SPIKETIMES_CORRELATION - Compute correlation of 2 spike trains
 
    [CORR, LAGS] = vlt.neuro.spiketrains.spiketimes_correlation(TRAIN1,TRAIN2,BINSIZE, MAXLAG)
 
   Computes the raw correlation between 2 spike trains that are specified by
   the spike times of TRAIN1 and TRAIN2 at the lags requested from -MAXLAG to MAXLAG.
   Spike events are binned into bins of size BINSIZE (same time units as LAGS).
   MAXLAG should be evenly divided by BINSIZE (such that MAXLAG/BINSIZE yields an integer).
 
   For example, if LAGS(i) is 0, then CORR(i) returns the number of times the 
   2 cells spiked stimulateously (within the resolution BINSIZE). If LAGS(i) is 0.010,
   then CORR(i) returns the number of times cell 2 spiked 10ms after cell 1 (with a resolution
   of BINSIZE).
 
   Note that this treatment of "LAGS" is backwards from the function XCORR.
 
   Example:
      train1 = [ 0 0.010 0.020];
      train2 = [ 0 0.010 0.020 0.022];
      [corr,lags] = vlt.neuro.spiketrains.spiketimes_correlation(train1,train2,0.001,0.010);
      figure;
      bar(lags,corr);
      xlabel('Time lags');
      ylabel('Counts');
 
   See also: XCORR
