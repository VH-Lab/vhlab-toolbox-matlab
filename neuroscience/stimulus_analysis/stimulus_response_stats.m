function stats = stimulus_response_stats(responses, varargin)
% STIMULUS_RESPONSE_SUMMARY - compute a stimulus response summary for timeseries data
% 
% STATS = STIMULUS_RESPONSE_STATS(RESPONSES,...)
%
% RESPONSES is a structure returned from STIMULUS_RESPONSE_SCALAR that has fields
% Field name:                   | Description
% --------------------------------------------------------------------------------
% stimid                        | Stimulus id number for each stimulus presentation
% responses                     | Computed scalar response for each stimulus presentation
% control_response              | Computed scalar response to a control stimulus (could be empty)
% controlstimnumber             | The stimulus number that was used as the control stimulus for
%                               |     each stimulus presentation
% parameters                    | A structure of parameters used in the computation
%                               |     (see HELP STIMULUS_RESPONSE_SCALAR)  
% 
% Computes a structure STATS with fields:
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
% control_mean                  | The mean response of TIMESERIES to the control stimulus, if one is
%                               |    specified with RESPONSES.parameters.control_stimulus
% control_stddev                | The standard deviation of the response of TIMESERIES to the control stimulus,
%                               |    if one is specified with RESPONSES.parameters.control_stimulus
% control_stderr                | The standard error of the mean of the responses of TIMESERIES to the control stimulus,
%                               |    if one is specified with RESPONSES.parameters.control_stimulus
% control_individual_responses  | The individual responses of TIMESERIES to the control stimulus, 
%                               |    if one is specified with RESPONSES.parameters.control_stimulus
%
% The behavior of the function can be modified by name/value pairs:
% Parameter (default value)     | Description: 
% ------------------------------------------------------------------------
% control_normalization ([])    | Normalize the stimulus response based on the prestimulus measurement.
%                               | [] or 0) No normalization 
%                               |       1) Subtract: Response := Response - PrestimResponse
%                               |       2) Fractional change Response:= ((Response-PrestimResponse)/PrestimResponse)
%                               |       3) Divide: Response:= Response ./ PreStimResponse
% 
%
% See also: NAMEVALUEPAIR

control_normalization = [];

assign(varargin{:});

stimid = unique(responses.stimid);
mean_responses = [];
stddev_responses = [];
stderr_responses = [];
individual_responses = {};
control_mean = [];
control_stddev = [];
control_stderr = [];
control_individual_responses = [];

for i=1:numel(stimid),
	examples = find(stim_onsetoffsetid(:,3)==stimid(i));
	individual_responses{i} = [];
	for j=1:numel(examples),
		stimulus_start = findclosest(timestamps,stim_onsetoffsetid(examples(j),1));
		stimulus_stop  = findclosest(timestamps,stim_onsetoffsetid(examples(j),2));

		if ~isempty(prestimulus_time),
			prestimulus_start = findclosest(timestamps, stim_onsetoffsetid(examples(j),1)-prestimulus_time);
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
	blank_stderr = nanstderr(blank_individual_responses);

end;

for i=1:numel(stimid),
	mean_responses = nanmean(individual_responses{i});
	stddev_responses = nanstd(individual_responses{i});
	stderr_responses = nanstderr(individual_responses{i});
end;


