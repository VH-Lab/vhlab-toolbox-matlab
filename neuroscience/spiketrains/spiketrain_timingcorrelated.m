function [correlated_train,actualcorrelation] = spiketrain_timingcorrelated(input_train, c)
% SPIKETRAIN_TIMINGCORRELATED - Make spike train that is correlated in spike timing with an input spike train
%
%   [CORRELATED_TRAIN, CORR] = SPIKETRAIN_TIMINGCORRELATED(INPUT_TRAIN, C)
%
%  Creates a spike train that is correlated with the spike train INPUT_TRAIN.
%  INPUT_TRAIN should be a list of spike times in seconds.
%  C indicates how correlated the spike trains should be in terms of 1ms spike timing,
%  from 0 (all spikes different) to 1 (all spikes the same).  CORRELATED_TRAIN will have the
%  same number of spikes as INPUT_TRAIN.
%  
%  CORR is the actual correlation that was achieved.  This may differ slightly from the requested
%  correlation if the fraction correlation requested times the number of spikes is not an integer.

resolution = 0.001;  % 1ms resolution

bins = input_train(1):resolution:input_train(end);

input_train_bins = spiketimes2bins(input_train,bins);

correlated_train = input_train;

 % now shift (1-C) * number of spikes by some random amount

actual_correlation = 1;

correlated_spikes_locations = 1:length(input_train);

loops = 0;

while actual_correlation > c,
	% calculate fraction of spikes to be moved
	difference = actual_correlation - c;
	N = ceil(difference*length(input_train)-1e-14);
	r = randperm(length(correlated_spikes_locations));
	try,
	inds_to_move = correlated_spikes_locations(r(1:N));
	catch, keyboard;
	end;
	
	% generate new spike times, for now use uniform distribution
	newspiketimes = [];
	while length(newspiketimes)~=length(inds_to_move),
		newspikes = generate_random_data(N,'Uniform',input_train(1),input_train(end));
		newspiketimes = bins(find(spiketimes2bins(newspikes,bins))); % might be more than 1 spike per bin in some cases
		if length(newspiketimes)<N,  % if we had bin collisions just do the whole thing again
			%this is lame, should just replace spikes that collided
			newspiketimes = [];
		end;
	end;
	correlated_train(inds_to_move(1:length(newspiketimes))) = newspiketimes;

	correlated_train_bins = spiketimes2bins(correlated_train,bins);
	correlated_train = bins(find(correlated_train_bins))+0.1*resolution;  % reassign any slightly off times to be right on the bin times
	corr = (correlated_train_bins.*input_train_bins)>0;
	correlated_spikes_times = bins(find(corr))+0.1*resolution;
	correlated_spikes_locations = [];
	for ia=1:length(correlated_spikes_times),
		myloc = find(abs(correlated_train-correlated_spikes_times(ia))<0.5*resolution);
		if ~isempty(myloc),
			correlated_spikes_locations(end+1) = myloc(end);
		end;
	end;
	%[~,ia,ib] = intersect(correlated_train,correlated_spikes_times);
	%correlated_spikes_locations = ia;
	actual_correlation = sum(corr)/length(input_train);
	loops = loops + 1;
	if loops>100,
		disp(['spiketrain_timingcorrelated seems to be in an endless loop']);
		keyboard;
	end;
end;

correlated_train = sort(correlated_train);
