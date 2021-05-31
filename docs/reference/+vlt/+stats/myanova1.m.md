# vlt.stats.myanova1

 ANOVA1 One-way analysis of variance (ANOVA).
    ANOVA1 performs a one-way ANOVA for comparing the means of two or more 
    groups of data. It returns the p-value for the null hypothesis that the
    means of the groups are equal.
 
    P = ANOVA1(X) for matrix, X, treats each column as a separate group,  
    and determines whether the population means of the columns are equal.   
    This one-input form of ANOVA1 is appropriate when each group has the
    same number of elements (balanced ANOVA).
 
    P = ANOVA1(X,GROUP) has vector inputs X and GROUP. The vector, GROUP, 
    identifies the group of the corresponding element of X. This two-input
    form of ANOVA1 has no restrictions on the number of elements in each
    group.    
  
    ANOVA1 prints the standard one-way ANOVA table in Figure 1 and displays 
    a boxplot in Figure2.
