# vlt.image.roi.ROI_3d2dprojection

  ROI_3D2DPROJECTION - Project a 3D ROI onto a 2D projection
    
     [INDEXES2D, PERIMETER2D] = ROI3D2DPROJECTION(INDEXES3D, ...
                              IMAGESIZE, ZDIM)
 
   Identifies the 2D projection of a 3-dimensional ROI with
   index values in 3D space called INDEXES3D. The INDEXES3D describe
   the values within a 3D image of size IMAGESIZE = [NX NY NZ].
   
   The projection is made onto the Z dimension ZDIM, which can vary
   from 1 to NZ.
 
   PERIMETER2D is a list of perimeter values around all pieces of the
   3d ROI in the 2d representation.  It is a a cell list because the
   object can exist in multiple distinct pieces within the 2d view.
