# vlt.neuro.mledenoise.gaindriftexample

```
  GAINDRIFTEXAMPLE - Create an artificial stimulus response where gain varies
 
   [SPIKETIMES, R, T, STIM_ON_TIMES, STIM_OFF_TIMES, STIM_NUMBERS, G] = ...
           vlt.neuro.mledenoise.gaindriftexample
 
   Creates a spike train that with the following rate:
 
   r(t) = g(t) * s_i(t)
 
   The ongoing gain of the system is g(t), and is a slow sinusoid.
   s_i(t) is the response to stimulus i.
 
   Outputs:
   SPIKETIMES is the time of all of the stimulated spikes.
   R is the rate used to generate the spikes
   T is an array of time value for the simulated rate values
   STIM_ON_TIMES is an array of times of stimulus onset
   STIM_OFF_TIMES is an array of time of stimulus offset
   STIM_NUMBERS is an array of stim ids
   G is the gain as a function of time.
 
   Alternatively, one may use:
 
   [SPIKETIMES, STIM_ON_TIMES, STIM_OFF_TIMES, STIM_NUMBERS] = ...
           vlt.neuro.mledenoise.gaindriftexample('PROPERTY1',VALUE1,...);
 
   can be used to alter the parameters used to create the model as follows:
 
   NAME:                    DESCRIPTION:
   -------------------------------------------------------------------------
   'gain_amplitude'         The amplitude of the gain modulation (default 2)
   'gain_frequency'         Frequency of gain modulation (default 1/300 Hz)
   'gain_offset'            Offset of gain modulation (default 0.5)
   'stim_response'          Mean responses to each stim (default [20 10 5 0])
   'stim_repeats'           Number of times to repeat each stim (default 50)
   'stim_duration'          Duration of each stimulus (default 2 seconds)
   'stim_isi'               Inter-stimulus-interval (default 5 seconds)
   'response_tf'            Temporal frequency of response (default 0Hz)
   'dt'                     Time step of simulation; default 0.001 seconds
 
   Creates an artificial stimulus response where gain varies.
 
   Creates REPS numbers of repetitions of the stimuli that have mean responses
   STIM_RESPONSES(i).  The length of STIM_RESPONSES determines the number of 
   stimuli that are produced.  Each stimulus is assumed to last STIM_DURATION
   seconds.  
 
   Example:
 
      [spiketimes,r,t,stimon,stimoff,stimids,g]=vlt.neuro.mledenoise.gaindriftexample;
      figure;
      plot(t,r);
      hold on;
      plot(spiketimes,50,'kx'); % plot an x for each simulated spike time
      plot(t,g,'g'); % plot gain
      for i=1:length(stimon),
         text(mean([stimon(i) stimoff(i)]), 55, int2str(stimids(i)));
      end;
      axis([t(1) t(end) -60 60]); box off;
      xlabel('Time(s)'); ylabel('Firing rate');
      title('x indicates spike, numbers indicate stimulus number');

```
