# vlt.stats.roc_stats

  ROC_STATS - Receiver operator characteristic for 2 groups
 
  OUT = ROC_STATS(GROUP1, GROUP2)
 
  Performs ROC analysis for single real numbered observations in GROUP1 and GROUP2.
  GROUP1 is considered the 'signal' and GROUP2 is considered the 'noise'.
  
  This calculates several statistics in the structure OUT:
  -------------------------------------------------------------
  Fieldname:     | Description
  -------------------------------------------------------------
  tpr            | True positive rate at thresholds in th
  fpr            | False positive rate at thresholds in th
  th             | Thresholds 
  acc_eq         | Accuracy at each threshold if mixtures are equally likely
  acc_em         | Accuracy at each threshold if mixtures match the empirically provided mixtures
  acc_eq_max     | Accuracy rate at best threshold if mixtures are equally likely
  acc_eq_max_th  | Threshold where accuracy is highest if mixtures are equally likely
  acc_em_max     | Accuracy rate at best thresholds if mixtures match the empircally provided mixtures
  acc_em_max_th  | Threshold where accuracy is highest if mixtures match empircally provided mixtures
 
  See also: ROC
