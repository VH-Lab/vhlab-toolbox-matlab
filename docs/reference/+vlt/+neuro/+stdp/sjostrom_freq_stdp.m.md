# vlt.neuro.stdp.sjostrom_freq_stdp

  SJOSTROM_FREQ_STDP - Sjostrom's data on plasticity vs. spike rate and timing 
 
    A = SJOSTROM_FREQ_STPD
 
    Returns data from Sjostrom et al. 2001, showing how the change in
    synaptic weight depends on frequency and timing.
  
    The data represent the synaptic change (in percent (I think)) as a function
    of 60 repetitions of pairings of pre-synaptic and postsynaptic spikes.
    
    The first column of the table indicates the frequency used in the experiment.
    The second column is the synaptic change when pre-before-post firing with a gap
        of 10ms was used.
    The third column is the standard error of the quantity in column 2.
    The fourth column is the synaptic change when post-before-per firing with a gap
        of 10ms was used.
    The fifth column is the standard error of the quantity in column 4.
 
    A = [ ...
 	0.1 -0.04 0.05 -0.29 0.08; 
 	10   0.14 0.1  -0.41 0.11; 
 	20   0.29 0.14 -0.34 0.1; 
 	40   0.53 0.11  0.56 0.32; 
 	50   0.56 0.26  0.75 0.19; ];
