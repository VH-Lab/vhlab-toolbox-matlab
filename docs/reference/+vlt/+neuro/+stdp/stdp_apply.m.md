# vlt.neuro.stdp.stdp_apply

  STDP_APPLY Spike-timing dependent-plasticity for calculating changes in synaptic weights
 
     WEIGHT = vlt.neuro.stdp.stdp_apply(SPIKETIMES_PRE, SPIKETIMES_POST)
 
   Calculates the change in synaptic weight due to the classic
   SPIKE-TIMING-DEPENDENT-PLASTICITY model curve provided in
   Song and Abbott 2001 (Neuron):
       For all pairs of pre- and post-synaptic spikes, let the
       time between them be called dT = t_pre - t_post.
       If dT < 0, delta_weight = A_plus * exp(dT/tau_plus) 
       If dT >= 0, delta_weight = -A_minus * exp(-dT/tau_minus)
 
   WEIGHT is a factor that indicates how the maximumal
   conductance is modified. In Song and Abbott, the synaptic 
   conductance was modified by the following forumla:
   G -> G + G_max * WEIGHT
 
   Only spikes that occur at or after the time T0 will be examined for STDP.
   By default, T0 is 0.  (One could use this to restrict the influence
   of STDP to spike pairs where at least one member of the pair occurs
   after a particular time.)
   
   The parameters of the synapse can be varied by providing additional 
   inputs as name, value pairs. The names and values that are default are
   shown here. For example,
     WEIGHT = vlt.neuro.stdp.stdp_apply(SPIKETIMES_PRE, SPIKETIMES_POST, 'tau_plus',0.050)
 
   Parameter name:               | default value
   ------------------------------|-----------------------------
   tau_plus                      | 0.020 (units are same as spiketimes)
   tau_minus                     | 0.020
   A_plus                        | 0.005 (a 5% change)
   A_minus                       | 0.00525 (a 5.25% change)
   T0                            | 0
