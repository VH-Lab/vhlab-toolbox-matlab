# vlt.neuro.stimulus.stimulus_response_scalar

  STIMULUS_RESPONSE_SUMMARY - compute stimulus responses to stimuli
  
  RESPONSE = vlt.neuro.stimulus.stimulus_response_scalar(TIMESERIES, TIMESTAMPS, STIM_ONSETOFFSETID, ...)
 
  Inputs:
    TIMESERIES is a 1xT array of the data values of the thing exhibiting the response, such as
        a voltage signal, calcium dF/F signal, or spike signals (1s).
    TIMESTAMPS is a 1xT array of the occurrences of the signals in TIMESERIES
    STIM_ONSETOFFSETID is a variable that describes the stimulus history. Each row should
        contain [stim_onset_time stim_offset_time stimid] where the times are in units of TIMESTAMPS (s).
  
  Computes a structure RESPONSE with fields:
  Field name:                   | Description:
  ------------------------------------------------------------------------
  stimid                        | The stimulus id of each stimulus observed; there will be 1 value of stimid
                                |   for each stimulus presentation (so stimid values may repeat many times)
  response                      | The scalar response to each stimulus response.
  control_response              | The scalar response to the control stimulus for each stimulus
  controlstimnumber             | The stimulus number used as the control stimulus for each stimulus
  parameters                    | A structure with the parameters used in the calculation (described below)
 
  The behavior of the function can be modified by name/value pairs:
  Parameter (default value)     | Description: 
  ------------------------------------------------------------------------
  freq_response (0)             | The frequency response to measure using FFT of TIMESERIES. Can be
                                |     0 (to use the mean response), or a number corresponding
                                |     to the frequency to analyze. Can also be a vector
                                |     the same size as the number of stimuli to indicate
                                |     the frequency to be used for each stimulus (freq_response(stimid(i)).
                                |     For example, to compute the response at the fundamental stimulus
                                |     frequency (F1) when that frequency is 1 Hz, pass 1 for 'freq_response'.
  control_stimid ([])           | Use this to pass the identity (or identities) of a 'blank' stimulus
                                |     (some sort of control stimulus; in vision, this is often presenting
                                |     a blank screen for same duration as the other stimuli.)
  prestimulus_time ([])         | Calculate a baseline using a certain amount of TIMESERIES signal during
                                |     the pre-stimulus time given here. 
  prestimulus_normalization ([])| Normalize the stimulus response based on the prestimulus measurement.
                                | [] or 0) No normalization 
                                |       1) Subtract: Response := Response - PrestimResponse
                                |       2) Fractional change Response:= ((Response-PrestimResponse)/PrestimResponse)
                                |       3) Divide: Response:= Response ./ PreStimResponse
  isspike (see right)           | 0/1 Is the signal a spike process? If so, timestamps correspond to spike events.
  spiketrain_dt (0.001)         | Resolution to use for spike train reconstruction if computing Fourier transform
