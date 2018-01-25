function [counts,bin_centers, bin_edges, fullcounts] = autohistogram(data)
%AUTOHISTOGRAM - Choose bins based on Freedman-Diaconis' choice
%  [COUNTS,BIN_CENTERS, BIN_EDGES, FULLCOUNTS] = AUTOHISTOGRAM(DATA)
%     Automatically chooses bin sizes based on Freedman-Diaconis' choice,
%        defined to be
%        WIDTH = 2*IQR(DATA)/CUBE ROOT OF NUMBER OF DATAPOINTS
%              (see Histogram on Wikipedia)
%
%     In the event that the BIN_CENTERS would exceed 100,000 points,
%     then the bins are trimmed at the edges in 1 percentile increments
%     until the number of bins is fewer than 100,000 points.
%     
%   Inputs:  DATA, a set of samples
%   Outputs: COUNTS, the number of DATA samples in each bin
%            BIN_CENTERS - the center location of each bin
%            BIN_EDGES - the bin edges used
%            FULLCOUNTS - the full counts returned from HISTC. If the bins
%            were reduced at the edges so that the number of bins is < 100000
%            then BIN_EDGES and FULLCOUNTS allows the user to determine the
%            number of data points that fall below and above the bins. (See
%            help HISTC)
%   
bin_min = min(data(:));
bin_max = max(data(:));
num_datapoints = length(data(:));
bin_width = 2*iqr(data(:))/power(num_datapoints,1/3); % use Freedman-Diaconis
if bin_width == 0, % if there's no interquartile variation, just use 11 bins
    bin_width = (bin_max-bin_min)/10;
    if bin_width == 0, % if it is still 0, there's no variation in data
        bin_width = 1;
    end;
end;

  % now make sure we don't have too many bins

bin_low = bin_min;
bin_high = bin_max;
mn = mean(data(:));
p = [0 100];
  
while (bin_high-bin_low+2*bin_width)/bin_width > 100000,
    high_end = 0;
    low_end = 0;
    if (bin_max+bin_width-mn)/bin_width > 50000, % shorten at high end
       high_end = 1; % need to shorten at high end 
    end
    if (mn+bin_width-bin_min)/bin_width > 50000 % shorten at low end
       low_end = 1; 
    end
    p = p + [low_end -high_end];
    pt = prctile(data(:),p);
    bin_high = pt(2);
    bin_low = pt(1);
end

bin_edges = [bin_min-2*bin_width (bin_low-bin_width):bin_width:(bin_high+bin_width) bin_max+2*bin_width];
bin_centers = (bin_edges(2:end-2) + bin_edges(3:end-1))/2;
fullcounts = histc(data(:),bin_edges);
counts = colvec(fullcounts(2:end-2))'; % remove the last bin that is returned by histc