# vlt.time.dowait

   DOWAIT - Pause for a particular amount of time based on platform
 
   vlt.time.dowait(HOWLONG)
 
   Waits the specified amount of time.  If it is on a non-Mac, this function
   assumes it is on a unix machine and call sleep on the shell which does not
   use any processor time.  Otherwise, it calls Matlab's pause function.
 
   See also: PAUSE, man sleep
