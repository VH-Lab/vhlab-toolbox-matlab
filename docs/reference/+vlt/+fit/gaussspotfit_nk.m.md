# vlt.fit.gaussspotfit_nk

```
  GAUSSSPOTFIT - Fit a 2d gaussian to data
 
   [MU,C,AMP,C50, N, FIT_RESPONSES] = vlt.fit.gaussspotfit_nk(XRANGE, YRANGE, X_CTR,Y_CTR,...
                        RADIUS,RESPONSE)
 
   Fits a 2d gaussian PDF to responses to circle stimulation at different positions, with
   response amplitude modulated by the Naka-Rushton function.
 
   INPUTS:
     XRANGE and YRANGE specify the size of the stimulus field. They should be vectors:
     (e.g., XRANGE = 0:800; YRANGE=0:600).
     X_CTR, Y_CTR, RADIUS, and RESPONSE are vectors that describe the stimulus circles.
     X_CTR and Y_CTR contain center locations in X and Y; RADIUS has the diameter (SV NOTE: Did I write this?? Do I really mean diameter?)
     RESPONSE is the response of the system to that circle.
   OUTPUTS:
     MU - The mean of the best-fit gaussian PDF, in X and Y
     C  - The covariance matrix of the best-fit gaussian PDF
     AMP - The amplitude of the response for each circle size.
     C50 - 50% point of Naka Rushton response
     N - N power of Naka Rushton response
     FIT_RESPONSES - the fit responses

```
