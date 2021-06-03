# vlt.image.doublethresholdresegment

```
  DOUBLETHRESHOLD - apply a double threshold to an image
  
  BIN = DOUBLETHRESHOLDRESEGMENT(IM, T1, T2, CONNECTIVITY, RAW_IM, RESEGMENT_NAMEVALUEPAIRS)
 
  Calculate a binary image based on 2 thresholds. First, binary images are
  calculated based on each threshold. Second, ROIs are discovered from each 
  binary image using BWCONNCOMP. Then, ROIs generated from the lower threshold
  are examined to see if they overlap any part of an ROI from the higher
  threshold. Only objects that overlap the higher threshold will be retained.
 
 
  RESEGMENT_NAMEVALUEPAIRS are the name/value pairs to pass to ROI_resegment
 
  Finally, a binary image is created from the ROIs that remain and is
  returned in BIN.
 
  See also: vlt.image.roi.ROI_resegment_all

```
