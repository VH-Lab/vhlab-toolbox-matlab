function [intfiremodelel] = intfireleakyel_step(intfiremodelel, modelstruct)
% INTFIRELEAKYEL_STEP - Compute a time step of an integrate and fire neuron modelel
%
%   INTFIRE = vlt.neuroscience.models.modelel.neuronmodelel.intfiremodels.intfireleakyel_step(INTFIREMODELEL, MODELSTRUCT)
%
%   Given a model leaky integrate and fire neurons in INTFIRE,
%   and a full list of model elements MODELSTRUCT, calculate the voltage
%   at the next step.
%
%   INTFIRE is a structure describing a leaky integrate and fire neuron:
%   --------------------------------------------------------------------
%   V_leak                  | Leak potential (volts)
%   Rm                      | Input resistance (Ohms)
%   Taum                    | Membrane time constant (seconds)
%   Area                    | Membrane area (mm^2)
%   V_reset                 | Reset potential (volts)
%   V_threshold             | Threshold value (volts)
%   V                       | The current voltage (volts, updated here)
%   synapse_list            | List of modelel numbers in MODELSTRUCT that
%                           |    correspond to synapses of this neuron
%   spiketimes              | The spike times of the
%                           |    intfire neuron (seconds, updated here)
%   V_spike                 | The voltage the neuron produces upon spiking

 % update all intfire neurons

  % if we just spiked, use reset voltage to calculate next step
if intfiremodelel.model.V==intfiremodelel.model.V_spike,
	intfiremodelel.model.V = intfiremodelel.model.V_reset;
end;

dVsyn = 0;
for j=1:length(intfiremodelel.model.synapse_list),
	modelelnum = intfiremodelel.model.synapse_list(j);
	dVsyn = dVsyn-(intfiremodelel.model.Rm/intfiremodelel.model.Area)*...
		modelstruct(modelelnum).model.G*(intfiremodelel.model.V-modelstruct(modelelnum).model.V_rev);
end;
dVdt = (-(intfiremodelel.model.V-intfiremodelel.model.V_leak)+dVsyn+...
		intfiremodelel.model.Ie*intfiremodelel.model.Rm)/intfiremodelel.model.Taum;

intfiremodelel.model.V = intfiremodelel.model.V + dVdt * intfiremodelel.dT;

intfiremodelel.T = intfiremodelel.T + intfiremodelel.dT;

if (intfiremodelel.model.V > intfiremodelel.model.V_threshold),  % we're spiking! reset voltage and stamp the spike
	intfiremodelel.model.V = intfiremodelel.model.V_spike;
	intfiremodelel.model.spiketimes(end+1) = intfiremodelel.T;
end;


