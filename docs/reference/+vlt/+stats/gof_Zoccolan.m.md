# vlt.stats.gof_Zoccolan

  vlt.stats.gof_Zoccolan - Goodness of Fit from Zoccolan et al., 2005
 
   [GF,Vres,Vexpl,Vnoise] = vlt.stats.gof_Zoccolan(TRIALDATA, FIT)
 
  Returns goodness of fit that describes how much of the explainable
  variation (i.e., that not due to noise across trials) is explained
  by a given fit.
  
  TRIALDATA should have M columns and N rows.  Each column should have
    individual responses for one particular stimulus.  If any values are
    NAN then these trials are excluded.
 
  FIT is a fit to the mean response to each stimulus and should be 1xN.
 
  GF is the goodness of fit measure from 0 to 1
  Vres is the residual variance left over from the fit
  Vexpl is the explainable variance
  Vnoise is the variance of the noise
 
  Ref:  Zoccolan DE, Cox DD, DiCarlo, JJ.  J Neurosci 25:8150-8164 2005.
