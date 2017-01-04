function ll = loglikelihood_spiketrain(bin_rates, bin_sizes, spikecounts)
% LOGLIKELIHOOD_SPIKETRAIN - Compute the log likelihood of seeing spike counts
%
%  LL = LOGLIKELIHOOD_SPIKETRAIN(BIN_RATES, BIN_DURATIONS, SPIKECOUNTS)
%
%  Computes the log likelihood of observing SPIKECOUNTS(i) in 
%  bins of length BIN_DURATION(i) with firing rates BIN_RATES(i).
%
%  The following equation is used to calculate the log likelihood:
%
%  logP = sum over i of
%     bin_rates(i)*bin_durations(i) + spikecounts(i)*log(bin_rates(i)*bin_durations)-log(k!)
%
%  See "A Novel Circuit Model of Contextual Modulation and Normalization in Primary Visual Cortex"
%  Columbia University 2012

if any(spikecounts>100), % if spikecounts are large, use approximation
	logKfactorial = 0 * spikecounts;
	for i=1:length(spikecounts),
		logKfactorial(i) = sum(log(1:spikecounts(i)));
	end;
else,
	logKfactorial = log(factorial(spikecounts(:)));
end;

ll = -bin_rates(:).*bin_sizes(:)+spikecounts(:).*log(bin_rates(:).*bin_sizes(:))-logKfactorial(:);
ll = sum(ll);
