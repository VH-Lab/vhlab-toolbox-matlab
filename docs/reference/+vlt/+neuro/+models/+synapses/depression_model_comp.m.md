# vlt.neuro.models.synapses.depression_model_comp

   vlt.neuro.models.synapses.depression_model_comp-Computes synaptic currents for Varela depression model
 
     SYNCURRS = vlt.neuro.models.synapses.depression_model_comp(SPIKETIMES,A0,F,FTAU,D,DTAU)
 
   Computes synaptic currents for a facilitating and/or depressing synapse.
   Presynaptic spike times are given in SPIKETIMES, and the unfacilitated,
   undepressed amplitude of the synapse is A0.
 
   Synaptic currents are modeled as A = A0*F1*...*FN*D1*...*DN,
     where F1...FN are facilitating factors and D1...DN are depressing
   factors.
 
   After each presynaptic spike, Fi -> Fi + fi, where fi is a positive
   number, and Fi decays back to 1 with time constant fitau.
   Input argument F is an array containing fi, and the length of F determines
   the number of facilitating factors (use empty for none).  FTAU is an array
   of the same length of F and contains the time constants fitau.
 
   After each presynaptic spike, Di -> Di * di, where 0 < di <= 1, and Di
   decays back to 1 with time constant ditau.  Input argument D is an array
   containing di, and the length of D determines the number of facilitating
   factors (use empty for none).  DTAU is an array of the same length of D
   and contains the time constants ditau.
 
   See Varela,Sen,Gibson,Fost,Abbott,and Nelson,J.Neurosci.17:7926-40,1997.
