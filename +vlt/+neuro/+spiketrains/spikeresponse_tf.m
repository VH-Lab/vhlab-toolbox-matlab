function [response] = spikeresponse_tf(stimtimes_on, stimtimes_off, stim_values, spiketimes, binsize, frequency)
%
%  [RESPONSE_CURVE] = vlt.neuro.spiketrains.spikeresponse_tf(STIMTIMES_ON, STIMTIMES_OFF, STIM_VALUES,
%         SPIKETIMES, BINSIZE, FREQUENCY)
%
%  Return a response curve of responses to the presentation
%  of multiple stimuli. In this function, only the portion of the
%  response that is modulated at temporal fequency FREQUENCY is
%  reported.  Spike trains are first discretized into bins with
%  binsize BINSIZE.
%  
%  The onset time of each stimulus should be in the vector STIMTIMES_ON,
%  and the offset time of each stimulus should be in the vector
%  STIMTIMES_OFF. STIM_VALUES should be a vector list with the value
%  of the stimulus parameter for each stimulus that is indicated in
%  STIMTIMES_ON and STIMTIMES_OFF. One can specify that a stimulus is
%  "BLANK" or "CONTROL" by giving NaN as the STIM_VALUE for that stimulus.  
%  SPIKETIMES are the spike times of a neuron in the %  same time
%  units as STIMTIMES_ON and STIMTIMES_OFF. 
%
%  Output:
%    RESPONSE_CURVE is a struture with the following fields:
%       curve        |  4xN matrix, where N is the number of distinct
%                    |     stimuli; the first row has the stim values
%                    |     the second row has the mean responses in 
%                    |     spikes per time unit of STIMTIMES_ON/OFF,
%                    |     the third row has the standard deivation of
%                    |     these spike rates, and the fourth row has
%                    |     the standard error.
%       blank        |  1x3 vector with the mean, standard deviation, and
%                    |     standard error.
%       inds         |  1xN cell array; each value inds{i} has the individual
%                          responses for the ith repetition of stimulus i
%       blankinds    |  1xM vector with individual responses to the blank stimulus
%       indexes      |  2xnum_stims Indicates where the nth stim is represented in
%                    |     in inds (first column is stimid, second column is entry
%                    |     number in vector inds{stimid})
%
%    %  See help vlt.neuro.mledenoise.gaindriftexample for a description of the spike responses it generates.
%    [spiketimes,r,t,stimon,stimoff,stimids,g]=vlt.neuro.mledenoise.gaindriftexample('gain_amplitude',0,'gain_offset',1,...
%		'response_tf',4);
%    % Step 2, use vlt.neuro.spiketrains.spikeresponse to calculate the actual responses
%    response_curve = vlt.neuro.spiketrains.spikeresponse_tf(stimon,stimoff,stimids,spiketimes,0.001,4);
%    % see if the average spikes are equal to what we expect from vlt.neuro.mledenoise.gaindriftexample's help
%    abs(response_curve.curve(2,:)),
%
%  See also: vlt.neuro.spiketrains.spikeresponse
%  

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

for i=1:length(stimtimes_on),
        if ~isnan(stim_values(i)),
                stimid = find(stim_values(i)==stimvaluelist);
        else, % we know it's the last one
                stimid = length(stimvaluelist);
        end;
	dt = stimtimes_off(i) - stimtimes_on(i);
	T = 0:binsize:dt;
	spikecounts = vlt.neuro.spiketrains.spiketimes2bins(spiketimes-stimtimes_on(i),T);
	if frequency==0, 
		f = sum(spikecounts)/dt;
	else,
		f = vlt.math.fouriercoeffs_tf(spikecounts(:)/binsize,... % dividing by binsize converts to rate
				frequency,...
				1/binsize);  % 1/binsize is the sampling frequency in Hz
	end;
	response.inds{stimid}(end+1) = f;
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

response.blank = [mean(response.blankinds(:)) std(response.blankinds(:)) vlt.stats.stderr(response.blankinds(:))];
if length(response.blank)==2,
	response.blank(3) = NaN;
end;


