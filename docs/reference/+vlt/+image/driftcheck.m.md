# vlt.image.driftcheck

  DRIFTCHECK - Checks for drift in image pair by correlation
 
    DR = DRIFTCHECK(IM1,IM2,SEARCHX,SEARCHY,...)
 
   Checks for drift over the specific offset ranges
   SEARCHX = [x1 x2 x3] and SEARCHY = [y1 y2 y3].
   Positive shifts are rightward and upward with respect to
   the original.
 
   This function accepts additional parameter as name/value pairs.
   Parameter (default value) | Description
   -----------------------------------------------------------------
   subtractmean (0)          | (0/1) If 1, subtract the mean of each image
                             |    before correcting
   brightnessartifact (100)  | (0-100) Set all pixels above this percentile of
                             |    brightness to the mean of the image (100 means
                             |    no change)
   darknessartifact (0)      | (0-100) Set all pixels below this percentile of
                             |    brightness to the mean of the image (0 means
                             |    no change)
   brightnesscorrect (1)     | (0/1) If 1, images are normalized
                             |    by their standard deviation before
                             |    correlating. This allows accurate correlation
                             |    where total image brightness has changed.
   roicorrect (1)            |  (0/1) If 1, only the pixels above the 'mn' 
                             |    are considered in the correlation.
   
 
   The best offset, as determined by correlation, is returned
   in DR = [OFFSET_X OFFSET_Y].
 
   This function calls the xcorr2dlag MEX file; this function
   will produce an error if this function is not compiled for
   your platform.
