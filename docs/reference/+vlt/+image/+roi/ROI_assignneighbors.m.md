# vlt.image.roi.ROI_assignneighbors

  ROI_3D_ASSIGNNEIGHBORS - assign neighbors to adjacent ROIs
 
  L_OUT = ROI_ASSIGNNEIGHBORS(L, IM, INDEXES_TO_SEARCH)
 
  Searches the labeled ROI matrix L for unlabeled pixels (in 
  INDEXES_TO_SEARCH), and assigns these pixels be part of an immediately
  neighboring ROI. The brightest neighboring pixel in IM is used to determine
  which ROI will be assigned. 
 
  This function is useful after WATERSHED resegmentation, which leaves a 1 pixel
  boundary between the resegmented ROIs.
  
  Example:
    A = zeros(6,6);
    A(3,2) = 2;
    A(3,3) = 1;
    A(3,4) = 3;
    L = bwlabel(A)
    indexes_to_search = find(L);
    L2 = L;
    L2(3,3) = 0;
    L2(3,2) = 2  % segment the initial ROI into 2 with a 1 pixel border
                 % might mimic output of WATERSHED
    L_out = ROI_assignneighbors(L2, A, indexes_to_search)
