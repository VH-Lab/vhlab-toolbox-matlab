# vlt.plot.plotbargraphwithdata

  PLOTMEANBAR - Plot a bar graph indicating mean, standard error, and raw data
 
  H = vlt.plot.plotbargraphwithdata(DATA, ...)
 
  Plots a bar graph with height equals to the mean value of the the mean value
  of each dataset in the cell array DATA{i}. The standard error of the mean is
  shown with error bars offset by XOFFSET. The raw data is plotted offset by
  XOFFSET.
 
  This function can be modified by name/value pairs:
  Parameter (default value)    | Description
  --------------------------------------------------------------
  xloc (linspace(1,...         | The location on the x axis where the bars
     numel(data),,numel(data)))|    should be drawn ([xstart xend])
  barcolor ([0.4 0.4 0.4])     | Color of the bar graph (RGB)
  datacolor ([0 0 0])          | Color of the raw data (RGB)
  stderrcolor ([0 0 0])        | Color of the std error bars (RGB)
  usestderr (1)                | 0/1 Should we plot an error bar showing
                               |    standard error of the mean?
  userawdata (1)               | 0/1 Should we plot the raw data?
  useholdon (1)                | 0/1 Should we call 'hold on'?
  linewidth (2)                | Linewidth for mean bar plot
  linewidth_stderr (1)         | Linewidth for standard error plot
  symbolsize (6)               | Symbol size
  symbol ('o')                 | Symbol to use
  xoffset (0.25)               | X offset for plotting standard error, raw data
  measure ('nanmean(data(:))') | Function to call to obtain mean; could be 'median', e.g.
