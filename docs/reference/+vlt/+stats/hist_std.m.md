# vlt.stats.hist_std

  HIST_PERCENTILE - Produce standard deviation for data values that fall between bins
 
   STDDEV = vlt.stats.hist_std(BINS, DATA1, DATA2)
 
   For a given set of BINS, this function examines the data provided in
   DATA1 determine which values fall between BINS(i) and BINS(i+1). 
   Then, the standard deviation of the corresponding values in DATA2
   are returned in STDDEV(i).
