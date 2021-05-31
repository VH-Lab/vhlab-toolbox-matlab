# vlt.plot.median_within_between_plot

  MEDIAN_WITHIN_BETWEEN_PLOT - Plot an index for many experiments, different conditions
 
   [H,DATAPOINTS]=vlt.plot.median_within_between_plot(DATA, EXPERIMENT_INDEXES, LABELS)
 
   Plots index values from individual experiments that are grouped into different
   experimental conditions.  For each condition, indexes from individual animals
   are plotted in columns. A bigger space is left between animals that are in 
   different experimental groups.  Median values for each animal and each
   group are highlighted with a horizontal bar.
 
   Inputs:  There are 2 ways of specifying the data.
     Method 1: DATA should be a cell array of index values for different conditions.
       If there N conditions, then DATA should have N entries.  Each entry DATA{n} should
       have the index values from a single experimental condition.  EXPERIMENT_INDEXES{n} 
       indicates the experiment number that produced each data point in DATA{n}.
 
     Method 2: DATA is an array of values. EXPERIMENT_INDEXES is an Mx2 matrix; the first
       column of EXPERIMENT_INDEXES should be the experiment index number, and the second
       column of EXPERIMENT_INDEXES should be the condition number.
 
   LABELS{n} should be the label for the conditions.
 
   Outputs:
      H is a set of handles to the plots.
      DATAPOINTS is a structure with the following fields:
         experiment: the experiment that corresponds to the point
         condition:  the condition of the point
         index:      the index of the point within the condition
         x:          the x position on the plot
         y:          the y position on the plot (might be transformed from the raw data)
