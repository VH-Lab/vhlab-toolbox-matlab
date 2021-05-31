# vlt.image.xcorr2dlag

  XCORR2DLAG - 2-d cross-correlation computed at specified lags
 
    XC = XCORR2DLAG(W1,W2,XLAGS,YLAGS)
 
   Computes cross-correlation of two-dimensional matricies
   W1 and W2 at the specified lags in x (XLAGS) and in y
   (YLAGS).  On most platforms this function runs a MEX file
   written for speed and therefore there is no error checking to
   make sure W1 and W2 are the same size and that XLAGS and YLAGS
   are in bounds.  
 
   XC is a matrix LENGTH(YLAGS)xLENGTH(XLAGS).
