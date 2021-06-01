# vlt.image.roi.ROI_subset

  ROI_subset - return a subset of ROIs in a structure CC
 
  CCSUBSET = ROI_SUBSET(CC, INDEXES)
 
  Creates a new ROI structure CCSUBSET from one in CC with subfields
     'Connectivity', 'NumObjects', 'ImageSize', and 'PixelIdxList' entries
     such as those returned from BWCONNCOMP. 
     The field 'NumObjects' is set to the number of elements of INDEXES
     and PixelIdxList will have only those entries in INDEXES.
