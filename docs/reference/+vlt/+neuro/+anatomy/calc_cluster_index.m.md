# vlt.neuro.anatomy.calc_cluster_index

  vlt.neuro.anatomy.calc_cluster_index - Calculate cluster index from Ruthazer and Stryker
 
    CI = vlt.neuro.anatomy.calc_cluster_index(CELL_PTS, ROI_PTS, SCALE, INJ_SIZE, WINDSIZE,
            WINDSTEP, AREA_THRESH, FRACT_CELLS, [INDEXVALUES FUNC RANDFUNC])
 
   Calculates the cluster index as described by Ruthazer and Stryker
   JNeurosci 1996 16:7253-7269.
 
   Computes the cluster index over a region of interest drawn tightly
   around the data set excluding the injection site of size INJ_SIZE.  Square
   windows of side size WINDSIZE are slid over the region of interest in
   steps of WINDSTEP.  If the overlap of the window and the region of interest
   is at least AREA_THRESH (a fraction of the total), then the cluster index
   is computed in that window.
   ROI_PTS and INJ_SIZE can be empty, in which case no points will be excluded,
   the ROI will be taken to be a rectangle containing all points, the first
   point in the cell list is assumed to be a cell and not the injection 
   location.
 
   The cluster index is computed by comparing nearest neighbor differences
   of all cells in the data set to a random point.  Only FRACT_CELLS are used
   in the calculation.  See the paper for a more complete description.
 
   The cells are specified as a list of X-Y pairs.  It is assumed that the first
   entry in the list is actually the injection location, not a cell.
   The region of interest is also specified by a list of X-Y pairs that
   define a polygon around the region of interest.  The points will be scaled
   by SCALE, which indicates the number of point units per unit.
 
   If the last three optional arguments are provided, then the cluster index is not 
   computed based on physical distance between cells but rather the difference between
   index values in INDEXVALUES, a vector w/ as many entries as there are cell points.
   FUNC should be a string describing how to take the difference between x1 and x2,
   INDEX values from two cells.  For example, 'min(abs([x1-x2;x1-x2-360;x1-x2+360]))'
   or 'abs(x1-x2)'.  RANDFUNC is a function that describes how to randomly generate
   an index value.  For example, RANDFUNC = 'rand*360' picks a value between 0 and
   360 psuedorandomly.
