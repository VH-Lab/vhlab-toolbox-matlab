# vlt.stats.roc_analysis

```
  ROC_ANALYSIS - Receiver operating characteristics
   [DISCRIM,PROB_TRUE_ACCEPT, PROB_FALSE_ACCEPT, XVALUES,...
       CONFUSION,SAMPLE1CUM,SAMPLE2CUM]=vlt.stats.roc_analysis(SAMPLE1,SAMPLE2)
 
   Performs ROC analysis to see how sensitivity and false positives trade
   off if the task is to say which distribution a given value is likely
   to have arisen from.
 
   (see http://en.wikipedia.org/wiki/Receiver_operating_characteristic)
   
   For each value of X present in the samples SAMPLE1 and SAMPLE2, 
   ROC returns the resulting probability of a "true accept" (we say
   the value is from SAMPLE2 and it is) and the resulting
   probability of a "false accept" (we say the sample is from SAMPLE2
   but it's really from SAMPLE1).
 
    Inputs:  SAMPLE1 - an array of sample data
             SAMPLE2 - an array of sample data
    Outputs: DISCRIM - Likelihood of discriminating the 2 distributions
                       (accuracy) for each possible threshold X
             TRUE_POSITIVE_RATE - The rate a true accept (sensitivity) (TP_x./(TP_x+FN_x))
             FALSE_POSITIVE_RATE - The rate of a false accept (FP_x./(FP_x+TN_x))
             XVALUES - The X-axis values for the cumulative density functions
             CONFUSION - A structure with the "confusion matrix" assuming each value of
                         X is used as a threshold. It has fields:
                         confusion.TP_x: (true positive)
 				likelihood sample is X or greater and comes from sample 2
                         confusion.FN_x: (false negative)
 				likelihood sample is less than X and comes from sample 2
                         TN_X: (true negative)
                                likelihood sample is less than X and comes from sample 1
                         confusion.FP_x: (false positive)
                                likelihood sample is X or greater and comes from sample 1
             SAMPLE1CUM - The cumulative sums of SAMPLE1
             SAMPLE2CUM - The cumulative sums SAMPLE2

```
