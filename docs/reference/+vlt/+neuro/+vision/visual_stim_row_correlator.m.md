# vlt.neuro.vision.visual_stim_row_correlator

  VISUAL_STIM_ROW_CORRELATOR - Compute the next visual stimulus frame for a given correlator
 
   NEXT_FRAME = vlt.neuro.vision.visual_stim_row_correlator(FRAME_DATA, CORRELATOR, SIGN)
 
   Given a frame of visual stimulus data that consists of -1's and 1s
   (FRAME_DATA), then a new frame (NEXT_FRAME) of -1's and 1s is created
   such that the correlation between the new frame and the old frame is
   as described in CORRELATOR (see below).
 
   The algorithm operates on the rows of the stimulus, so that if the
   stimulus frame has many rows, each row will be operated on independently.
 
   CORRELATOR: A number that indicates which correlator to use
      0: 2-point leftward correlator
      1: 2-point rightward correlator
      2: 3-point converging leftward correlator
      3: 3-point converging rightward correlator
      4: 3-point diverging leftward correlator
      5: 3-point diverging rightward correlator
 
   SIGN: the sign of the correlator; should the product be -1 or 1?
 
   For a graphical depiction of these correlators, see Clark, Fitzgerald, and Ales et al.,
   Nature Neuroscience 2014 (in particular, Supplementary Figure 4)
 
   Example: Compute 10 frames for a single row, using a leftward 2-point correlator (sign 1)
       correlator = 0;
       corelator_sign = 1;
       row_data = [ 1 1 -1 1 -1 -1 1 1]; % made up data
       for i=1:10,
          row_data(i+1,:) = vlt.neuro.vision.visual_stim_row_correlator(row_data(i,:),correlator,correlator_sign);
       end;
       row_data,
