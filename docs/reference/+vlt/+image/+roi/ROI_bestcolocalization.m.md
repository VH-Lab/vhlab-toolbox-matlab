# vlt.image.roi.ROI_bestcolocalization

```
  ROI_BESTCOLALIZATION - find the best colocalization match for an ROI
 
  BC = ROI_BESTCOLOCALIZATION(OVERLAPS_BA, OVERLAP_THRESHOLD, ...
     [PROPERTY_A, PROPERTY_B])
 
  Identifies the best localization match for each ROI in set B onto set
  A, assuming the overlap exceeds a threshold.
 
  The "best match" is determined by the largest OVERLAP, unless an array of properties for
  ROI set A PROPERTY_A and ROI set B PROPERTY_B, in which case the closest match
  (smallest difference).

```
