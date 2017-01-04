function [samples_in,sample_indexes, samples_out] = samplesinepochs(sample_numbers, epochstartsamples, epochstart, epochstop)
% SAMPLESINEPOCHS - Identify samples that are within the given recording epochs
%
%    [SAMPLES_IN,SAMPLEINDEXES,SAMPLESNOTINEPOCHS] = SAMPLESINEPOCHS(SAMPLE_NUMBERS, EPOCHSTARTSAMPLES, EPOCHSTART, EPOCHSTOP)
%
%    Given a list of SAMPLE_NUMBERS, determines which are in a set of epochs and returns them
%    in SAMPLES_IN and returns the index numbers of these samples in SAMPLEINDEXES.
%
%    The recording epochs are specified by start sample numbers: EPOCHSTARTSAMPLES
%    is an array with the sample number that begins each epoch.
%
%    EPOCHSTART is the Epoch number we want to start including.
%    EPOCHSTOP is the last Epoch number we want to stop including.
%    
%    Example:  
%         SN = [ 1 2 3 4 5 6 7 8 9 10 ];
%         EpStartSamples = [1 5 9]; % epochs start at samples 1, 5, and 9
%         EpStart = 1;
%         EpStop = 2;
%         SI = SAMPLESINEPOCHS(SN, EpStartSamples,EpStart,EpStop)
%            % SI = [ 1 2 3 4 5 6 7 8 ] % samples in first 2 epochs
%

if isempty(sample_numbers),
	samples_in = [];
	samples_out = [];
	sample_indexes = [];
	return;
end;

epochstartsamples(end+1) = Inf;

si = (sample_numbers >= epochstartsamples(epochstart) & sample_numbers < epochstartsamples(epochstop+1));
sample_indexes = find(si);
samples_in = sample_numbers(sample_indexes);
samples_out = sample_numbers(find(~si));
