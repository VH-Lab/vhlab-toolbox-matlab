# vlt.stats.power_index

```
  POWER_INDEX - Compute the number of observations needed to find a change
 
   N = vlt.stats.power_index(MN, STDDEV, CHANGE, G, CONF)
 
   Uses Monte Carlo techniques to estimate number of samples needed to
   see a change of size CHANGE from a mean of MN across G groups,
   assuming the samples have normally distributed noise with standard
   deviation of STDDEV, with a confidence of CONF. An ANOVA1 is used to
   look for differences across the G groups in the simulated data.
 
   See also: ANOVA1

```
