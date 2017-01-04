function [ministruct] = minidetection(data, si, varargin)
% MINIDETECTION - Detect minis from noise
%
%  MINISTRUCT = MINIDETECTION(DATA, SI, ...)
%
%  Finds spontaneous miniature evoked potential/current events in a recorded trace.
%
%  Inputs:
%  DATA should be an R x S matrix, where each row has a data set, and S is the number
%  of samples in each recording. The sampling interval for the records is specified
%  by SI.
%
%  Additional modifications can be provided by specifying parameters as name/value pairs:
%  Parameter (default)     | Description
%  -----------------------------------------------------------------------------
%  do_detrend_median (1)   | Should we detrend the data using DETREND_MEDIAN?
%  detrend_timescale (0.5) | Over what timescale? (in seconds)
%  estimate_std_median (1) | Should we use the median method (STD_MEDIAN) to estimate 
%                          |   standard deviation (1) or the standard method
%                          |   of calling STD (0)?
%  minisimulation (see txt)| What mini detection simulation should we use to 
%                          |  determine optimal threshold? Default is
%                          |  'minidetectionsimulation_guassian'
%                          |  This file must be on the path and it must be the
%                          |  results of MINIDETECTIONSIMULATION
%  t_before (-0.020)       | Time before each mini to grab (in seconds, rounded to
%                          |  nearest sample based on SI)
%  t_after (0.100)         | Time after each mini to grab (in seconds, rounded to
%                          |  nearest sample based on SI)
%  
%
%  Outputs:
%  MINISTRUCT is a structure with the following fields:
%  Fieldname:            | Description
%  -----------------------------------------------------------------------------
%  frequency             | The overall average frequency of detected mini events
%  amplitude             | The overall average amplitude of detected mini events
%  intereventintervals   | The time intervals between detected mini events
%  wavetime              | A time axis for plotting mini waveforms
%  meanminiwaveform      | The grand mean mini waveform
%  miniamplitudes        | The amplitude for each mini
%  row_minisamples{}     | For each row of DATA, the samples that correspond to mini peaks
%  row_minitimes{}       | For each row of DATA, the times (from beginning of row DATA)
%                        |   that correspond to peaks
%  row_miniwaveforms{}   | For each row of DATA, the waveform associated with each mini 
%  row_miniamplitudes{}  | For each row of DATA, the amplitude associated with each mini
%
%
%  See also:

do_detrend_median = 1;
detrend_timescale = 0.5;
estimate_std_median = 1;
ministimulation = 'minidetectionsimulation_gaussian';
t_before = -0.020;
t_after = 0.100;

assign(varargin{:});

[r,s] = size(data);

if do_detrend_median,
	for R=1:r,
		data(R,:) = detrend_median(data(R,:),si,detrend_timescale);
	end;
end;

 % now estimate noise

noise_m = [];

for R=1:r,
	if estimate_std_median,
		noise_m(R) = std_median(data(R,:));
	else,
		noise_m(R) = std(data(R,:));
	end;
end;

detection_params = load([minisimulation]);

samples_before = round(t_before/si);
samples_after = round(t_after/si);
samples_per_mini = samples_after - samples_before + 1;

[dummy,best_threshold] = min([detection_params.stats.total_error_rate]);

threshold = stats(best_threshold).threshold * mean(noise_m);

for R=1:r,
	matched = conv(data(R
	[index_up, index_down, row_minisamples{R}] = threshold_crossings_epochs(data(R,:), threshold);
	row_minitimes{R} = (minisamples-1) * si;
	row_miniwaveforms{R} = data(R, repmat(samples_before:samples_after,length(row_minisamples{R}),1) + repmat(row_minisamples{R}(:), samples_per_mini, 1));
	for j=1:length(row_miniwaveforms{R}),

	end;

end

%  row_minisamples{}     | For each row of DATA, the samples that correspond to mini peaks
%  row_minitimes{}       | For each row of DATA, the times (from beginning of row DATA)
%                        |   that correspond to peaks
%  row_miniwaveforms{}   | For each row of DATA, the waveform associated with each mini
%  row_miniamplitudes{}  | For each row of DATA, the amplitude associated with each mini

