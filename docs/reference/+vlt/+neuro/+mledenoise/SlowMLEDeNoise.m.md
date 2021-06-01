# vlt.neuro.mledenoise.SlowMLEDeNoise

  SlowMLEDeNoise -- Estimate underlying stimulus response assuming a slow background drift in gain
 
    [RESPONSES, SIN_WEIGHTS] = vlt.neuro.mledenoise.SlowMLEDeNoise(STIM_ONSETS, STIMOFFSETS, STIMVALUES, ...
 	SPIKE_TIMES, [PARAM1, VALUE1, ...]);
       
         (see additional output arguments below)
   
    This function assumes that the response to a neural spike train in response to stimuli
    s_i can be written as
   
    r(t) = g(t) * s_i(t) 
 
    where r(t) is the actual response observed as a function of time, g(t) is an unknown
    slow background gain modulation of the cortex, and s_i(t) is the unknown mean response
    to each stimulus.
 
    The parameters g(t) and s_i(t) are estimated using a maximum likelihood approach.
 
    First, initial estimates of g(t) and s_i(t) are made.  The function g(t) is fit
    as the sum of 4 sinusoids. These sinwaves are constrained to have very low
    temporal frequencies, and cannot take a temporal frequency faster than 1/10
    of the total trial duration by default (see 'maxFrequency' parameter below).
    The measured mean response to each stimulus is taken to be the initial estimate of
    s_i(t).
    
    We then iteratively re-estimate s_i(t) and g(t) to increase the likelihood of the 
    data r(t) that we actually observed. First, s_i(t) is fixed while g(t) is re-estimated,
    and then g(t) is fixed while s_i(t) is re-estimated.  This process is repeated 10 times
    be default (see 'numIterations' parameter below).
 
    Note: This is a generalization of code that Dan Rubin wrote as part of his PhD Thesis:  
    "A Novel Circuit Model of Contextual Modulation and Normalization in Primary Visual Cortex"
    Columbia University 2012
 
    RESPONSES are the estimated mean responses to each unique stimulus.
    SIN_WEIGHTS are the best-fit amplitude coefficients to the underlying 4 term sinusoidal fit.
 
    PARAMETERS that can be modified, with default values:
        'mlesmoothness'         :   Constraint of smoothness of second derivative of stimulus
                                :      response. Default 0.1 response units squared/stimvalues squared.
                                :      The 2nd derivative calculation assumess that STIMVALUES are
                                :      equally spaced.  Any change that is faster than this constraint
                                :      is not allowed.
        'tFilter'               :   Timecourse of spikerate filter, default 100 (seconds)
        'sin_dt'                :   Step size for smoothed sinusoid function, default 0.1 (seconds)
        'dt'                    :   Step size for simulated firing rate, default 1/1000 (seconds)
        'model'                 :   Can be 'Poisson' or 'Gaussian' (case insensitive)
                                :      Use 'Poisson' for spike responses, and 'Gaussian' for 
                                :      continuous-valued measurements (spike rates/voltages/etc)
        'responses_s_i'         :   Responses to each stimulus; if this is
                                :      empty, then the spike rates are calculated from the
                                :      stimulus on and off times (average rate) (default [])
                                :      If you want to calculate the response to a continuous
                                :      process such as the F1 component or a voltage, then
                                :      you must provide this.
                                :      This quantity serves as the r(t) to be fit, and also
                                :      serves as the initial estimate of s(t).
        'prerecordtime'         :   Number of seconds before the first stimulus that we assume 
                                :      the recording of spikes began (default 5)
        'postrecordtime'        :   Number of seconds after the last stimulus that we assume 
                                :      the recording of spikes continued (default 5)
        'maxFrequency'          :   Maximum temporal frequency of the smoothed sinewave, where
                                :      1 cycle is the duration of the whole experiment. Default 10
        'numIterations'         :   Number of re-estimation steps to perform. Default 10.
        'verbose'               :   0/1 Prints what is going on as function runs (default 0)
 
    One can also retrieve additional outputs:
 
    [RESPONSES, SIN_WEIGHT, FIT_SIN4, MLE, RESPONSE_OBSERVED,...
        STIMLIST, RESPONSES_S_I, SMOOTH_TIME, SMOOTH_SPIKERATE, SINFIT_SMOOTH_SPIKERATE]...
            = vlt.neuro.mledenoise.SlowMLEDeNoise(STIM_ONSETS, STIMOFFSETS, STIMVALUES, ...
 	          SPIKE_TIMES, [PARAM1, VALUE1, ...]);
 
    FIT_SIN4 is a set of 13 coefficients to a 4th order sinusoidal fit (see vlt.fit.sin4_fit), 
    MLE is the actual maximum likelihood value
    RESPONSE_OBSERVED is the actual responses that were observed. In the case of the Poisson
       model, this is the number of spikes per stimulus. In the case of the Gaussian model,
       this is the response rate.
    STIMLIST is the order in which the stimuli were presented; stimuli are numbered
       according to the value of STIMVALUES, from least to greatest (see help UNIQUE)
    RESPONSES_S_I are the responses (r(t)*g(t)) for each stimulus in STIMLIST
    
 
   Examples:  see vlt.neuro.mledenoise.testSlowMLE and vlt.neuro.mledenoise.testSlowMLE_modulation
           ('type vlt.neuro.mledenoise.testSlowMLE'  and 'type vlt.neuro.mledenoise.testSlowMLE_modulation')
   
   See also:  FIT_SIN4
