# vlt.stats.quickregression

  QUICKREGRESSSION - Computes best fit to a line and confidence interval on
  slope
 
  [SLOPE,OFFSET,SLOPE_CONFINTERVAL, ...
        RESID, RESIDINT, STATS] = vlt.stats.quickregression(X,Y, ALPHA)
 
   Returns the best fit Y = SLOPE * X + OFFSET
 
   Also returns (1-ALPHA) confidence intervals around SLOPE and residuals,
   residual intervals, and STATS.
 
   NAN entries are ignored.
 
   See also: POLYFIT, REGRESS, QUICKREGRESIONPVALUE
