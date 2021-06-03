# vlt.neuro.stimulus.descramble_pseudorandom

```
  DESCRAMBLE_PSEUDORANDOM - Descramble responses to pseduorandomly varied stimuli
 
    [RESPONSE_CURVE] = vlt.neuro.stimulus.descramble_pseudorandom(STIM_RESPONSES, STIMVALUES)
 
   Descrambles responses to pseudorandomly varied stimuli.
 
   Inputs:  
        STIM_RESPONSES:        |  Responses to individual stimuli (1xN or Nx1 list)
        STIMVALUES:            |  The stimulus value (or, could be stimulus ID)
                               |    for each of the N presented stimuli (1xN or Nx1)
                               |    To indicate that a stimulus is a "blank" or "control"
                               |    provide NaN for its value.
 
   Output: RESPONSE_CURVE is a structure with the following fields:
         curve        |  4xN matrix, where N is the number of distinct
                      |     stimuli; the first row has the stim values
                      |     the second row has the mean responses in 
                      |     spikes per time unit of STIMTIMES_ON/OFF,
                      |     the third row has the standard deivation of
                      |     these spike rates, and the fourth row has
                      |     the standard error.
         blank        |  1x3 vector with the mean, standard deviation, and
                      |     standard error.
         inds         |  1xN cell array; each value inds{i} has the individual
                            responses for the ith repetition of stimulus i
         blankinds    |  1xM vector with individual responses to the blank stimulus
         indexes      |  2xnum_stims Indicates where the nth stim is represented in
                      |     in inds (first column is stimid, second column is entry
                      |     number in vector inds{stimid})

```
