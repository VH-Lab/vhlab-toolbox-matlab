# vlt.neuro.mledenoise.MLE_PoisGauss

```
 MLE_PoisGauss - Calculate maximum likelihood of gain and average stimulus responses given raw responses
    
    [PARAMS,FVAL] = vlt.neuro.mledenoise.MLE_PoisGauss(STIM_CENTER_TIMES, STIM_DURATIONS, RESPONSES_OBSERVED, ...
          SP, STIMLIST, MODEL, FIXPARAM, G_PARAMS, S_I_PARAMS, SMOOTHNESS);
 
   Inputs:
    STIM_CENTER_TIMES - The time points at which the stimuli were presented (middle of the stimuli)
                        Note that this vector should be as long as the number of stimuli times the
                        number of repetitions of those stimuli.
    STIM_DURATIONS -    The duration of each stimulus (should be a vector)
    RESPONSES_OBSERVED- The observed spike counts (for Poisson model) or rates (for Gaussian model)
                         that occurred for stimulus presentation i
                         (should be vector as long as number of stimui times number of repetitions)
    SP - Sinwave parameters
    STIMLIST - Stim ID numbers for all presented stimuli
    MODEL - 'Poisson' or 'Gaussian'
    FIXPARAM - Is the fixed parameter g (FIXPARAM==1) or s_i (FIXPARAM==0)?
    G_PARAMS - A list of amplitudes for the 4 sinwaves
    S_I_PARAMS - The estimated mean firing rate for the i different types of stimuli that were 
                 presented (note that this is as long as the number of unique stimuli).
    SMOOTHNESS - A constraint on the 2nd derivative (must be smoother than SMOOTHNESS)
                 If Inf is provided, or empty ([]), then this constraint is not used.
 
   Outputs: 
     PARAMS - The estimated parameters, either s_i (FIXPARAM==1) or g (FIXPARAM==0)
     Fval - the value of the function to be minimized

```
