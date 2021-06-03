# vlt.math.slidingwindowfunc

```
  vlt.math.slidingwindowfunc - Sliding window analysis for 1-dimensional data
 
        [Yn,Xn,Yint] = vlt.math.slidingwindowfunc(X, Y, START, STEPSIZE, STOP, WINDOWSIZE,...
              FUNC,ZEROPAD,[INTERVALFUNC])
 
   Slides a window of size WINDOWSIZE across the data and performs
   the function FUNC on the set of ordered pairs defined in 
   X and Y.  The window starts at location START and stops at
   location STOP on X.  STEPSIZE determines how far the window is advanced at
   each step.
 
   FUNC should be a string describing the function to be used.  For example:
   'mean',  or 'median'.  
 
   If a third output argument is given, then the standard error of the mean
   in each Xn bin is returned in Yint.  The user can optionally specify his
   own interval function in INTERVALFUNC. The data to be analyzed are put
   into a variable called 'y', so example INTERVALFUNC values are
   'vlt.stats.stderr(y)' or 'diff(prctile(y,[33 66]))'.
   
   If ZEROPAD is 1, then a 0 is coded if no points are found within a given window.
   If ZEROPAD is 0, and if no points are found within a given window, no Xn or Yn point
      is added for that window.
 
   Xn is the center location of each window and Yn is the result of the
   function in each window.

```
