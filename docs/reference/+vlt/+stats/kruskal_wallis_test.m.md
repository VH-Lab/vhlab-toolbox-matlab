# vlt.stats.kruskal_wallis_test

```
   KRUSKAL_WALLIS_TEST - Kruskal-Wallis one-factor analysis of variance
   Perform a Kruskal-Wallis one-factor "analysis of variance".
 
   [PVAL,K,DF]=vlt.stats.kruskal_wallis_test(X1, ..., XK)
 
   Suppose a variable is observed for @var{k} > 1 different groups, and
   let X1, ..., XK be the corresponding data vectors.
 
   Under the null hypothesis that the ranks in the pooled sample are not
   affected by the group memberships, the test statistic K is
   approximately chi-square with DF = K - 1 degrees of freedom.
  
   The p-value (1 minus the CDF of this distribution at K) is
    returned in PVAL}.
 
   If no output argument is given, the p-value is displayed.
    [From Octave 2.5.1]
   (2024-04-23: NaN values will be removed. SDV)
   Author: KH <Kurt.Hornik@ci.tuwien.ac.at>
   Description: Kruskal-Wallis test

```
