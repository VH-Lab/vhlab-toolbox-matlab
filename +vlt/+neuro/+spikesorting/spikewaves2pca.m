function features = spikewaves2pca(waves, N, range)
% SPIKEWAVES2PCA - Compute first N principle components of spike waveforms
%
%  FEATURES = vlt.neuroscience.spikesorting.spikewaves2pca(WAVES, N, [RANGE])
%
%  Creates a set of "features" of the spike waveform WAVES by
%  calculating the values of the first N principle components.
%
%  Inputs:
%  WAVES: A NumSamples x NumChannels x NumSpikes list of spike
%   waveforms. 
%  N:  the number of principle components to include
%  Optional input:
%  RANGE: A 2 element vector with the START and STOP range to examine
%
%  Outputs:
%  FEATURES:   An N x NumSpikes list of features. 
%    

if nargin>2,
	waves = waves(range(1):range(2),:,:);
end;

waves = reshape(waves,size(waves,1)*size(waves,2),size(waves,3))';

[coeff,features] = princomp(waves);

features = features(:,1:N)';

