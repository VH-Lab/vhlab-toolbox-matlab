# vlt.neuro.stimulus.stimulus_response_summary

```
  STIMULUS_RESPONSE_SUMMARY - compute a stimulus response summary for timeseries data
  
  RESPONSE = vlt.neuro.stimulus.stimulus_response_summary(TIMESERIES, TIMESTAMPS, STIM_ONSETOFFSETID, ...)
 
  STIM_ONSETOFFSETID is a variable that describes the stimulus history. Each row should
  contain [stim_onset_time stim_offset_time stimid] where the times are in units of TIMESTAMPS (s).
  
  Computes a structure RESPONSE with fields:
  Field name:                   | Description:
  ------------------------------------------------------------------------
  stimid                        | The stimulus id of each stimulus observed
  mean_responses                | The mean response of TIMESERIES across stimulus
                                |     presentations [stimid(1) stimid(2) ...]
  stddev_responses              | The standard deviation of TIMESERIES across stimulus
                                |     presentations [stimid(1) stimid(2) ...]
  stderr_responses              | The standard error of the mean of TIMESERIES
                                |     across stimulus presentations [stimid(1) stimid(2) ...]
  individual_responses          | A cell array with the individual responses to each stimulus
                                |    individual_responses{i}(j) has the jth response to stimulus with stimid(i)
  blank_mean                    | The mean response of TIMESERIES to the blank stimulus, if one is
                                |    specified with 'blank_stimid'
  blank_stddev                  | The standard deviation of the response of TIMESERIES to the blank stimulus,
                                |     if one is specified with 'blank_stimid'
  blank_stderr                  | The standard error of the mean of the responses of TIMESERIES to the blank stimulus,
                                |     if one is specified with 'blank_stimid'
  blank_individual_responses    | The individual responses of TIMESERIES to the blank stimulus, if one 
                                |     is specified with 'blank_stimid'
 
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
  blank_stimid ([])             | Use this to pass the identity (or identities) of a 'blank' stimulus
                                |     (some sort of control stimulus; in vision, this is often presenting
                                |     a blank screen for same duration as the other stimuli.)
                                |     The 'blank' stimulus is not counted among the stimuli in 'stimid'
  prestimulus_time ([])         | Calculate a baseline using a certain amount of TIMESERIES signal during
                                |     the pre-stimulus time given here. 
  prestimulus_normalization ([])| Normalize the stimulus response based on the prestimulus measurement.
                                | [] or 0) No normalization 
                                |       1) Subtract: Response := Response - PrestimResponse
                                |       2) Fractional change Response:= ((Response-PrestimResponse)/PrestimResponse)
                                |       3) Divide: Response:= Response ./ PreStimResponse

```
