# vlt.neuro.stimulus.stimulus_response_stats

  STIMULUS_RESPONSE_SUMMARY - compute a stimulus response summary for timeseries data
  
  STATS = vlt.neuro.stimulus.stimulus_response_stats(RESPONSES,...)
 
  RESPONSES is a structure returned from vlt.neuro.stimulus.stimulus_response_scalar that has fields
  Field name:                   | Description
  --------------------------------------------------------------------------------
  stimid                        | Stimulus id number for each stimulus presentation
  response                      | Computed scalar response for each stimulus presentation
  control_response              | Computed scalar response to a control stimulus (could be empty)
  controlstimnumber             | The stimulus number that was used as the control stimulus for
                                |     each stimulus presentation
  parameters                    | A structure of parameters used in the computation
                                |     (see HELP vlt.neuro.stimulus.stimulus_response_scalar)  
  
  Computes a structure STATS with fields:
  Field name:                   | Description:
  ------------------------------------------------------------------------
  stimid                        | The stimulus id of each stimulus observed
  mean                          | The mean response of TIMESERIES across stimulus
                                |     presentations [stimid(1) stimid(2) ...]
  stddev                        | The standard deviation of TIMESERIES across stimulus
                                |     presentations [stimid(1) stimid(2) ...]
  vlt.stats.stderr                        | The standard error of the mean of TIMESERIES
                                |     across stimulus presentations [stimid(1) stimid(2) ...]
  individual                    | A cell array with the individual responses to each stimulus
                                |    individual_responses{i}(j) has the jth response to stimulus with stimid(i)
  control_mean                  | The mean response of TIMESERIES to the control stimulus, if one is
                                |    specified with RESPONSES.parameters.control_stimulus
  control_stddev                | The standard deviation of the response of TIMESERIES to the control stimulus,
                                |    if one is specified with RESPONSES.parameters.control_stimulus
  control_stderr                | The standard error of the mean of the responses of TIMESERIES to the control stimulus,
                                |    if one is specified with RESPONSES.parameters.control_stimulus
  control_individual            | The individual responses of TIMESERIES to the control stimulus, 
                                |    if one is specified with RESPONSES.parameters.control_stimulus
 
  The behavior of the function can be modified by name/value pairs:
  Parameter (default value)     | Description: 
  ------------------------------------------------------------------------
  control_normalization ([])    | Normalize the stimulus response based on the prestimulus measurement.
                                | [] or 0) No normalization 
                                |       1) Subtract: Response := Response - PrestimResponse
                                |       2) Fractional change Response:= ((Response-PrestimResponse)/PrestimResponse)
                                |       3) Divide: Response:= Response ./ PreStimResponse
  
 
  See also: vlt.data.namevaluepair
