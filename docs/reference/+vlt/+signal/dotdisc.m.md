# vlt.signal.dotdisc

 DOTDISC - Dot discriminator, an advanced window discriminator
 
   EVENT_SAMPLES = vlt.signal.dotdisc(DATA, DOTS)
 
   Detect events with "dots", a form of advanced window
   discrimination.
 
   DATA the data to be examined.
  
   DOTS - An N x 3 matrix with the "dots" to be used for the
   discrimination. The first row is [ THRESH  SIGN 0] indicating
   that all events larger than THRESH (in the direction of SIGN,
   which can be 1 or -1) will be considered.  Each additional
   row is [THRESH SIGN OFFSET], and only events that have a
   signal of size THRESH (in the direction of SIGN) at the sample
   location OFFSET relative to the highest/lowest point that
   was determined in the first row will be selected.
 
   EVENT_SAMPLES returns the sample numbers of events that 
   are described by the DOTS. If more than one adjacent sample
   passes the dot tests, then the sample number corresponds to
   the point in the middle of the points that pass.
 
   This is implemented as a mex function.
