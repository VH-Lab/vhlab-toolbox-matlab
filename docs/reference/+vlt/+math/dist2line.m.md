# vlt.math.dist2line

  DIST2LINE - Computes distance between point and line, and closest point
 
  [D,X1,Y1] = DIST2ILNE(M,B,Z)
 
   Computes the distance D from a point Z = [ X0 Y0] to a line
   defined by Y = M * X + B.  The point [X1 Y1] is the closest
   point on line Y to point Z = [X0 Y0].  If M is Inf then B is assumed
   to be X location of the line.
