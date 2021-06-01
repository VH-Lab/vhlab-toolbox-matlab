# vlt.stats.manova

  vlt.stats.manova - Multivariate Analysis of Variance
 
   [STATS,H] = vlt.stats.manova(X,G), or
   [STATS,H] = vlt.stats.manova(X,G,ALPHA)
 
   Determines whether the means of groups of multivariate data points are the
   same, using Wilks' criterion.  Each N-dimensional data point is a row in X,
   so that X is NxP, where P is the total number of data points.  Each data
   point belongs to a group, indicated in vector G, which should be 1XP.
   ALPHA is level of significance, and, If ALPHA is not given, 0.01 is assumed.
   
   STATS is a struct with the following elements:
 
     DF_between = degrees of freedom among samplesm, or (K-1), K==num of groups
     DF_within  = degrees of freedom within samples, or N-K
     DF_TOTAL   = total degrees of freedom N-1
     B          = matrix of sum of squares and products (SSP) between samples
     W          = matrix of SSP within samples
     T          = matrix of total SSP, note that T==W+B
     ratio      = |W|/|T|, or ratio to be compared to Wilks' statistic
     P          = Probability of data under hypothesis that means are equal
     H          = 0 if means are SAME, 1 if DIFFERENT
     X__        = Grand mean of data
     X_         = Mean of each group (KxP)
     N          = Number of items in each group (Kx1)
     E          = Eigenvalues for canonical variate projection (inv(W)*B)
     V          = Eigenvectors corresp. to these eigenvalues
     VV         = Eigenvectors normalized (by W/(N-K)) for canonical v. proj.
 
   See Chapter 12 of _Multivariate Analysis_, KV Mardia, JT Kent, JM Bibby,
   Academic Press, London, 1979.
  
   Note:  The eigenvector corresponding to the largest eigenvalue of inv(W)*B 
   is the first canonical variate or Fisher's linear discriminant function.
   Projecting onto this variate is useful for visualizing the differences among
   groups of data.  The other canonical variates are the eigenvectors
   corresponding to the eigenvalues in descending order of magnitude.
   (See sec. 11.5 of above book.)
 
   Steve Van Hooser, 2003
