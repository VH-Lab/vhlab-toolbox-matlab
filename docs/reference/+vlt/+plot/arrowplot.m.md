# vlt.plot.arrowplot

  ARROWPLOT - Make a plot of arrow shapes, like quiver
 
   H=vlt.plot.arrowplot(X,Y,THETA,SCALE, ...)
 
   Plots arrows at positions X and Y with directions
   THETA (in DEGREES) and scale SCALE, according to the
   properties below, which can be modified by providing
   additional name/value pairs.  The arrow will be rotated to
   point in THETA (in degrees, cartesian form, so
   0 is rightward and angle proceeds counterclockwise).
 
   The arrow length and arrowhead length will be scaled by
   values in SCALE.
 
   The name/value pairs that can be specified:
   Property (default)       : Description
   -------------------------------------------------------
   length (1)               : Line length
   linethickness (2)        : Line thickness
   linecolor ([0 0 0])      : Line color (black by default)
   headangle (30)           : Angle of arrowhead sweep back
   headlength (0.5)         : Size of arrowhead length
   
   See also: vlt.plot.drawshape
