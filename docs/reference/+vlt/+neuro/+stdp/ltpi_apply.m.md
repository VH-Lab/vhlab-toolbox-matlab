# vlt.neuro.stdp.ltpi_apply

```
  LTPI_APPLY Spike-timing dependent-plasticity for calculating changes in synaptic weights
 
     WEIGHT = vlt.neuro.stdp.ltpi_apply(SPIKETIMES_PRE, SPIKETIMES_POST)
 
   Calculates the change in synaptic weight due to the "veto" long 
   term potentiation of inhibition rule based on the experimental
   data of Maffei et. al 2006 (Nature) and on the equations in
   Bourjaily and Miller 2011 (Frontiers in Computational Neuroscience).
   
       For all presynaptic (inhibitory) spikes, we look to see if there
       is a postsynaptic spike in the interval [t_pre-tau_minus,
       tpre+tau_plus]. If so, there is an inhibitory potentiation:
       weight = weight + dIW
 
   WEIGHT is a factor that indicates how the maximumal
   conductance is modified.In Song and Abbott (2001), the synaptic 
   conductance was modified by the following forumla:
   G -> G + G_max * WEIGHT
 
   Only spikes that occur at or after the time T0 will be examined for STDP.
   By default, T0 is 0.  (One could use this to restrict the influence
   of STDP to spike pairs where at least one member of the pair occurs
   after a particular time.)
 
   Normally, we do not know what additional spikes are coming in the future.
   The code assumes that we only know up to time of the latest spike in
   the 2 trains. (That is, if an inhibitory spike is the last spike to occur,
   and it has no postsynaptic partners, then we do not yet know if it will
   generate a potentiation event.  One can explicitly set T1 to indicate
   the latest time that we have information for (which might be later than
   the latest spike time).
  
   
   
   
   The parameters of the synapse can be varied by providing additional 
   inputs as name, value pairs. The names and values that are default are
   shown here. For example,
     WEIGHT = vlt.neuro.stdp.ltpi_apply(SPIKETIMES_PRE, SPIKETIMES_POST, 'tau_plus',0.050)
 
   Parameter name:               | default value
   ------------------------------|-----------------------------
   tau_plus                      | 0.020 (units are same as spiketimes)
   tau_minus                     | 0.020
   dIW                           | 0.001 (a 1% change)
   T0                            | 0
   T1                            | max(spiketimes_pre(end),spiketimes_post(end))

```
