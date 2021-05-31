# vlt.math.rescale_subrect

  RESCALE_SUBRECT - resize a rectangle within a larger rectangle according to a scale and shift
 
   [NEWRECT] = vlt.math.rescale_subrect(SUBRECT, ORIGINAL_RECT, SCALED_RECT, [FORMAT])
 
   This function rescales a rectangle SUBRECT, whose coordinates are located with
   respect to ORIGINAL_RECT. The same transformation that would be required to scale and
   shift ORIGINAL_RECT to SCALED_RECT is applied to SUBRECT, and returned in NEWRECT.
 
   FORMAT is an optional argument that specifies the format of the rectangles.
   FORMAT == 1 (default) means [left top right bottom]
   FORMAT == 2 means [left bottom right top]
   FORMAT == 3 means [left bottom width height]
   FORMAT == 4 means [left top width height]
 
   See also: vlt.math.rescale, vlt.math.rect2rect
