# vlt.math.gauss2d_ellipse

  GAUSS2D_ELLIPSE Compute a fullwidth at half-weight ellipse from a 2d gaussian
 
   ELLIPSE_OUT = vlt.math.gauss2d_ellipse(MU, C, [N])
 
   Given a 2-d multivariate normal that is described with a mean MU
   and covariance matrix C, return the size of the major and minor 
   axes at half-height and points for an ellipse that circles the
   mean at the location of the half-height contour.
 
   The equation of the half max ellipse is:
      (x-mu(1))^2 / a^2 + (y-mu(2))^2) / b^2 == 1
 
   N is an optional argument (default 10) that determines the number
   of points to include in each branch of the ellipse graph. (The
   total number of points will be 2*N.)
 
   The structure ELLIPSE_OUT contains the parameters of the ellipse:
   Fieldname          | Description
   -----------------------------------------------------------------
   plot_ellipse       | Ellipse plot points (2 by 2*N); the first 
                      |   row are the X points, the second rows are
                      |   the Y points
   a                  | The value of a in the ellipse equation
   b                  | The value of b in the ellipse equation
   major              | max(a,b) - the major axis
   minor              | min(a,b) - the minor axis
 
 
   w/ contribution by Shen Wang
