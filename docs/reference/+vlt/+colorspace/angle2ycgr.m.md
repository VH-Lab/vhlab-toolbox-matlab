# vlt.colorspace.angle2ycgr

```
  ANGLE2YBRG - Determine color by angle 0-360 degrees
 
  [CTAB, VALUE, RGB] = ANGLE2YCGR([ANGLE])
 
  Returns a color table for angle values 0:1:359. If a specific
  ANGLE is given as an an input argument, the function will also return
  the (interpolated) value of the ANGLE in the space of the color table CTAB,
  and the interpolated RGB value.
 
  The color space ranges from yellow ([1 1 0]) at 0 degrees, to green at
  90 degrees ([0 1 0]), to cyan at 180 degrees ([0 1 1]), to red ([1 0 0])
  at 270 degrees, and back to yellow at 360 degrees/0 degrees.
 
  See also: ANGLE2YBGR
 
  Examples:
    ctab = angle2ycgr; % (can serve as a color map for angle data)
 
    angle = 5.5;
    [ctab, value, rgb] = angle2ycgr(angle);

```
