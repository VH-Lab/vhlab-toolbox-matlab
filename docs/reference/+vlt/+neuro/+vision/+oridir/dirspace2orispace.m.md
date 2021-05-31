# vlt.neuro.vision.oridir.dirspace2orispace

  DIRSPACE2ORISPACE - Converts direction responses to orientation responses
 
   [ANGLES_ORI,RESPONSES_ORI] = vlt.neuro.vision.oridir.dirspace2orispace(ANGLES, RESPONSES)
 
   Converts direction responses and angles of stimulation into orientation space.
 
   Each angle in ANGLES that goes around the clock in direction space (ranging
   from 0 to 360 degrees) is converted to an orientation ranging from 0 to 180
   degrees and returned in ANGLES_ORI.  The new ANGLES_ORI is a column vector
   (regardless of the form of the input ANGLES).
 
   RESPONSES_ORI(A,R) is a matrix of all RESPONSES R that map to the orientation 
   A.  In the event that there are not an equal number of responses to each
   orientation, extra entries in the matrix will be NaN.
