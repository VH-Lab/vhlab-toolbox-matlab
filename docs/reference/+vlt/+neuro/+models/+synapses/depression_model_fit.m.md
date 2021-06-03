# vlt.neuro.models.synapses.depression_model_fit

```
  DEPRESSION_MODEL - Compute parameters of model for synaptic depression
 
  [A0,F,FTAU,D,TAU,ERR]=DEPRESSION_MODEL(SPIKETIMES,SYNAPTIC_CURRENT,...
             FORDER,DORDER,[NUMATTEMPTS])
 
   Finds the best fit depression model with FORDER facilitating factors and
   DORDER depressing factors for the synaptic currents measured in the array
   SYNAPTIC_CURRENT at presynaptic spike times SPIKETIMES.  This program tries
   NUMATTEMPTS different random starting positions (default 10) and picks the
   best solution.
 
   See Varela, Sen, Gibson, Fost, Abbott, and Nelson, J. Neuroscience 17:7926-40
   (1997) and 'help vlt.neuro.models.synapses.depression_model_comp' for details of the model and parameters.
   ERR is the squared error over the whole data.

```
