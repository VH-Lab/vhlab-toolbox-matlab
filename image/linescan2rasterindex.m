function inds = linescan2rasterindex(imsize, linescanpoints)
% LINESCAN2RASTERINDEX - Determine index values within a raster that correspond to points visited by a linescan
%
%   INDS = LINESCAN2RASTERINDEX(IMSIZE, LINESCANPOINTS)
%
%   Calculates the index values within a raster image of size IMSIZE that
%   correspond to points on the linescan LINESCANPOINTS.  LINESCANPOINTS
%   should be an N x 2 vector of points in units of pixels; column 1 corresponds
%   to Y pixels and column 2 corresponds to X pixels.
%
%   INDS is a list of index values such that RASTERIMAGE(INDS(n)) corresponds
%   to the nth pixel in the linescan.  If the linescan is "out of bounds" at
%   point i, then then INDS(i) is NaN.
%

xpixels = round(linescanpoints(:,2));
ypixels = round(linescanpoints(:,1));
xpixels(find(xpixels<1))=NaN;
ypixels(find(ypixels<1))=NaN;
xpixels(find(xpixels>imsize(1)))=NaN;
ypixels(find(ypixels>imsize(2)))=NaN;
inds = uint32(sub2ind(imsize, xpixels, ypixels));
badinds = find(inds<=0);
inds(badinds) = NaN;

