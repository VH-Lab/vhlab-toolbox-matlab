# vlt.math.ellipse_on_mvnpdf

```
  ELLIPSE_ON_MVNPDF - Calcluate 'response' of an ellipse (or elliptical aperture) on multivariate normal
 
   Y=vlt.math.ellipse_on_mvnpdf(XMESH,YMESH,ELLIPSE_PARAMS,MU,SIGMA)
 
   Computes the overlap of an ellipse (or an elliptical aperature) on a
   multivariate normal distribution.
 
   Inputs:
     XMESH = The X coordinates over which to calculate the response
     YMESH = The Y coordinates over which to calculate the response
     ELLIPSE_PARAMS = a list of column vectors; each column describes 1 ellipse
         the first row has the X_Ctr position, the second row has the Y_Ctr
         position, the third row has the X axis vertex, the fourth row has the
         Y axis vertex, and the fifth row has the rotation (in radians)
         The sixth row is optional; if it is 0, then the ellipse is a filled
         ellipse. If it is -N, then the ellipse describes the aperature of
         stimulation. The aperture is taken to be carved out of a larger circle of
         diameter N.
     MU - The mean for the multivariate normal pdf; can be a column vector or row vector (see MVNPDF)
     SIGMA - the covariance matrix for the multivariate normal pdf (must be 2x2, see MVNPDF)
     Note that the PDF is scaled by the step size of the mesh; it is assumed that
     the mesh step size is constant.
   Outputs:
     Y - The response, in a column vector, for each ellipse
 
   See also: vlt.image.inside_ellipse, MVNPDF

```
