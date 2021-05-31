# vlt.plot.plotoribox

  PLOTORIBOX - Plot an oriented box (as a patch) on a graph 
  
    H = vlt.plot.plotoribox(X,Y,ORI,WIDTH,HEIGHT,REVY)
 
    Plots an oriented bar centered on the position X, Y with
    orientation ORI (in degrees, in compass coordinates; that is,
    0 degrees is a horizontal bar, and the bar tilts in a clockwise
    manner with increasing angle). The bar has the width WIDTH and
    height HEIGHT.  If REVY is 1, then we assume that the Y axis direction
    is reversed, and the orientated bar is mirror-reversed in Y.
 
    This function can also take extra parameters as NAME/VALUE pairs.
    PARAMETER (default):     |  DESCRIPTION:
    ---------------------------------------------------------
    col ([0 0 0])            |  Fill color of the bar (default is
                             |    black [0 0 0]; white would be
                             |    [1 1 1]
