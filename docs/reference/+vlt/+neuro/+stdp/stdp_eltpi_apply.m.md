# vlt.neuro.stdp.stdp_eltpi_apply

```
  STDP_ELTPI_APPLY Spike-timing dependent-plasticity for calculating changes in synaptic weights
 
     WEIGHT = vlt.neuro.stdp.stdp_eltpi_apply(SPIKETIMES_PRE, SPIKETIMES_POST)
 
   Calculates the change in synaptic weight due to the early LTPi 
   rule discovered by Maffei and colleages (unpublished). The model
   is closely related to the triplet SPIKE-TIMING-DEPENDENT-PLASTICITY
   model curve provided in Pfister and Gerstner 2006 (J Neurosci)
   and described in Bourjaily and Miller 2011 (Frontiers in Comp.
   Neurosci):
 
       For all pairs of pre- and post-synaptic spikes, let the
       time between them be called dT = t_pre - t_post.
       If dT < 0, delta_weight = A_plus * exp(dT/tau_plus) 
       If dT >= 0, delta_weight = A_minus * exp(dT/tau_minus)
 
   In addition, this pre/post synaptic activity is boosted by
   integrating the pre (tau_y) or post (tau_x) rate activity as
   described in Bourjaily and Miller 2011. (describe this better)
 
   The "boost" is further modified by a gaussian transformation
   such that the effect is boosted only at particular firing rates
   close the center of the gaussian.
   
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
     WEIGHT = vlt.neuro.stdp.stdp_eltpi_apply(SPIKETIMES_PRE, SPIKETIMES_POST, 'tau_plus',0.050)
 
   Parameter name:               | default value
   ------------------------------|-----------------------------
   tau_plus                      | 0.100 (units are same as spiketimes)
   tau_minus                     | 0.100
   tau_x                         | 0.100
   tau_y                         | 0.100
   tau_x2                        | 0.025
   tau_y2                        | 0.025
   A2_plus                       | 0.00001  
   A2_minus                      |-0.00001  
   A3_plus                       | 1e-3
   A3_minus                      |-1e-3
   A4_minusgaussmean             | 1.4 (from sum(exp(-(0:1/8:10)/tau_x)) ), 8Hz peak
   A4_minusgausswidth            | 0.17 (from diff of 8Hz and 6Hz values above)
   A4_plusgaussmean              | 1.4 
   A4_plusgausswidth             | 0.17
   T0                            | 0

```
