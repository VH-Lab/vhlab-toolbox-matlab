# vlt.image.roi.ROI_resegment

```
  ROI_RESEGMENT - resegment an ROI using an algorithm like WATERSHED
 
  [CC] = ROI_RESEGMENT(IM, INDEXESND, ...)
 
  Given pixel index values of an ROI in an image IM, ROI_RESEGMENT re-evalutes 
  the ROI using a segmenting function like WATERSHED. It returns a structure of new
  ROIs CC with fields as follows:
  Field                                | Description
  --------------------------------------------------------------
  'Connectivity'                       | The connectivity used (see name/value pairs)
  'ImageSize'                          | size(IM)
  'NumObjects'                         | The number of resegmented ROIs found
  'PixelIdxList'                       | A cell array of pixel index values of the resegmented ROIs
 
  This function also takes name/value pairs that modify its operation:
  Parameter (default)                  | Description
  -------------------------------------------------------------------
  'resegment_algorithm' ('watershed')  | Function that is called to resegment.
  'values_outside_roi' (0)             | What should values outside INDEXESND be set to?
                                       |   Use NaN to use the values from IM (even though
                                       |   they are outside ROI)
  'use_bwdist' (0)                     | Should we use the binary distance transform for
                                       |   the ROI data (1), or the raw data from IM (0)?
  'connectivity'                       | The connectivity to use with the resegment algorithm.
    (CONNDEF(NDIMS(IM),'maximal'))     |   (See HELP WATERSHED). If 0 is given, default is used.
  'invert' (1)                         | If using raw data, multiply the image by -1
  'assign_neighbors_to_roi' (1)        | Resegmentation algorithms often leave a 1 pixel border 
                                       |   between ROIs. If 'assign_neighbors_to_roi' is 1, then
                                       |   these pixels are assigned to their brightest immediately
                                       |   neighboring pixels.

```
