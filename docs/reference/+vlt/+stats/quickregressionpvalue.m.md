# vlt.stats.quickregressionpvalue

  QUICKREGRESSSIONPVALUE - Estimate p value of the null hypothesis that slope==0
 
  P = vlt.stats.quickregressionpvalue(X,Y,[NUM_STEPS])
 
  Takes NUM_STEPS to estimate the P value that the slope of the regression
  line between X and Y is 0.  This estimate is made by calling vlt.stats.quickregression
  with different ALPHA values, and examining the confidence intervals.
 
  If NUM_STEPS is not provided, 30 steps are taken.
        
  NAN entries are ignored.
 
  See also: vlt.stats.quickregression, REGRESS
