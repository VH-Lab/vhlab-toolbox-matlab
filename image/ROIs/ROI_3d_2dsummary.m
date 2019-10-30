function CC2 = ROI_3d_2dsummary(CC3)
% ROI_3D_2DSUMMARY - return the 2d XY projection of 3d ROIs
%
% CC2 = ROI_3D_2DSUMMARY(CC3, IMAGESIZE)
%
% Given a set of index values that describe 3D ROIs (such as those returned 
% by BWCONNCOMP), this function returns the 2D projection of these
% ROIs onto the first 2 dimensions (X and Y).
%

CC2 = CC3;
CC2.ImageSize = CC2.ImageSize([1 2]);

for i=1:numel(CC3.NumObjects),
	[I,J,K] = ind2sub(CC3.ImageSize, CC3.PixelIdxList{i});
	CC2.PixelIdxList{i} = unique(sub2ind(CC2.ImageSize,I,J));
end;

