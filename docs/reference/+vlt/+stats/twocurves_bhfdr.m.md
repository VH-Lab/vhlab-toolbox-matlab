# vlt.stats.twocurves_bhfdr

```
  TWOCURVES_BHFDR - compare significance between 2 curves using the Benjamini-Hochberg false discovery rejection
 
  [ADJUSTED_P, RAW_P] = vlt.stats.twocurves_bhfdr(CURVE1_EXAMPLES, CURVE2_EXAMPLES)
 
  Given two data sets (CURVEN_EXAMPLES, which trace out a curve with each curve observation in a column vector),
  this function calculates RAW_P, the raw, uncorrected p value of a TTEST2 between the curves, and the adjusted
  p value ADJUSTED_P using the Behmamini-Hochberg (1995) procedure by calling MAFDR.

```
