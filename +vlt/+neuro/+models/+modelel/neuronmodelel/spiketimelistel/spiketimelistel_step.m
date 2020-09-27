function spiketimelistel = spiketimelistel_step(spiketimelistel,modelstruct)
% SPIKETIMELISTEL_STEP - Performs no operation
%
%   SPIKETIMELISTEL = vlt.neuro.models.modelel.neuronmodelel.spiketimelistel.spiketimelistel_step(SPIKETIMELISTEL, MODELSTRUCT)
%
%   Just adds dT T.

spiketimelistel.T = spiketimelistel.T + spiketimelistel.dT;

