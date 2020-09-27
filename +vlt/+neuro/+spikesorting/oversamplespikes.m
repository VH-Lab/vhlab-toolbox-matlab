function [spikeshapesup, Tup] = oversamplespikes(spikeshapes, upsamplefactor, t)
% OVERSAMPLESPIKES - Oversample spike waveforms using spline interpolation
%
%  [SPIKESHAPESUP,TUP] = vlt.neuroscience.spikesorting.oversamplespikes(SPIKESHAPES, UPSAMPLEFACTOR, [T])
%
%  Inputs: SPIKESHAPES: an NxMxD matrix of spikes shapes; N is the number of
%             spikes, M is the number of samples per spike, and D is the number
%             of dimensions (e.g., D=1 for a single channel recording).
%          UPSAMPLEFACTOR: the number of times to vlt.signal.oversample (e.g., 5)
%          T: (optional), the relative time values within each spike sample
%             (shoudl be length M)
%
%  Outputs: SPIKESHAPESUP:  An NxM*UPSCALEFACTOR*D matrix with the upsampled
%          spikeshapes. N is the number of spikes, M*UPSCALEFACTOR is the number
%          of samples for each spike, and D is the number of dimensions. N,M, and D 
%          are unchanged from the input SPIKESHAPES.
%            TUP: If T is given, TUP is the upscaled time values for each spike.
%

[N,M,D] = size(spikeshapes); % N is number of spikes,  M is size of each spike shape, D is dimensions

Tup = [];

if nargin>2,
	Tup = interp1(1:M, t, linspace(1,M,M*upsamplefactor));
end;

 % we need to permute this so the samples values 1..M are on the first dimension so that interp1 can deal

spikeshapesup = interp1(1:M, permute(spikeshapes,[2 1 3]), linspace(1,61,61*5));

 % now let's change it back to the input format

spikeshapesup = permute(spikeshapesup,[2 1 3]);

