# vlt.image.plotrasterroionlinescan

  PLOTRASTERROIONLINESCAN - Plot an ROI defined in an raster image on a linescan image
 
   [H] = PLOTRASTERROIONLINESCAN(LINESCANIMAGE,RASTERIMSIZE,ROIINDS,...
         LINESCANPOINTS,[DR],...);
 
 
   Inputs:
       LINESCANIMAGE - An NxM image of a linescan recording, where N is the number of 
           lines and M is the number of data points per line
       RASTERIMSIZE - Raster image size NxM
       ROIINDS - Index values corresponding to the ROI
       LINESCANPOINTS - the points of the linescan on the raster image
       DR - any drift that might have occurred over the recording
 
   Extra arguments can be given as name/value pairs:
 
    CONTOURS              |  Plot contours around ROIs (default 1)
    INDEXES               |  Fill index values of ROI (default 0)
