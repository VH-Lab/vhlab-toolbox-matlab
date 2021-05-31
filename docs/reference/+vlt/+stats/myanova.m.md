# vlt.stats.myanova

   vlt.stats.myanova - One-way analysis of variance with posthoc comparisons
     vlt.stats.myanova performs a one-way ANOVA for comparing the means of two or more
     groups of data.  It returns the p-value for the null hypothesis that the
     means of the groups are equal.  If the null hypothesis is rejected,
     then it makes posthoc comparisons with a modified t-test.
 
     [P, H, COMP] = vlt.stats.myanova(X, G, [SIG]) has vector inputs X and G.  G contains
     the group number for each point in X.  SIG is the significanc level to use
     (default is 0.05).  P is the probability of the null hypothesis, H is
     1 if the null hypothesis is rejected and 0 otherwise, and COMP is an
     NxN matrix of significant comparisons among the groups, where N is the
     total number of groups (determined by the number of unique elements in G).
