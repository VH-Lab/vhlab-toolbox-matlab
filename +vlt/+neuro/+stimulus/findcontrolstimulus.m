function [controlstimnumber] = findcontrolstimulus(stimid, controlstimid)
% FINDCONTROLSTIMULUS - find the corresponding 'control' stimulus for a set of stimuli
%
% CONTROLSTIMNUMBER = vlt.neuro.stimulus.findcontrolstimulus(STIMID, CONTROLSTIMID)
%
% Given an array of STIMID values that indicate stimulus presentation, and an array of
% CONTROLSTIMID value(s) that indicate the identification number of a 'control' stimulus
% (such as a blank screen), this function finds the control stimulus id that corresponds
% to each STIMID presentation.
%
% If the stimulus presentation is regular (stimuli are presented from 1...numstims in 
% some order, followed by a second presentation of 1...numstims in some order, etc, with only
% a single control stimulus), then the control stimulus for each stimulus is the control
% stimulus that corresponds to the same stimulus repetition.
%
% If the stimulus presentation is not regular, then the 'closest' control stimulus is taken 
% to be the control stimulus; if 2 stimuli are equally close, then the first stimulus will be taken
% as the control stimulus.
%
% CONTROLSTIMNUMBER will always be returned as a column vector.
%
% See also: vlt.neuro.stimulus.stimids2reps
%
% Example:
%   stimid = [ 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 ];
%   cs=vlt.neuro.stimulus.findcontrolstimulus(stimid,3)'
%      % cs == [ 3 3 3 6 6 6 9 9 9 12 12 12 15 15 15 ]
%

if numel(controlstimid)==0,
	controlstimnumber = [];
	return;
end;

numstims = max(stimid);

[reps,isregular] = vlt.neuro.stimulus.stimids2reps(stimid,numstims);

controlstimnumber = [];

isregular = (isregular & (numel(controlstimid)==1));

if isregular,
	R = max(reps);
	for r=1:R-1,
		controlstimnumber = [controlstimnumber; (r-1)*numstims + repmat(find(stimid(find(reps==r))==controlstimid), numstims, 1)];
	end;
	% last trial may not be complete and still be regular
	if any(find(stimid(find(reps==R))==controlstimid)),
		controlstimnumber = [controlstimnumber; (R-1)*numstims + repmat(find(stimid(find(reps==R))==controlstimid), numstims, 1)];
	else,
		controlstimnumber = [controlstimnumber; (R-2)*numstims + repmat(find(stimid(find(reps==R-1))==controlstimid), numstims, 1)]; % closest possible
	end;
else,
	cs = ismember(stimid,controlstimid); % find all control stimuli
	cs_inds = find(cs);

	% first matrix will be repetitions of 1:numstims, the index of the stimulus; 
	% second matrix will be the index of a control stim, to calculate the difference in location
	cs_dist_matrix = abs(repmat(1:numel(stimid) , numel(cs_inds), 1) - repmat(cs_inds(:), 1, numel(stimid)));
	[m,controlstimnumber] = min(cs_dist_matrix,[],1);
	controlstimnumber = cs_inds(controlstimnumber);
	controlstimnumber = controlstimnumber(:);
end;


