function [reps] = stimids2reps(stimids, numstims)
% STIMIDS2REPS - Label each stimulus id with the repetition number
%
%  REPS = STIMIDS2REPS(STIMIDS, NUMSTIMS)
%
%  Given a list of STIMIDS that indicate a psuedorandom order of presentation,
%  and given that STIMIDS range from 1..NUMSTIMS, STIMIDS2REPS returns a label
%  REPS, the same size as STIMIDS, that indicates the pseudorandom repetition
%  order.
%

N_reps = length(stimids) / numstims;

if 0 & round(N_reps)-N_reps>1e-6,
	error([int2str(length(stimids)) ' stimulus presentations of ' ...
		 int2str(numstims) ' stimuli ' ...
		' do not divide into a whole number of repetitions.']);
end;

reps = ceil( [1:length(stimids)]/numstims );


