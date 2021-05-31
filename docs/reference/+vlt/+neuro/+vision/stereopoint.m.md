# vlt.neuro.vision.stereopoint

  vlt.neuro.vision.stereopoint - Compute shifts for a point in space for making a stereograph
 
    [LEFTOFFSET,RIGHTOFFSET]=vlt.neuro.vision.stereopoint(VIEWDIST,EYEDIST,XOFFSET,DOFFSET)
 
 
    Computes projections onto the two eyes for a point in 3D space.
 
    VIEWDIST is the distance to the focal point (or the screen).
    EYEDIST is the distance between the eyes (same units as VIEWDIST).
 
    XOFFSET is the X offset between the focal point and the point in 3 space
      for which to compute shifts. Positive values are to the right, use 
      same units as VIEWDIST.
 
    DOFFSET is the depth offset between the focal point and the point for which
      to compute shifts.
