function response = stimulus_response_summary(timeseries, timestamps, stim_onsetoffsetid, varargin)
% STIMULUS_RESPONSE_SUMMARY - compute a stimulus response summary for timeseries data
% 
% RESPONSE = vlt.neuroscience.stimulus_analysis.stimulus_response_summary(TIMESERIES, TIMESTAMPS, STIM_ONSETOFFSETID, ...)
%
% STIM_ONSETOFFSETID is a variable that describes the stimulus history. Each row should
% contain [stim_onset_time stim_offset_time stimid] where the times are in units of TIMESTAMPS (s).
% 
% Computes a structure RESPONSE with fields:
% Field name:                   | Description:
% ------------------------------------------------------------------------
% stimid                        | The stimulus id of each stimulus observed
% mean_responses                | The mean response of TIMESERIES across stimulus
%                               |     presentations [stimid(1) stimid(2) ...]
% stddev_responses              | The standard deviation of TIMESERIES across stimulus
%                               |     presentations [stimid(1) stimid(2) ...]
% stderr_responses              | The standard error of the mean of TIMESERIES
%                               |     across stimulus presentations [stimid(1) stimid(2) ...]
% individual_responses          | A cell array with the individual responses to each stimulus
%                               |    individual_responses{i}(j) has the jth response to stimulus with stimid(i)
% blank_mean                    | The mean response of TIMESERIES to the blank stimulus, if one is
%                               |    specified with 'blank_stimid'
% blank_stddev                  | The standard deviation of the response of TIMESERIES to the blank stimulus,
%                               |     if one is specified with 'blank_stimid'
% blank_stderr                  | The standard error of the mean of the responses of TIMESERIES to the blank stimulus,
%                               |     if one is specified with 'blank_stimid'
% blank_individual_responses    | The individual responses of TIMESERIES to the blank stimulus, if one 
%                               |     is specified with 'blank_stimid'
%
% The behavior of the function can be modified by name/value pairs:
% Parameter (default value)     | Description: 
% ------------------------------------------------------------------------
% freq_response (0)             | The frequency response to measure using FFT of TIMESERIES. Can be
%                               |     0 (to use the mean response), or a number corresponding
%                               |     to the frequency to analyze. Can also be a vector
%                               |     the same size as the number of stimuli to indicate
%                               |     the frequency to be used for each stimulus (freq_response(stimid(i)).
%                               |     For example, to compute the response at the fundamental stimulus
%                               |     frequency (F1) when that frequency is 1 Hz, pass 1 for 'freq_response'.
% blank_stimid ([])             | Use this to pass the identity (or identities) of a 'blank' stimulus
%                               |     (some sort of control stimulus; in vision, this is often presenting
%                               |     a blank screen for same duration as the other stimuli.)
%                               |     The 'blank' stimulus is not counted among the stimuli in 'stimid'
% prestimulus_time ([])         | Calculate a baseline using a certain amount of TIMESERIES signal during
%                               |     the pre-stimulus time given here. 
% prestimulus_normalization ([])| Normalize the stimulus response based on the prestimulus measurement.
%                               | [] or 0) No normalization 
%                               |       1) Subtract: Response := Response - PrestimResponse
%                               |       2) Fractional change Response:= ((Response-PrestimResponse)/PrestimResponse)
%                               |       3) Divide: Response:= Response ./ PreStimResponse
% 

freq_response = 0;
blank_stimid = [];

prestimulus_time = [];
prestimulus_normalization = [];

vlt.data.assign(varargin{:});

stimid = [];
mean_responses = [];
stddev_responses = [];
stderr_responses = [];
individual_responses = {};
blank_mean = [];
blank_stddev = [];
blank_stderr = [];
blank_individual_responses = [];

sample_interval = median(diff(timestamps));
sample_rate = 1/sample_interval;

if ~isempty(prestimulus_normalization),
	if ischar(prestimulus_normalization),
		prestimulus_normalization = lower(prestimulus_normalization);
	end
end;

stimid = unique(stim_onsetoffsetid(:,3));


for i=1:numel(stimid),
	examples = find(stim_onsetoffsetid(:,3)==stimid(i));
	individual_responses{i} = [];
	for j=1:numel(examples),
		stimulus_start = vlt.data.findclosest(timestamps,stim_onsetoffsetid(examples(j),1));
		stimulus_stop  = vlt.data.findclosest(timestamps,stim_onsetoffsetid(examples(j),2));

		if ~isempty(prestimulus_time),
			prestimulus_start = vlt.data.findclosest(timestamps, stim_onsetoffsetid(examples(j),1)-prestimulus_time);
		else,
			prestimulus_here = [];
		end;

		% now calculate response

		freq_response_here = freq_response;
		if numel(freq_response)>1,
			freq_response_here = freq_response_here(stimid(i));
		end;
		if freq_response_here==0,
			response_here = nanmean(timeseries(stimulus_start:stimulus_stop));
			if ~isempty(prestimulus_time),
				prestimulus_here = nanmean(timeseries(prestimulus_start:stimulus_start-1));
			end;
		else,
			response_here = fourier_coeffs_tf2( timeseries(sample_start:sample_stop), freq_response_here, sample_rate);
			if ~isempty(prestimulus_time),
				prestimulus_here = fourier_coeffs_tf2(timeseries(prestimulus_start:stimulus_start-1), freq_response_here, ...
					sample_rate);
			end;
		end;

		if ~isempty(prestimulus_normalization),
			switch prestimulus_normalization,
				case {0,'none'},
					% do nothing,
				case {1,'subtract'} % subtract
					response_here = response_here - prestimulus_here;
				case {2,'fractional'},
					response_here = (response_here - prestimulus_here)./prestimulus_here;
				case {3,'divide'},
					response_here = response_here./prestimulus_here;
			end; % switch
		end;

		individual_responses{i}(j,1) = response_here;
	end;
end

if ~isempty(blank_stimid),  % remove blank stims from list of stimids
	blankstims = find(ismember(stimid,blank_stimid));

	blank_individual_responses = individual_responses(blankstims);
	blank_individual_responses = cat(1,blank_individual_responses{:}); % make a big column vector
	individual_responses = individual_responses(~blankstims);
	stimid = stimid(~blankstims);

	blank_mean = nanmean(blank_individual_responses);
	blank_stddev = nanstd(blank_individual_responses);
	blank_stderr = vlt.data.nanstderr(blank_individual_responses);

end;

for i=1:numel(stimid),
	mean_responses = nanmean(individual_responses{i});
	stddev_responses = nanstd(individual_responses{i});
	stderr_responses = vlt.data.nanstderr(individual_responses{i});
end;


