# vlt.neuro.spiketrains.loglikelihood_spikerate

```
  LOGLIKELIHOOD_SPIKERATE - Compute the log likelihood of seeing spike rates
 
   LL = vlt.neuro.spiketrains.loglikelihood_spikerate(BIN_RATES, BIN_DURATIONS, SPIKERATES, SIGMA)
 
   Computes the log likelihood of observing SPIKECOUNTS(i) in 
   bins of length BIN_DURATION(i) with firing rates BIN_RATES(i).
 
   The following equation is used to calculate the log likelihood:
 
   logP = sum over i of
      -log((sqrt(2*pi)*sigma))-(spikerates(i)-bin_rates(i))^2/(2*sigma^2)
 
   See "A Novel Circuit Model of Contextual Modulation and Normalization in Primary Visual Cortex"
   Columbia University 2012

```
