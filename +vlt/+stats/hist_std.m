function stddev = hist_std(bins, data1, data2)
% HIST_PERCENTILE - Produce standard deviation for data values that fall between bins
%
%  STDDEV = vlt.stats.hist_std(BINS, DATA1, DATA2)
%
%  For a given set of BINS, this function examines the data provided in
%  DATA1 determine which values fall between BINS(i) and BINS(i+1). 
%  Then, the standard deviation of the corresponding values in DATA2
%  are returned in STDDEV(i).
%

stddev = [];

[N,indexes] = histc(data1(:),bins);

for i=1:length(N)-1,
	indexes_in_this_bin = find(indexes==i);
	stddev(end+1) = std(data2(indexes_in_this_bin));
end;

