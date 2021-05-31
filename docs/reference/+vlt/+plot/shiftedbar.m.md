# vlt.plot.shiftedbar

  vlt.plot.shiftedbar - Shifted bar graph
 
   HB = vlt.plot.shiftedbar(BINS, DATA, SHFT, COL)
 
   Draws a bar graph that is shifted from the X-axis by SHFT and using color
   COL (a 1x3 RGB color).  If BINS and DATA have multiple rows, then
   multiple graphs are drawn, and SHFT can be a vector giving the offset for
   each graph and COL can be nx3, describing the color for each graph.
   HB is the set of patch handles created during the drawing.
 
   vlt.plot.shiftedbar assumes one is plotting histogram data, so BINS should have one
   more column than DATA, since DATA(i,j) is the number of points between
   BINS(i,j) and BINS(i,j+1).
 
   See also:  BAR, BARH, HIST, HISTC
