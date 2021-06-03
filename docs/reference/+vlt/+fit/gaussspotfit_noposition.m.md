# vlt.fit.gaussspotfit_noposition

```
  GAUSSSPOTFIT - Fit a 2d gaussian to data
 
   [MU,C,AMP,SIZES,FIT_RESPONSES] = vlt.fit.gaussspotfit_noposition(XRANGE, YRANGE, RADIUS, RESPONSE)
 
   Fits a 2d gaussian PDF to responses to circle / aperture stimulation.
 
   INPUTS:
     XRANGE and YRANGE specify the size of the stimulus field. They should be vectors:
     (e.g., XRANGE = 0:800; YRANGE=0:600).
     X_CTR, Y_CTR, RADIUS, and RESPONSE are vectors that describe the stimulus circles.
     RESPONSE is the response of the system to that circle.
   OUTPUTS:
     MU - Always [0 0]
     C  - The covariance matrix of the best-fit gaussian PDF; always [C1 0 ; 0 C1]
     AMP - The amplitude of the response for each circle size.
     SIZES - The sizes that are associated with each amplitude.
     FIT_RESPONSES - the fit responses

```
