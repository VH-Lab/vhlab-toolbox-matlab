# vlt.image.roi.ROI_resegment_all

```
  ROI_RESEGMENT_ALL - resegment ROIs from an image (such as with WATERSHED), updating ROIs and labeled image
  
  [CC, L] = ROI_RESEGMENT_ALL(CC, L, IM, ...)
 
  Returns a modified set of ROIs given a labeled image L, a list of ROIs returned from BWCONNCOMP (CC)
  and the original image IM. 
  
  This function takes parameters as name/value pairs that modify its behavior:
  Parameter (default)                 | Description
  ------------------------------------------------------------------------------
  resegment_namevaluepairs ({})       | Name/value pairs to pass to ROI_resegment
                                      |   (see HELP ROI_RESEGMENT)
  rois_to_update ([1:CC.NumObjects])  | Index values of ROIs to update (can be a subset)
  UseProgressBar (1)                  | Should we use a progress bar? (0/1)
 
 
  Example:
      myimg = ROI_imageexample;
      imagedisplay(myimg);
      BW = myimg>1e-3;
      CC_orig = bwconncomp(BW);
      L_orig = labelmatrix(CC_orig);
      figure, imshow(label2rgb(L_orig));
      [CC_new,L_new] = ROI_resegment_all(CC_orig, L_orig, myimg);
      figure, imshow(label2rgb(L_new));

```
