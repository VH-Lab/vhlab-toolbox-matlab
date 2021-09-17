function [X,Y] = cumhist(data, xrange, delta)

% CUMHIST - Make data for a cumulative histogram plot
%
%   This function has been revised. The NEW version is:
%   
%   [X,Y]=CUMHIST(DATA)
%
%    Generates X and Y variables suitable for plotting with
%    the plot function. Y values are generated for percentages
%    ranging from 0 to 100% in steps of PERCENT_DELTA. The XRANGE
%    for the plot is specified in XRANGE = [lowvalue highvalue].
%    
%    Example:
%
%      r=randn(1000,1); % 1000 normally-distributed random numbers
%
%      [X,Y] = cumhist(r);
%      figure;
%      plot(X,Y,'k-');
%      hold on;
%      plot([-4 4],[50 50],'k--'); % add 'median' (50%-tile) dashed line
%      box off;
%      ylabel('Percentage');
%      xlabel('Values');
%
%    See also: PRCTILE, CUMSUM, HIST    
%
%    If 3 input arguments are provided, then the LEGACY version of this
%    function is called.
%
%   [X,Y]=CUMHIST(DATA,XRANGE,PERCENT_DELTA)
%
%    Generates X and Y variables suitable for plotting with
%    the plot function. Y values are generated for percentages
%    ranging from 0 to 100% in steps of PERCENT_DELTA. The XRANGE
%    for the plot is specified in XRANGE = [lowvalue highvalue].
%    
%    Example:
%
%      r=randn(1000,1); % 1000 normally-distributed random numbers
%      xrange = [-4 4];
%      percent_delta = 0.1; % use steps of 0.1%
%
%      [X,Y] = cumhist(r,xrange,percent_delta);
%      figure;
%      plot(X,Y,'k-');
%      hold on;
%      plot([-4 4],[50 50],'k--'); % add 'median' (50%-tile) dashed line
%      box off;
%      ylabel('Percentage');
%      xlabel('Values');
%
%    See also: PRCTILE, CUMSUM, HIST    

if nargin==1,
    data = data(:); % make it a column
    bin_edges = [unique([data])];
    bin_counts = histc(data, bin_edges);
    X = [bin_edges bin_edges]'; % two points at each X location
    counts = 100 * cumsum(bin_counts) / sum(bin_counts);
    Y = [[0;counts(1:end-1)] [counts]]';
    X = X(:); % put the points into single columns
    Y = Y(:); % put the points into single columns
else,

    Y = [0 0:delta:100 100];
    X = [xrange(1) prctile(data ,0:delta:100) xrange(2)];

end;