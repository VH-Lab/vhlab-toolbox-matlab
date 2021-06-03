# vlt.neuro.spiketrains.loglikelihood_spiketrain

```
  LOGLIKELIHOOD_SPIKETRAIN - Compute the log likelihood of seeing spike counts
 
   LL = vlt.neuro.spiketrains.loglikelihood_spiketrain(BIN_RATES, BIN_DURATIONS, SPIKECOUNTS)
 
   Computes the log likelihood of observing SPIKECOUNTS(i) in 
   bins of length BIN_DURATION(i) with firing rates BIN_RATES(i).
 
   The following equation is used to calculate the log likelihood:
 
   logP = sum over i of
      bin_rates(i)*bin_durations(i) + spikecounts(i)*log(bin_rates(i)*bin_durations)-log(k!)
 
   See "A Novel Circuit Model of Contextual Modulation and Normalization in Primary Visual Cortex"
   Columbia University 2012

```
