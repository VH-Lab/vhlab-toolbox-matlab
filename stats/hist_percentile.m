function prctiles = hist_percentile(bins, data1, data2, percent_value)
% HIST_PERCENTILE - Produce a percentile for data values that fall between bins
%
%  PRCTILES = HIST_PERCENTILES(BINS, DATA1, DATA2, PERCENT_VALUE)
%
%  For a given set of BINS, this function examines the data provided in
%  DATA1 determine which values fall between BINS(i) and BINS(i+1). 
%  Then, the PERCENT_VALUE percentile of the corresponding values in DATA2
%  are returned in PRCTILES(i).
%

prctiles = [];

[N,indexes] = histc(data1(:),bins);

for i=1:length(N)-1,
	indexes_in_this_bin = find(indexes==i);
	prctiles(end+1) = prctile(data2(indexes_in_this_bin),percent_value);
end;

