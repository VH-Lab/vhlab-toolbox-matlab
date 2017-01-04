function features = spikewaves2Npointfeature(waves, samplelist)
% SPIKEWAVES2NPOINTFEATURE - Select samples from spike waves
%
%   FEATURES = SPIKEWAVES2NPOINTFEATURE(WAVES, SAMPLELIST)
%
%  Creates a set of "features" of the spike waveform WAVES by
%  grabbing samples at the locations SAMPLELIST.
%
%  Inputs:
%  WAVES: A NumSamples x NumChannels x NumSpikes list of spike
%   waveforms. 
%  SAMPLELIST:  A list of samples [S1 S2 ...] at which to sample
%   the spike waveforms on each channel.
%
%  Outputs:
%  FEATURES:   A (NumSampleList*NumChannel) x NumSpikes list of
%   features.  Each spike waveform is sampled on each channel at 
%   the sample offsets in SAMPLELIST.  Each column has the sample
%   values on the first channel, followed by the second, and so on.
%    

features = reshape(waves(samplelist,:,:),length(samplelist)*size(waves,2),size(waves,3));
