# vlt.ui.findclosestpointclick

```
  FINDCLOSESTPOINT - Find the closest point to where a user clicked
 
   [I,PT] = vlt.ui.findclosestpointclick(POINTLIST)
     or 
   [I,PT] = vlt.ui.findclosestpointclick(POINTLIST, SCALE)
 
   Examines the 'CurrentPoint' in the current axes, and sees
   which of the points in POINTLIST is closest to the 'CurrentPoint'.
   The index of the point in POINTLIST is returned in I, and the 
   actual X/Y pair of the point are in PT.
 
   By default, the function does not use the absolute Euclidean distance
   but rather scales the points by the current view on the axes. This is useful
   if the X scale is very different from the Y scale; usually when clicking the
   user wants the closest point in screen coordinates. One can modify this
   behavior by passing SCALE and setting it to 0, and true Euclidean distance
   will be used.  By default SCALE is 1.
 
   POINTLIST should be in the format of 1 point per row.
   If POINTLIST is in 3-space (3D) then a 3D comparison is made.
   If POINTLIST is in 2-space (2D) then a 2D comparison is made.
  
   See also: vlt.data.findclosest, vlt.data.findclosestpoint

```
