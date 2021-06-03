# vlt.image.roi.ROI_3d_overlap

```
  ROI_3D_OVERLAP - Computes overlap between 3D ROIS in 3D space for different shifts
 
  [OVERLAPA, OVERLAPB] = ROI_3D_OVERLAP(ROIS3D1, ROIS3D2, XRANGE, YRANGE,...
      ZRANGE, IMSIZE)
 
    Inputs:ROIS3D1, ROIS3D2 are indexes
           SPOTDETECTOR3. It has the following fields:
           XRANGE, YRANGE, ZRANGE: we will calculate the overlap over
           shifts of the ROIs in X, Y, and Z. e.g., XRANGE = [ -5 : 1 : 5]
           YRANGE = [ -5 : 1 : 5], ZRANGE = [ -5 : 1 5] computes the
           overlap for all shifts in X, Y, and Z of 5 pixels (in all
           directions).
           IMSIZE - The image size in pixels [NX NY NZ]
    Outputs:
           OVERLAPA(x,y,z) is the fraction of roi3d1 that overlaps roi3d2 when
                  roi3d1 is shifted by XRANGE(x), YRANGE(y), ZRANGE(z) pixels
           OVERLAPB(x,y,z) is the fraction of roi3d2 that overlaps roi3d1 when
                  roi3d1 is shifted by XRANGE(x), YRANGE(y), ZRANGE(z) pixels
 
    See also: ROI_3D_ALL_OVERLAPS

```
