# vlt.fit.gaussspotfit_nopos_surr

```
  GAUSSSPOTFIT - Fit a 2d gaussian to data
 
   [MU,C,AMP,B,FIT_RESPONSES, R_SQUARED] = vlt.fit.gaussspotfit_nopos_surr(XRANGE, YRANGE, RADIUS, RESPONSE)
 
   Fits a 2d gaussian PDF with modulation to responses to circle / aperture stimulation.
 
   The equation that is fit is STIMULUS(r) * AMP * G(r,MU,SIGMA) * (1+B*r)
   The first half is an integrated Gaussian function (G(r,MU,SIGMA))
   The second half is a modulating factor that depends linearly on the stimulus
   diameter.
   
 
   INPUTS:
     XRANGE and YRANGE specify the size of the stimulus field. They should be vectors:
     (e.g., XRANGE = 0:800; YRANGE=0:600).
     RADIUS is a vector that describes the radius of each stimulus. If the stimulus is a circle that 
       is filled, RADIUS should be positive. If the stimulus is a circle that is empty (with the stimulus 
       surrounding the center), the RADIUS should be negative. 
     RESPONSE is a vector with the mean response to each stimulus.
   OUTPUTS:
     MU - Always [0 0]
     C  - The covariance matrix of the best-fit gaussian PDF; always [C1 0 ; 0 C1]
     AMP - The amplitude of the response
     B - The modulating factor
     FIT_RESPONSES - the fit responses
     R_SQUARED - The error of the fit normalized by the square of the data around its mean

```
