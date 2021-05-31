# vlt.math.slidingwindowfunc2

  SLIDINGWINDOWFUNC2 - Sliding window analysis for 1-dimensional data
 
   [Yn,Xn] = vlt.math.slidingwindowfunc2(X,Y,START,STEPSIZE,STOP,WINDOWSIZE,...
              FUNC,ZEROPAD)
 
   Slides a window of WINDOWSIZE across the data and performs
   the function FUNC on the set of ordered pairs defined in 
   X and Y.  The window starts at location START and stops at
   location STOP on X.  STEPSIZE determines how far the window is
   advanced at each step.
 
   FUNC should be a string describing the function to be used.For example:
   'mean',  or 'median'.  
 
   If ZEROPAD is 1, then a 0 is coded if no points are found within a
        given window.
   If ZEROPAD is 0, and if no points are found within a given window, no
        Xn or Yn point is added for that window.
 
   Xn is the center location of each window and Yn is the result of the
   function in each window.
