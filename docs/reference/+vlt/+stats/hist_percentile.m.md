# vlt.stats.hist_percentile

  HIST_PERCENTILE - Produce a percentile for data values that fall between bins
 
   PRCTILES = HIST_PERCENTILES(BINS, DATA1, DATA2, PERCENT_VALUE)
 
   For a given set of BINS, this function examines the data provided in
   DATA1 determine which values fall between BINS(i) and BINS(i+1). 
   Then, the PERCENT_VALUE percentile of the corresponding values in DATA2
   are returned in PRCTILES(i).
