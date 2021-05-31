# vlt.image.roi.ROI_centerofmassdistance

  ROI_CENTEROFMASSDISTANCE - Compute center-of-mass distances between sets of ROIs
 
  [COMD] = ROI_CENTEROFMASSDISTANCE(ROI_COM_A, LA, ROI_COM_B, LB, ...
              DISTANCE_MAX, DISTANCE_MIN, ...);
 
  For 2 sets of ROIS, calculate the center-of-mass distances for all ROIs closer than
  DISTANCE_MAX.
 
   Inputs: 
      ROI_COM_A and ROI_COM_B are NUM_ROIS x DIM_ROI matrixes with the center of mass
        coordinates in each row. 
      LA and LB are labeled image matrixes, the same size as the original
        image. Each pixel should be labeled with a '0' if it contains no ROI, 
         or i if it is part of the ith ROI. See also BWLABEL
      DISTANCE_MAX the maximum distance over which to search for center-of-mass distance.
         This is important because if the number of ROIs in A and B are large, then a full
         matrix describing ROI overlaps would require several hundred GB of memory and is usually
         not worth counting.
      DISTANCE_MIN If any distance is 0, it will be set to DISTANCE_MIN. 0 is reserved for 
         too-long distances beyond DISTANCE_MAX so that COMD can be sparse (mostly 0s).
