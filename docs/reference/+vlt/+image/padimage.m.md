# vlt.image.padimage

  PADIMAGE - Add a border to an image
 
   IM_OUT = PADIMAGE(IM_IN, N, PAD)
 
   Adds a border to an image IM_IN. The border
   pixels have value PAD.
 
   IM_IN can be either a 2-D set of points or can be
   a 3-D set of points, in which case it is assumed that
   IM_IN is an RGB or CMYK image. PAD should have dimension 1 in the
   case of a 2D image, or 3 or 4 dimensions in case of a 3-dimensional image.
 
   N can be a single integer if the number of pixels to add to all borders is
   the same in X and Y. Or, N can be a vector [Nx1 Nx2 Ny1 Ny2] that indicates
   that Nx1 points of value PAD should be added before the first dimension
   of IM_IN, and that Nx2 points of value PAD should be added after the first
   dimension, etc.
 
   The result is returned in IM_OUT.
