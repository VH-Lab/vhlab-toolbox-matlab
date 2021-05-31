# vlt.plot.supersubplot

  SUPERSUBPLOT - Organize axes across multiple figures
 
   AX_H=vlt.plot.supersubplot(FIG, M, N, P)
 
   Returns a set of axes that can be arranged across multiple
   figures.
 
   Inputs:
       FIG - figure number of the first figure in series
       M - The number of rows of plots in each figure
       N - the number of columns of plots in each figure
       P - the plot number to use, where the numbers go
             from left to right, top to bottom, and then
             continue across figures.
 
   Outputs: AX_H - the axes handle
 
   Example:
        fig = figure;
        ax = vlt.plot.supersubplot(fig,3,3,12);
        % will return a subplot in position 3
        % on a second figure
     
   See also: SUBPLOT, AXES
