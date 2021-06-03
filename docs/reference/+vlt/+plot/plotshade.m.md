# vlt.plot.plotshade

```
  PLOTSHADE - Make a plot with region above or below a line shaded
 
   H = vlt.plot.plotshade(X,Y,SHADELINE,COLOR,LOCATIONSTRING)
 
   Creates a Matlab PATCH object that colors the area of a plot that lies
   above or below the line Y=SHADELINE, using color COLOR (RGB triple, where
   each element is in [0..1].  LOCATIONSTRING should be 'above' or 'below' to
   indicate whether the shading should occur above or below the SHADELINE.
   A flat line at SHADELINE is drawn at locations where the data should not be
   shaded (developer note: an option to avoid these lines could be added in the
   future).
  
   If SHADELINE is not provided, 0 is assumed.
   If COLOR is not provided, [0 0 0] (black) is assumed.
   LOCATIONSTRING should be 'above' or 'below' (assumed 'below' if it
   is not provided).
 
   Note that vlt.plot.plotshade does not plot the original points x/y. If that
   is desired, the user should plot the line in a separate step.
   
 
   Example: 
     x = 0:0.01:10;
     y = sin(2*pi*x) + 3;
     shadeline = 3;
     figure;
     plot(x,y,'k-');
     hold on;
     vlt.plot.plotshade(x,y,shadeline);

```
