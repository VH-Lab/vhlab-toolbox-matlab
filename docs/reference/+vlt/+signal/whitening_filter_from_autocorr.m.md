# vlt.signal.whitening_filter_from_autocorr

  WHITENING_FILTER_FROM_AUTOCORR - Compute whitening filter from inverse covariance matrix from autocorrelation of signal
 
   [RINV, R] = vlt.signal.whitening_filter_from_autocorr(AUTOCORR, M)
   
   Uses the inverse of the covariance matrix derived from the autocorrelation of a signal
   to generate a whitening filter. 
    
   Given an autocorrelation of a signal in the form of a vector with lags 1..N, 
   this function creates a covariance matrix R with dimension M and its inverse, RINV.
   
   If M is greater than M, then the matrix R is zero padded.
