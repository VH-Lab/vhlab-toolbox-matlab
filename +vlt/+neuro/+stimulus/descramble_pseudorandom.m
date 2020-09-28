function [response] = descramble_pseudorandom(stim_responses, stim_values)
% DESCRAMBLE_PSEUDORANDOM - Descramble responses to pseduorandomly varied stimuli
%
%   [RESPONSE_CURVE] = vlt.neuro.stimulus.descramble_pseudorandom(STIM_RESPONSES, STIMVALUES)
%
%  Descrambles responses to pseudorandomly varied stimuli.
%
%  Inputs:  
%       STIM_RESPONSES:        |  Responses to individual stimuli (1xN or Nx1 list)
%       STIMVALUES:            |  The stimulus value (or, could be stimulus ID)
%                              |    for each of the N presented stimuli (1xN or Nx1)
%                              |    To indicate that a stimulus is a "blank" or "control"
%                              |    provide NaN for its value.
%
%  Output: RESPONSE_CURVE is a structure with the following fields:
%        curve        |  4xN matrix, where N is the number of distinct
%                     |     stimuli; the first row has the stim values
%                     |     the second row has the mean responses in 
%                     |     spikes per time unit of STIMTIMES_ON/OFF,
%                     |     the third row has the standard deivation of
%                     |     these spike rates, and the fourth row has
%                     |     the standard error.
%        blank        |  1x3 vector with the mean, standard deviation, and
%                     |     standard error.
%        inds         |  1xN cell array; each value inds{i} has the individual
%                           responses for the ith repetition of stimulus i
%        blankinds    |  1xM vector with individual responses to the blank stimulus
%        indexes      |  2xnum_stims Indicates where the nth stim is represented in
%                     |     in inds (first column is stimid, second column is entry
%                     |     number in vector inds{stimid})

stimvaluelist = unique(stim_values);

 % make sure only a single NaN; unique will not return a single NaN
z = isnan(stimvaluelist);
if any(z), % remove NaNs and append a single one
	stimvaluelist=stimvaluelist(z==0);
	stimvaluelist(end+1) = NaN;
end;

response.inds = {};
response.indexes = [];
for i=1:length(stimvaluelist),
	response.inds{i} = []; % initialize each entry as empty
end;

for i=1:length(stim_responses),
	if ~isnan(stim_values(i)),
		stimid = find(stim_values(i)==stimvaluelist);
	else, % we know it's the last one
		stimid = length(stimvaluelist);
	end;
	response.inds{stimid}(end+1) = stim_responses(i);
	response.indexes(end+1,[1 2]) = [stimid length(response.inds{stimid})];
end;

meanresps = [];
stddevs = [];
stderrs = [];

for stimid=1:length(stimvaluelist),
	meanresps(stimid) = mean(response.inds{stimid});
	stddevs(stimid) = std(response.inds{stimid});
	stderrs(stimid) = vlt.stats.stderr(response.inds{stimid}');
end;

response.curve = stimvaluelist;
response.curve(2,:) = meanresps;
response.curve(3,:) = stddevs;
response.curve(4,:) = stderrs;

blankindex = find(isnan(stimvaluelist));

if ~isempty(blankindex),
	response.blankinds = response.inds{blankindex};
	response.curve = response.curve(:,find(~isnan(stimvaluelist)));
else,
	response.blankinds = [];
end;

response.blank = [mean(response.blankinds) std(response.blankinds) vlt.stats.stderr(response.blankinds')];
if length(response.blank)==2,
	response.blank(3) = NaN;
end;
