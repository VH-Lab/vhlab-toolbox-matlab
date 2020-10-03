function data_out = removespikes(data, T, spiketimes, varargin)
% REMOVESPIKES - Remove spikes from voltage trace w/ linear interpolation
%
%   DATA_OUT = vlt.signal.removespikes(DATA, T, SPIKETIMES, ...)
%
%   Inputs:
%     DATA - The voltage data values (time series data) (must be bigger than
%               3 data points)
%     T    - Either the time of each data sample in DATA, or a 1x2 vector
%              with T(1) as the time of the first sample, and T(2) as the 
%              sample interval. For both methods, the samples are assumed to be
%              taken at regular sample intervals.
%     SPIKETIMES - Spike times (in same time units as T)   
%   Outputs:
%     DATA_OUT - The data with the spikes removed and filled in by linear
%       inpolation
%
%   Optional inputs:
%     One can provide additional inputs to this function with name/value
%     pairs. For example, to change the time T0 before each spike that is 
%     removed or the time T1 after each spike that is removed, use:
%   DATA_OUT = vlt.signal.removespikes(DATA, T, SPIKETIMES, 'T0', t0, 'T1', t1)
%
%   Parameters that can be modified:
%   Name (default value):            | Meaning
%   -------------------------------------------------------------------
%   SPIKE_INTERP_METHOD (1)          | If 1, then use linear interpolation (via Matlab function INTERP1)
%   SPIKE_BEGINNING_END_METHOD (1)   | If 1, then use pre-and post spike time to find the base
%                                    |    of the spike before and after the spike occurs
%                                    |    (uses parameters t0 and t1 below)
%   t0 (0.003)                       | If 1x1: Time before spike to remove (in sec)
%                                    |    The sample closest to this time is
%                                    |    chosen
%                                    | If 1x2: The range of times to consider as
%                                    |    the baseline value; the median value 
%                                    |    is taken as the baseline; (e.g., [0.001 0.003]
%                                    |    considers times between 1ms and 3ms)
%   t1 (0.005)                       | If 1x1: Time after spike to remove (in sec)
%                                    |    The sample closest to this time is
%                                    |    chosen
%                                    | If 1x2: The range of times to consider as
%                                    |    the baseline value; the median value 
%                                    |    is taken as the baseline; (e.g., [0.001 0.003]
%                                    |    considers times between 1ms and 3ms)
%

SPIKE_INTERP_METHOD = 1;

SPIKE_BEGINNING_END_METHOD = 1;
t0 = 0.003;
t1 = 0.005;

vlt.data.assign(varargin{:});

 % start editing here

data_out = data;

if length(T)>2, % convert to first sample plus sample interval format
	T = [T(1) diff(T(1:2))]; 
end;

if length(T)<2, error(['T must contain at least 2 points; see help.']); end;

  % loop over all spikes

for i=1:length(spiketimes),
	% identify the points that are included in the spike data
	% we will assign baselinepre_index to be the baseline index locations before the spike
        % we will assign baselinepost_index to be the baseline index locations after the spike
	switch SPIKE_BEGINNING_END_METHOD,
		case 1, % pre- and post-times only, not based on data
			% find when the sample closest to time ti occurs
			baselinepre_index = round ( 1+(spiketimes(i)-(t0)-T(1))/T(2));
			baselinepre_index = unique(baselinepre_index); %ensure each sample only there once
			baselinepost_index = round ( 1+(spiketimes(i)+(t1)-T(1))/T(2));
			baselinepost_index = unique(baselinepost_index); %ensure each sample only once
		otherwise,
			error(['Unknown SPIKE_BEGINNING_END_METHOD.']);
	end;

	switch SPIKE_INTERP_METHOD,
		case 1, % LINEAR INTERPOLATION
			% the data during baselinepre_index will be replaced with the
                        % the median value of the baselinepre_index samples; likewise for
                        % baselinepost_index; the intervening values will be replaced with the linear
                        % interpolation
			data_out(baselinepre_index) = median(data(baselinepre_index));
			data_out(baselinepost_index) = median(data(baselinepost_index));
			data_out(baselinepre_index(end):baselinepost_index(1)) = ...
				interp1([baselinepre_index(end) baselinepost_index(1)],...
					[data_out(baselinepre_index(end)) data_out(baselinepost_index(1))],...
					baselinepre_index(end):baselinepost_index(1),  'linear');
		otherwise(['Unknown SPIKE_INTERP_METHOD.']);
	end;
end;


