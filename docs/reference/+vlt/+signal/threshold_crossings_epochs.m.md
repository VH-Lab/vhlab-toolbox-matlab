# vlt.signal.threshold_crossings_epochs

```
 THRESHOLD_CROSSINGS_EPOCHS Detect threshold crossing epochs in data and the corresponding peaks
  
   [INDEXES_UP,INDEXES_DOWN,INDEXES_PEAKS] = vlt.signal.threshold_crossings_epochs(INPUT, THRESHOLD)
 
   Finds all places where the data INPUT transitions from below
   the threshold THRESHOLD to be equal to or above the threshold
   THRESHOLD, and returns these index values in INDEXES_UP. Note that
   any threshold crossing that is unaccompanied by a subsequent downward
   transition is not counted.
   
   Next, it finds all places where the data INPUT transitions from above
   the threshold to below threshold, and returns these index values in
   INDEXES_DOWN. Note that downward transitions must be associated with an
   upward transitions, and are excluded if the first samples are above threshold.
   (That is, the first downward transition must follow an upward transition present
   in INPUT.)
 
   Finally, the indexes corresponding to the locations with the largest suprathreshold
   values between each UP and DOWN transition are returned in INDEXES_PEAK.
 
   See also: vlt.signal.threshold_crossings

```
