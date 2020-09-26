function [corr,lags] = spiketimes_correlation(train1,train2, binsize, maxlag)
% SPIKETIMES_CORRELATION - Compute correlation of 2 spike trains
%
%   [CORR, LAGS] = SPIKETIMES_CORRELATION(TRAIN1,TRAIN2,BINSIZE, MAXLAG)
%
%  Computes the raw correlation between 2 spike trains that are specified by
%  the spike times of TRAIN1 and TRAIN2 at the lags requested from -MAXLAG to MAXLAG.
%  Spike events are binned into bins of size BINSIZE (same time units as LAGS).
%  MAXLAG should be evenly divided by BINSIZE (such that MAXLAG/BINSIZE yields an integer).
%
%  For example, if LAGS(i) is 0, then CORR(i) returns the number of times the 
%  2 cells spiked stimulateously (within the resolution BINSIZE). If LAGS(i) is 0.010,
%  then CORR(i) returns the number of times cell 2 spiked 10ms after cell 1 (with a resolution
%  of BINSIZE).
%
%  Note that this treatment of "LAGS" is backwards from the function XCORR.
%
%  Example:
%     train1 = [ 0 0.010 0.020];
%     train2 = [ 0 0.010 0.020 0.022];
%     [corr,lags] = spiketimes_correlation(train1,train2,0.001,0.010);
%     figure;
%     bar(lags,corr);
%     xlabel('Time lags');
%     ylabel('Counts');
%
%  See also: XCORR

  % note: future development could handle the case when this vector is too big for memory;
  % could handle this by looping over all train1 spikes and calling histc

bins = min(min(train1),min(train2)):binsize:max(max(train1),max(train2));

train1_bins = spiketimes2bins(train1,bins);
train2_bins = spiketimes2bins(train2,bins);

[corr,lags] = xcorr(train2_bins,train1_bins,round(maxlag/binsize));

lags = lags * binsize;

