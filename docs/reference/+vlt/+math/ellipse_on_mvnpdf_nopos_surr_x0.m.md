# vlt.math.ellipse_on_mvnpdf_nopos_surr_x0

  ELLIPSE_ON_MVNPDF_NOPOSITION_X0 - Calcluate 'response' of an ellipse on multivariate normal with fixed position, linear modulation
 
   Y=ELLIPSE_ON_MVNPDF_NOPOSITION_SURR_X0(X,ELLIPSE_PARAMS,XMESH,YMESH)
 
   Computes the overlap of an ellipse on a multivariate normal distribution.
 
   This form facilitates passing to LSQCURVEFIT because the parameters MU and
   SIGMA are all passed in a vector, X0
 
   Inputs:
     X0 - A vector with the multivariate normal parameters minus position
            (only covariance matrix position c11/c22 (must be same) and an amplitude)
         SIGMA=[X0(1); 0; 0 XO(1)] - the covariance matrix for the multivariate normal pdf
         ALPHA = X0(2) - scale factor
         B = X0(3) - A scale factor for the modulation component
     ELLIPSE_PARAMS = a list of column vectors; each column describes 1 ellipse
         the first row has the X_Ctr position, the second row has the Y_Ctr
         position, the third row has the X axis vertex, the fourth row has the
         Y axis vertex, and the fifth row has the rotation (in radians)
         Optionally, a sixth row can be 0 (if the stimulus is an ellipse) or
         N (if the stimulus is an aperture on an ellipse of N pixels)
         
     XMESH = The X coordinates over which to calculate the response
     YMESH = The Y coordinates over which to calculate the response
   Outputs:
     Y - The response, in a column vector, for each ellipse
 
   See also: vlt.image.inside_ellipse, MVNPDF
