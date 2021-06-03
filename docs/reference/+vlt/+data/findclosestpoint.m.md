# vlt.data.findclosestpoint

```
  FINDCLOSESTPOINT - Find the closest corresponding point in a list
 
  [I,POINTC] = vlt.data.findclosestpoint(POINTLIST,POINT)
 
  Finds the index and value to the closest member of POINTLIST to POINT
  in Euclidean distance. POINTLIST should be a list of points, with 1 
  row per point. It returns the index in I and the value
  in POINTC.  If ARRAY is empointy, so are I and POINTC.
 
  If there are multiple occurances of POINT within POINTLIST,
  only the first is returned in I.
 
  See also: FIND, vlt.data.findclosest

```
