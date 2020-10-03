function [Xcorr_actual, Xcorr_shifted, Xcorr_percentile, bins] = spiketimes_correlation_timeshiftsubtract(train1, train2, binsize, maxlag, shift, trials)
% SPIKETIMES_CORRELATION_TIMESHIFTSUBTRACT - Correlation that subtracts correlation not due to precise times
%
%  [XCORR_ACTUAL, XCORR_SHIFTED, XCORR_PERCENTILE, LAGS] = 
%    vlt.neuro.spiketrains.spiketimes_correlation_timeshiftsubtract(TRAIN1, TRAIN2, BINSIZE,...
%    MAXLAG, SHIFT, TRIALS)
%
%  Computes both the standard spike train correlation (XCORR_ACTUAL) between
%  TRAIN1 and TRAIN2, lists of spike times, using vlt.neuro.spiketrains.spiketimes_correlation, and
%  computes an estimate of the amount of this correlation that is due to slow
%  covarying spike rates with a time scale of SHIFT.
%
%  BINSIZE is the resolution (e.g., 0.002 for 2ms bins), and MAXLAG is the
%  maximum lag between the two trains TRAIN1 and TRAIN2 that will be computed.
%  (See help vlt.neuro.spiketrains.spiketimes_correlation)
%
%  The estimate of the amount of correlation that is due to slow covarying
%  spike rates is computed over TRIALS trials (e.g., 100), during which
%  each spike in the trains is time-shifted by a variable amount between 0 
%  and SHIFT (uniform distribution). SHIFT might be 0.100 to shift 100ms, 
%  for example.  This estimate is returned in XCORR_SHIFTED.  The percentile
%  distribution of XCORR_SHIFTED is returned in XCORR_PERCENTILE. Each Nth
%  row of XCORR_PERCENTILE is the N-1th percentile of the distribution.
%

[xcorr_actual,bins] = vlt.neuro.spiketrains.spiketimes_correlation(train1,train2,binsize,maxlag);

xcorr_estimate = [];


for t = 1:trials,
	train1_ = train1 + shift*rand(size(train1));
	train2_ = train2 + shift*rand(size(train2));
	xcorr_estimate(t,:) = vlt.neuro.spiketrains.spiketimes_correlation(train1_,train2_,binsize,maxlag);
end;

Xcorr_shifted = mean(xcorr_estimate);

Xcorr_percentile = prctile(xcorr_estimate,0:1:100);
