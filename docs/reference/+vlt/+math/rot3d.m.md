# vlt.math.rot3d

```
  ROT3D - Rotation in 3d space
    R = vlt.math.rot3d(THETA, AXIS)
 
   Performs a 3d rotation about one of the 3-dimensional axes or an arbitrary axis.
   If AXIS == 1, the rotation is performed about the X axis (dimension 1).
   If AXIS == 2, the rotation is performed about the Y axis (dimension 2).
   If AXIS == 3, the rotation is performed about the Z axis (dimension 3).
   If AXIS is a vector of 3, then the rotation is performed about that
   vector. The vector is first normalized.
 
   Examples:
     x_unit = [1;0;0];
     y_unit = [0;1;0];
     z_unit = [0;0;1];
     R = vlt.math.rot3d(pi/2,1)
     R * x_unit % 45 degree rotation about x axis, no change in x_unit
     R = vlt.math.rot3d(pi/2,x_unit) % should be the same rotation as above
     % now rotate the y_unit about the x axis
     R * y_unit % moves from [0;1;0] to [0;0;1]
   
   See also: vlt.math.rot2d

```
