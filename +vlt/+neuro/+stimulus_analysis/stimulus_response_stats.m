function stats = stimulus_response_stats(responses, varargin)
% STIMULUS_RESPONSE_SUMMARY - compute a stimulus response summary for timeseries data
% 
% STATS = vlt.neuro.stimulus_analysis.stimulus_response_stats(RESPONSES,...)
%
% RESPONSES is a structure returned from vlt.neuro.stimulus_analysis.stimulus_response_scalar that has fields
% Field name:                   | Description
% --------------------------------------------------------------------------------
% stimid                        | Stimulus id number for each stimulus presentation
% response                      | Computed scalar response for each stimulus presentation
% control_response              | Computed scalar response to a control stimulus (could be empty)
% controlstimnumber             | The stimulus number that was used as the control stimulus for
%                               |     each stimulus presentation
% parameters                    | A structure of parameters used in the computation
%                               |     (see HELP vlt.neuro.stimulus_analysis.stimulus_response_scalar)  
% 
% Computes a structure STATS with fields:
% Field name:                   | Description:
% ------------------------------------------------------------------------
% stimid                        | The stimulus id of each stimulus observed
% mean                          | The mean response of TIMESERIES across stimulus
%                               |     presentations [stimid(1) stimid(2) ...]
% stddev                        | The standard deviation of TIMESERIES across stimulus
%                               |     presentations [stimid(1) stimid(2) ...]
% vlt.stats.stderr                        | The standard error of the mean of TIMESERIES
%                               |     across stimulus presentations [stimid(1) stimid(2) ...]
% individual                    | A cell array with the individual responses to each stimulus
%                               |    individual_responses{i}(j) has the jth response to stimulus with stimid(i)
% control_mean                  | The mean response of TIMESERIES to the control stimulus, if one is
%                               |    specified with RESPONSES.parameters.control_stimulus
% control_stddev                | The standard deviation of the response of TIMESERIES to the control stimulus,
%                               |    if one is specified with RESPONSES.parameters.control_stimulus
% control_stderr                | The standard error of the mean of the responses of TIMESERIES to the control stimulus,
%                               |    if one is specified with RESPONSES.parameters.control_stimulus
% control_individual            | The individual responses of TIMESERIES to the control stimulus, 
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
% See also: vlt.data.namevaluepair

control_normalization = [];

vlt.data.assign(varargin{:});

stimid = setdiff(unique(responses.stimid),responses.parameters.control_stimid);
mean_responses = [];
stddev_responses = [];
stderr_responses = [];
individual = {};
control_mean = [];
control_stddev = [];
control_stderr = [];
control_individual = {};

if isempty(control_normalization),
	control_normalization = 0;
end;
if ischar(control_normalization),
	control_normalization = lower(control_normalization);
end;

for i=1:numel(stimid),
	examples = find(responses.stimid==stimid(i));

	switch control_normalization,
		case {0,'none'},
			% do nothing,
			individual{i} = responses.response(examples);
			if ~isempty(responses.control_response),
				control_individual_responses{i} = responses.control_response(examples);
			end;
		case {1,'subtract'} % subtract
			individual{i} = responses.response(examples) - responses.control_response(examples);
		case {2,'fractional'},
			individual{i} = (responses.response(examples) - responses.control_response(examples))./responses.control_response(examples);
		case {3,'divide'},
			individual{i} = responses.response(examples)./responses.control_response(examples);
	end; % switch

	mean_responses(i) = nanmean(individual{i}(:));
	stddev_responses(i) = nanstd(individual{i}(:));
	stderr_responses(i) = vlt.data.nanstderr(individual{i}(:));

	if ~isempty(control_individual),
		control_mean_responses(i) = nanmean(control_individual{i}(:));
		control_stddev_responses(i) = nanstd(control_individual{i}(:));
		control_stderr_responses(i) = vlt.data.nanstderr(control_individual{i}(:));
	end;
end

stats = struct('mean',mean_responses,'stddev',stddev_responses,'vlt.stats.stderr',stderr_responses);

stats = vlt.data.structmerge(stats, vlt.data.var2struct('individual', 'control_mean','control_stddev','control_stderr','control_individual'));

