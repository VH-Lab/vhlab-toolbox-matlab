function spiketimelistel = spiketimelistel_step(spiketimelistel,modelstruct)
% SPIKETIMELISTEL_STEP - Performs no operation
%
%   SPIKETIMELISTEL = SPIKETIMELISTEL_STEP(SPIKETIMELISTEL, MODELSTRUCT)
%
%   Just adds dT T.

spiketimelistel.T = spiketimelistel.T + spiketimelistel.dT;

