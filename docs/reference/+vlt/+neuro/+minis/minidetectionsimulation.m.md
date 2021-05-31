# vlt.neuro.minis.minidetectionsimulation

  MINIDETECTIONSIMULATION
 
   [OPT_THRESHOLD, DETECTOR, CONV_SCALE, STATS] = vlt.neuro.minis.minidetectionsimulation
 
   Solves, through simulation, the optimum threshold for detecting miniature 
   excitatory or inhibitory post-synaptic potentials or currents.
 
   Minis are assumed to arrive on a background of pure gaussian noise with
   a standard deviation of 1. (One can divide the threshold by the actual noise 
   encountered in one's own data to obtain the equivalent value for real data.)
 
   OPT_THRESHOLD - the threshold that produced the fewest overall errors of
   detection, weighing false positives and false negatives equally (because both
   errors have the same impact on average mini frequency and amplitude).
 
   DETECTOR - The filter used for detection. It assumes a positively-going wave
   (simply multiply this by -1 to switch sign).
 
   CONV_SCALE - The amount by which the convolution of the data and the DETECTOR
   should be scaled to reproduce the detection values used in this simulation
   (depends on sampling rate and number of samples).
 
   STATS - a structure with error rates for different values of threshold.
 
   The behavior of the function can be altered by passing name/value pairs:
 
   Parameter (default)          | Description
   ------------------------------------------------------------------------------
   DT (0.001)                   | The time step between adjacent samples
   Tau_Onset  (0.0025)          | The time of the synaptic potential onset (in seconds)
   Tau_Offset (0.0250)          | The time of the synaptic potential offset (in seconds)
   Simulation_Duration (100)    | The simulation duration (seconds)
   expected_rate_of_events (10) | The expected rate of real events (Hz)
   noise_fraction (0.1)         | The fraction that Tau_Offset and Tau_Onset should be
                                |   altered by noise in the simulation
   threshold_steps (50)         | Threshold steps to examine
   refractory_period (0.020)    | Refractory period (time between events can be no shorter
                                |   than this, in seconds)
   plotit (0)                   | Plot the threshold vs. errors curve
