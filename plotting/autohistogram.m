function [counts,bin_centers] = autohistogram(data)
%AUTOHISTOGRAM - Choose bins based on Freedman-Diaconis' choice
%  [COUNTS,BIN_CENTERS] = AUTOHISTOGRAM(DATA)
%     Automatically chooses bin sizes based on Freedman-Diaconis' choice,
%        defined to be
%        WIDTH = 2*IQR(DATA)/CUBE ROOT OF NUMBER OF DATAPOINTS
%              (see Histogram on Wikipedia)
%   Inputs:  DATA, a set of samples
%   Outputs: COUNTS, the number of DATA samples in each bin
%            BIN_CENTERS - the center location of each bin
%   
bin_min = min(data);
bin_max = max(data);
num_datapoints = length(data);
bin_width = 2*iqr(data)/power(num_datapoints,1/3); % use Freedman-Diaconis
if bin_width == 0, % if there's no interquartile variation, just use 11 bins
    bin_width = (bin_max-bin_min)/10;
    if bin_width == 0, % if it is still 0, there's no variation in data
        bin_width = 1;
    end;
end;
bin_edges = (bin_min-bin_width):bin_width:(bin_max+bin_width);
bin_centers = (bin_edges(1:end-1) + bin_edges(2:end))/2;
counts = histc(data,bin_edges);
counts = counts(1:end-1); % remove the last bin that is returned by histc

