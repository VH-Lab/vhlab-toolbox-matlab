# vlt.plot.cumhist

```
  vlt.plot.cumhist - Make data for a cumulative histogram plot
 
    [X,Y]=vlt.plot.cumhist(DATA,XRANGE,PERCENT_DELTA)
 
     Generates X and Y variables suitable for plotting with
     the plot function. Y values are generated for percentages
     ranging from 0 to 100% in steps of PERCENT_DELTA. The XRANGE
     for the plot is specified in XRANGE = [lowvalue highvalue].
     
     Example:
 
       r=randn(1000,1); % 1000 normally-distributed random numbers
       xrange = [-4 4];
       percent_delta = 0.1; % use steps of 0.1%
 
       [X,Y] = vlt.plot.cumhist(r,xrange,percent_delta);
       figure;
       plot(X,Y,'k-');
       hold on;
       plot([-4 4],[50 50],'k--'); % add 'median' (50%-tile) dashed line
       box off;
       ylabel('Percentage');
       xlabel('Values');
 
     See also: PRCTILE, CUMSUM, HIST

```
