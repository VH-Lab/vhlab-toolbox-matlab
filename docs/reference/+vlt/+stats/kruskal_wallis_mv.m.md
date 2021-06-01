# vlt.stats.kruskal_wallis_mv

   KRUSKAL_WALLIS_MV(VARARGIN)
   Perform a Kruskal-Wallis one-factor 'analysis of variance' for multivariate
   data.
   
   [PVAL,KW,DF] = vlt.stats.kruskal_wallis_mv(X1, ..., XK)
 
   Returns the probability (PVAL) of the null hypothesis that the
   distributions of X1, ..., XK are equal.  The multivariate points Xi should
   be arranged in column form.  The KW statistic and degrees of freedom DF
   are returned.  The Kruskal-Wallis test is a rank
   test based on the order of the datapoints rather than their value
   (see ANOVA1).  We implement the test described by Choi and Marden and
   choose the kernel to be (X-Y)/||(X-Y)|| (see the reference).
 
   Reference: Choi and Marden, J. Amer. Stat. Assoc., 92:1581-1590
 
   warning: this has been tested for normal distributions and seems to
   perform reasonably, but I could not find example data for which the
   authors had performed analysis; upshot: this is not 100% tested
