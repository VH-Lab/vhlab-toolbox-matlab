# vlt.plot.movetofront

```
  vlt.plot.movetofront - Move a plot to the "front" of the "paper"
 
   vlt.plot.movetofront(PLOT_H)
 
   Moves the plot specified by the plot handle PLOT_H to
   the "front" of the paper in the current axis.
 
   Example:
       figure; hold on;
       h1 = plot([0 1],[0 1],'k','linewidth',2);
       h2 = plot([0.5 0.5],[0 1],'r','linewidth',2);
       % at this point, the red line in h2 is "above"
       % the black line in h1
       vlt.plot.movetofront(h1);
       % now the black line is in "front"
 
   PLOT_H can be a single handle or an array of handles.

```
