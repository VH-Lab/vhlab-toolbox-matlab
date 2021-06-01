# vlt.fit.gaussspotfit_nopos_surr

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
     X_CTR, Y_CTR, RADIUS, and RESPONSE are vectors that describe the stimulus circles.
     RESPONSE is the response of the system to that circle.
   OUTPUTS:
     MU - Always [0 0]
     C  - The covariance matrix of the best-fit gaussian PDF; always [C1 0 ; 0 C1]
     AMP - The amplitude of the response 
     B - The modulating factor
     FIT_RESPONSES - the fit responses
     R_SQUARED - The error of the fit normalized by the square of the data around its mean
