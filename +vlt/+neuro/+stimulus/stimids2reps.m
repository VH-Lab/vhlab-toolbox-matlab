function [reps, isregular] = stimids2reps(stimids, numstims)
% STIMIDS2REPS - Label each stimulus id with the repetition number for a regular stimulus sequence
%
%  [REPS, ISREGULAR] = vlt.neuro.stimulus.stimids2reps(STIMIDS, NUMSTIMS)
%
%  Given a list of STIMIDS that indicate an order of presentation,
%  and given that STIMIDS range from 1..NUMSTIMS, vlt.neuro.stimulus.stimids2reps returns a label
%  REPS, the same size as STIMIDS, that indicates the repetition
%  number if the stimuli were to be presented in a regular order. 
%  Regular order means that all stimuli 1...NUMSTIMS are shown in some order once,
%  followed by 1..NUMSTIMS in some order a second time, etc.
%
%  ISREGULAR is 1 if the sequence of STIMIDS is in a regular order. The last
%  repetition need not be complete for the stimulus presentation to be regular
%  (that is, if a sequence ended early it can still be regular).
%
% Example:
%    [reps,isregular] = vlt.neuro.stimulus.stimids2reps([1 2 3 1 2 3],3)
%       % reps = [1 1 1 2 2 2]
%       % isregular = 1
%

N_reps = numel(stimids) / numstims;

if 0 & round(N_reps)-N_reps>1e-6,
	error([int2str(length(stimids)) ' stimulus presentations of ' ...
		 int2str(numstims) ' stimuli ' ...
		' do not divide into a whole number of repetitions.']);
end;

reps = ceil( [1:length(stimids)]/numstims );

R = max(reps);

isregular = 1; % look for evidence that contradicts

for r=1:R-1,
	if ~vlt.data.eqlen( sort(stimids(find(reps==r))), 1:numstims),
		isregular = 0;
		return;
	end;
end

laststims = stimids(find(reps==R));

if ~all(  laststims<=numstims  | laststims >= 1   ) | ...  % are all stimid numbers in range?
		(numel(sort(laststims)) ~= numel(unique(laststims))), % does each stimulus presented so far appear at most once?
	isregular = 0;
end;

