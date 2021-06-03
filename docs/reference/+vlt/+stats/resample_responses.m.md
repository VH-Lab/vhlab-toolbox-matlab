# vlt.stats.resample_responses

```
  vlt.stats.resample_responses - Resample responses for montecarlo simulations
 
   NEWRESPS = vlt.stats.resample_responses(TRIALDATA, MODE, REPS)
 
   Generates a simulated set of responses.
 
   TRIALDATA - A matrix size NUM_STIMS x NTRIALS
      If no data is available for a given trail, it can be coded as NaN.
      NaN values will be ignored.
 
   If MODE==1, then simulated samples are generated with a random number
   generator given the measured mean and variance of each stimulus.
 
   If MODE==2, then the data are resampled with replacement, as would
   be appropriate for bootstrap analysis.
 
   REPS - The number of simulated trials to generate.
 
   Based on code by Mark Mazurek

```
