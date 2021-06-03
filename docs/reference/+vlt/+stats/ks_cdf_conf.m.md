# vlt.stats.ks_cdf_conf

```
 KS_CDF_CONF Kolmogorov-Smirnov confidence interval for a data set.
    [Xvalues,sampleCDF,minCDF,maxCDF] = vlt.stats.ks_cdf_conf(X1,ALPHA)
    performs a Kolmogorov-Smirnov (K-S) test to determine the confidence
    interval for independent random samples X1.
    ALPHA is the desired significance level (default = 0.05); 
    observations, indicated by NaNs (Not-a-Number), are ignored.
 
    The asymptotic P-value becomes very accurate for large sample sizes, and
    is believed to be reasonably accurate for sample sizes N1 and N2 such 
    that (N1*N2)/(N1 + N2) >= 4.
 
    Created by SDV, based on KSTEST2 by the MathWorks
 
    See also KSTEST, KSTEST2, CDFPLOT.

```
