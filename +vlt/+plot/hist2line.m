function [x,y] = hist2line(bins, counts)
% HIST2LINE - generate a line plot from a histogram that will plot the histogram
%
%  [X,Y] = HIST2LINE(BINS, COUNTS)
%
%  Generates a line plot with values X, Y from the histogram with bin edges BINS and 
%  bin counts COUNTS.  BINS should have one more entry than DATA, since DATA(i) is the number of points between
%  BINS(i) and BINS(i+1).
%
%  See also:  BAR, BARH, HIST, HISTC, SHIFTEDBAR


bins = colvec(bins);
counts = colvec(counts);

x = bins(1);
y = counts(1);

for i=2:numel(bins),
	x(end+1) = bins(i);
	y(end+1) = counts(i-1);
	x(end+1) = bins(i);
	y(end+1) = counts(i);
end;

