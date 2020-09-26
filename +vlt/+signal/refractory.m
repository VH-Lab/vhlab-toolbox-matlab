function [out_times,out_index] = refractory(in_times, refractory_period)
% REFRACTORY - Impose a refractory period on events
%
%  [OUT_TIMES,OUT_INDEXES] = vlt.signal.refractory(IN_TIMES, REFRACTORY_PERIOD)
%
%  This function will remove events from the vector IN_TIMES that occur
%  more frequently than REFRACTORY_PERIOD.
%
%  IN_TIMES should contain the times of events (in any units, whether they be
%  units of time or sample numbers).
%
%  REFRACTORY_PERIOD is the time after one event when another event cannot
%  be said to happen.  Any events occuring within REFRACTORY_PERIOD of a 
%  previous event will be removed.
%
%  OUT_TIMES are the times that meet the refractory criteria.  OUT_INDEXES
%  are the index values of the points in IN_TIMES that meet the criteria,
%  such that OUT_TIMES = IN_TIMES(OUT_INDEXES)

[out_times,first_rearrange] = sort(in_times); % make sure they are sorted
out_index = 1:length(out_times);

done = isempty(out_times); % make sure we have something to do

while ~done,
	d = diff(out_times);
	inds = [1;1+find(d(:)>refractory_period)];
	if length(inds)==length(out_times),
		done = 1;
	else,
		out_times = out_times(inds);
		out_index = out_index(inds);
	end;
end;

out_index = first_rearrange(out_index);

