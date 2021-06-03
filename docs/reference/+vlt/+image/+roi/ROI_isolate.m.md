# vlt.image.roi.ROI_isolate

```
  ROI_ISOLATE - Return the index values within an ROI of of an isolated cube that encompasses ROI
 
  [ISOLATE_INDEXES, ISOLATE_INDEXES_IN_ROI] = ROI_ISOLATE(IMSIZE, INDEXESND)
 
  Given an ROI in an image of size IMSIZE with indexes INDEXESND, return the index values in
  an isolated N-D cube that correspond to index values in the original image.
 
  Inputs:
    IMSIZE should be the size of the image [SZ1 SZ2 ... SZN]
    INDEXESND are the index values of the ROI in the image
  Outputs:
    ISOLATE_INDEXES are a mapping between the minimum N-D cube that can
       contain the ROI and the ROI's indexes in the image. ORIG_IM(ISOLATE_INDEXES) = MINCUBE.
       ISOLATE_INDEXES have the shape of the minimum cube.
    ISOLATE_INDEXES_IN_ROI is a 0-1 vector the same size as ISOLATE_INDEXES. Entries are 1 if
       the voxel is contained in the ROI specified by INDEXESND
 
   Example:
         imsize = [ 3 3 3 ];
         indexesnd = [ 14 15 17 18 23 24 26 ];
            % this is an ROI in the bottom right corner of a 3x3x3 cube except the edge point
            % to see where this is, use reshape(1:27,3,3,3)
         [isolate_indexes, isolate_indexes_in_roi] = ROI_isolate(imsize, indexesnd)

```
