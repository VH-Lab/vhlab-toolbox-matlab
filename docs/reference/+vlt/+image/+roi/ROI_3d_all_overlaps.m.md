# vlt.image.roi.ROI_3d_all_overlaps

  ROIS_3D_ALL_OVERLAPS - Compute overlaps between sets of 3D ROIs
 
   [OVERLAP_AB, OVERLAP_BA] = ROI_3D_ALL_OVERLAPS(ROIS3D_A, LA, ...
            ROIS3D_B, LB, XRANGE, YRANGE, ZRANGE, ...);
 
   For 2 sets of ROIS, calculate the overlap of each ROI in A onto each ROI in B,
   and vice-versa.
 
   Inputs: 
      ROIS3D_A and ROIS3D_B are structures returned from a function
        like BWBOUNDARIES with fields 
        'ImageSize'    [1x3]   : the dimensions of the original image
        'NumObjects'   [1x1]   : the number of objects N
        'PixelIdxList' {1xN}   : a cell array of index values for each ROI
      LA and LB are labeled image matrixes, the same size as the original
        image. Each pixel should be labeled with a '0' if it contains no ROI, 
         or i if it is part of the ith ROI. See also BWLABEL
      XRANGE, YRANGE, ZRANGE: calculate the overlap over
           shifts of the ROIs in X, Y, and Z. e.g., XRANGE = [ -5 : 1 : 5]
           YRANGE = [ -5 : 1 : 5], ZRANGE = [ -5 : 1 5] computes the
           overlap for all shifts in X, Y, and Z of 5 pixels (in all
           directions).
    
    Outputs: 
      OVERLAP_AB: The maximum percentage overlap of each ROI in A onto B. OVERLAP_AB(i,j)
        is the maximum amount of the ith ROI in A that overlaps the jth ROI in B, for
        all XRANGE, YRANGE, and ZRANGE shifts.
      OVERLAP_BA: The maximum percentage overlap of each ROI in B onto A. OVERLAP_BA(i,j)
        is the maximum amount of the ith ROI in B that overlaps the jth ROI in A, for
        all XRANGE, YRANGE, and ZRANGE shifts.
 
    This function also accepts extra name/value pairs that modify the default
    behavior of the function:
 
    Parameter name (default)   : Description
    ---------------------------------------------------------------
    ShowGraphicalProgress (1)  : 0/1 Should we show a progress bar?
    Flare MAX(MAX(ABS(XRANGE)),: Integer  How much should we flare out each
       MAX(MAX(ABS(YRANGE)),   :  ROI in A to check for overlaps in B?
         MAX(ABS(ZRANGE)) ))   : (The flare expands the ROI in all directions
                               :  to allow us to look for overlapping ROIs.)
