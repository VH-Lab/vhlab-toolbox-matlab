function [pre,post] = sjostrom_spiketrain(deltaT, frequency, N)
% SJOSTROM_SPIKETRAIN - Generate a pre/post synaptic spiketrain pair from Sjostrom 2001
%
%   [PRE,POST] = SJOSTROM_STPD(deltaT, frequency, N)
%
%   Generates a list of N pre- and post-synaptic spike times 
%   that have spacing deltaT (that is, the pre-synaptic cell fires
%   deltaT before the post-synaptic cell). Pre- and postsynaptic 
%   spikes are generated at a rate of frequency Hz.  
%
%   The first spike (whether it is pre- or post-synaptic)
%   will occur at time 0.
%
%   Example:
%     % Generate pre- and post-synaptic spiketrains to pair
%     %  with 10ms pre-before-post firing at 10Hz, with 60 repetitions
%     [PRE,POST] = vlt.neuro.stdp.sjostrom_spiketrain(0.010, 10, 60)
%
%    

pre = 0:1/frequency:(N-1)/frequency;
post = pre+deltaT;

if post(1)<0,
	pre = pre - post(1);
	post = post - post(1);
end;


