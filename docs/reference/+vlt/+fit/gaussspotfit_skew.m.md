# vlt.fit.gaussspotfit_skew

  GAUSSSPOTFIT - Fit a 2d gaussian to data
 
   [MU,C,AMP,SIZES,FIT_RESPONSES] = vlt.fit.gaussspotfit(XRANGE, YRANGE, X_CTR,Y_CTR,...
                        RADIUS,RESPONSE)
 
   Fits a 2d gaussian PDF to responses to circle stimulation at different positions.
 
   INPUTS:
     XRANGE and YRANGE specify the size of the stimulus field. They should be vectors:
     (e.g., XRANGE = 0:800; YRANGE=0:600).
     X_CTR, Y_CTR, RADIUS, and RESPONSE are vectors that describe the stimulus circles.
     X_CTR and Y_CTR contain center locations in X and Y; RADIUS has the diameter
     RESPONSE is the response of the system to that circle.
   OUTPUTS:
     MU - The mean of the best-fit gaussian PDF, in X and Y
     C  - The covariane matrix of the best-fit gaussian PDF
     AMP - The amplitude of the response for each circle size.
     SIZES - The sizes that are associated with each amplitude.
     FIT_RESPONSES - the fit responses
