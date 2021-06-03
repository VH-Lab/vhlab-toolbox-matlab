# vlt.image.findroiinlinescan

```
  FINDROIINLINESCAN - Find a ROI defined in a raster image in a linescan
 
   [LSINDEXES,ONs,OFFs] = FINDROIINLINESCAN(RASTERIMAGESIZE, LINESCANIMAGESIZE, LINESCANPOINTS,...
                    ROIRASTERINDEXES, [DRIFT])
 
   Given a list of index values of regions of interest (a cell list ROIRASTERINDEXES) that were defined
   within a raster image of size RASTERIMAGESIZE, this function determines the corresponding
   index values LSINDEXES where those pixels were scanned in the linescan LINESCANPOINTS (y, x)
   with image of size LINESCANIMAGESIZE.

```
