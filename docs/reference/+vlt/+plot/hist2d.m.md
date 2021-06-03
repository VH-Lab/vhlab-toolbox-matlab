# vlt.plot.hist2d

```
 function mHist = hist2d ([vY, vX], vYEdge, vXEdge)
 2 Dimensional Histogram
 Counts number of points in the bins defined by vYEdge, vXEdge.
 size(vX) == size(vY) == [n,1]
 size(mHist) == [length(vYEdge) -1, length(vXEdge) -1]
 
 EXAMPLE
    mYX = rand(100,2);
    vXEdge = linspace(0,1,10);
    vYEdge = linspace(0,1,20);
    mHist2d = vlt.plot.hist2d(mYX,vYEdge,vXEdge);
 
    nXBins = length(vXEdge);
    nYBins = length(vYEdge);
    vXLabel = 0.5*(vXEdge(1:(nXBins-1))+vXEdge(2:nXBins));
    vYLabel = 0.5*(vYEdge(1:(nYBins-1))+vYEdge(2:nYBins));
    pcolor(vXLabel, vYLabel,mHist2d); colorbar

```
