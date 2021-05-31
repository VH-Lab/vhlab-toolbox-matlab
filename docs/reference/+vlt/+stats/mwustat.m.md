# vlt.stats.mwustat

  [u,z,P] = mwustat(data1,data2)
  vlt.stats.mwustat.m: given vectors data1 and data2, the Mann-Whitney U statistic is
  returned along with the significance statistic Z.  The Z value should be
  compared to T(alpha,infinity) for samples larger than 40 data points,
  otherwise The U value should be compared to a table of the U distribution.
  This implementation assumes a precision in measurements that renders
  tie values (i.e., > 1 occurence of the same value) unlikely.  If tie
  values are expected, this function should be modified.
 
  Adapted from Biostatistical Analysis, Zar JH, Prentice-Hall, 1974.
  This script was written by Carsten D. Hohnke, currently at BCS at MIT
 
  u - the U statistic
  z - the z-score for U
  P - the p-value for that z
  thesign - the sign of the difference (data2 - data1): +1 if Rank2>Rank1
  NOTE: Is this the correct order?
