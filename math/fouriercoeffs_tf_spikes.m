function f = fouriercoeffs_tf_spikes(spiketimes, tf, duration)
% FOURIERCOEFFS_TF_SPIKES  Fourier Transform of a spike train at a particular frequency.
%  
%  F = FOURIERCOEFFS_TF_SPIKES(SPIKETIMES, TF, DURATION)
%     This function returns the normalized fourier coefficient of 
%     a spike train that is defined by an array of SPIKETIMES with a 
%     duration DURATION.
% 
%     The function calculates (2/DURATION) * exp(-2*pi*sqrt(-1)*tf).
%     If tf is zero it returns the number of spikes times divided by the duration.
%     Modified from Sooyoung Chung, from Matteo Carandini, by Steve Van Hooser

if tf == 0
	f = numel(spiketimes)/duration;
else
	f = sum(exp(-2*pi*sqrt(-1)*tf*spiketimes)) * (2/duration);
end
