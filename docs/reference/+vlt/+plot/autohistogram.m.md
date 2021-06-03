# vlt.plot.autohistogram

```
 AUTOHISTOGRAM - Choose bins based on Freedman-Diaconis' choice
   [COUNTS,BIN_CENTERS, BIN_EDGES, FULLCOUNTS] = vlt.plot.autohistogram(DATA)
      Automatically chooses bin sizes based on Freedman-Diaconis' choice,
         defined to be
         WIDTH = 2*IQR(DATA)/CUBE ROOT OF NUMBER OF DATAPOINTS
               (see Histogram on Wikipedia)
 
      In the event that the BIN_CENTERS would exceed 100,000 points,
      then the bins are trimmed at the edges in 1 percentile increments
      until the number of bins is fewer than 100,000 points.
      
    Inputs:  DATA, a set of samples
    Outputs: COUNTS, the number of DATA samples in each bin
             BIN_CENTERS - the center location of each bin
             BIN_EDGES - the bin edges used
             FULLCOUNTS - the full counts returned from HISTC. If the bins
             were reduced at the edges so that the number of bins is < 100000
             then BIN_EDGES and FULLCOUNTS allows the user to determine the
             number of data points that fall below and above the bins. (See
             help HISTC)

```
