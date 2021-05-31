# vlt.neuro.mledenoise.response_gaindrift_model

  RESPONSE_GAINDRIFT_MODEL - Computes the response of the gain drift model
 
   R=vlt.neuro.mledenoise.response_gaindrift_model(STIM_TIMES, STIM_DURATION, STIMLIST,...
       SINPARAMS, G_PARAMS, S_I_PARAMS);
 
    This function assumes that the response to a neural spike train in response to stimuli
    s_i can be written as
 
    r(t) = g(t) * s_i(t)
 
    where r(t) is the actual response observed as a function of time, g(t) is an unknown
    slow background gain modulation of the cortex, and s_i(t) is the unknown mean response
    to each stimulus.
 
    This function computes the response to a specific model, where the stimuli are presented
    in order STIMLIST at times STIM_TIMES and have stim duration STIM_DURATION. 
    It is further assumed that SINPARAMS are parameters of a 4 sinusoidal fit to the data
    that describes the slow drift in gain g. 
 
    S_I_PARAMS is the mean response to stimulus type i, which can occur more than once in
    the STIMLIST.
 
    G_PARAMS is a 4 element vector that describes the weighting of the 4 sinusoids.  If 
    G_PARAMS has a 5th element, it is assumed to be a constant offset for g(t).
 
    R is returned at the STIM_TIMES.  If R is less than or equal to 0, R is set to eps.
