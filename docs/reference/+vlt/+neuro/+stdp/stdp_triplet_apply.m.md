# vlt.neuro.stdp.stdp_triplet_apply

```
  STDP_TRIPLET_APPLY Spike-timing dependent-plasticity for calculating changes in synaptic weights
 
     WEIGHT = vlt.neuro.stdp.stdp_triplet_apply(SPIKETIMES_PRE, SPIKETIMES_POST)
 
   Calculates the change in synaptic weight due to the triplet
   SPIKE-TIMING-DEPENDENT-PLASTICITY model curve provided in
   Pfister and Gerstner 2006 (J Neurosci) and described in
   Bourjaily and Miller 2011 (Frontiers in Comp. Neurosci):
 
       For all pairs of pre- and post-synaptic spikes, let the
       time between them be called dT = t_pre - t_post.
       If dT < 0, delta_weight = A_plus * exp(dT/tau_plus) 
       If dT >= 0, delta_weight = A_minus * exp(-dT/tau_minus)
 
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
     WEIGHT = vlt.neuro.stdp.stdp_triplet_apply(SPIKETIMES_PRE, SPIKETIMES_POST, 'tau_plus',0.050)
 
   Parameter name:               | default value
   ------------------------------|-----------------------------
   tau_plus                      | 0.01668 (units are same as spiketimes)
   tau_minus                     | 0.0337
   tau_x                         | 0.101
   tau_y                         | 0.125
   A2_plus                       | 5e-5
   A2_minus                      | 7e-3
   A3_plus                       | 6.2e-3
   A3_minus                      | 2.3e-4
   T0                            | 0

```
