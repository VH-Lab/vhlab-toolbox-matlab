function [overlapa,overlapb]= ROI_3d_overlap(rois3d1, rois3d2, xrange, yrange, zrange, imsize)
% ROI_3D_OVERLAP - Computes overlap between 3D ROIS in 3D space for different shifts
%
% [OVERLAPA, OVERLAPB] = ROI_3D_OVERLAP(ROIS3D1, ROIS3D2, XRANGE, YRANGE,...
%     ZRANGE, IMSIZE)
%
%   Inputs:ROIS3D1, ROIS3D2 are indexes
%          SPOTDETECTOR3. It has the following fields:
%          XRANGE, YRANGE, ZRANGE: we will calculate the overlap over
%          shifts of the ROIs in X, Y, and Z. e.g., XRANGE = [ -5 : 1 : 5]
%          YRANGE = [ -5 : 1 : 5], ZRANGE = [ -5 : 1 5] computes the
%          overlap for all shifts in X, Y, and Z of 5 pixels (in all
%          directions).
%          IMSIZE - The image size in pixels [NX NY NZ]
%   Outputs:
%          OVERLAPA(x,y,z) is the fraction of roi3d1 that overlaps roi3d2 when
%                 roi3d1 is shifted by XRANGE(x), YRANGE(y), ZRANGE(z) pixels
%          OVERLAPB(x,y,z) is the fraction of roi3d2 that overlaps roi3d1 when
%                 roi3d1 is shifted by XRANGE(x), YRANGE(y), ZRANGE(z) pixels
%
%   See also: ROI_3D_ALL_OVERLAPS
%

[i,j,k] = ind2sub(imsize,rois3d1);
count=0;

for xi=1:length(xrange),
	x = xrange(xi);
	for yi=1:length(yrange),
		y = yrange(yi);
		for zi=1:length(zrange),
			z = zrange(zi);

			% step 1: shift the rois3d1 by x, y, and z and get the
			% index values of that shift

			count=count+1;

			shifted_x = i+x;
			shifted_y = j+y;
			shifted_z = k+z;

            		good_x = find(shifted_x>=1 & shifted_x<=imsize(1));
			good_y = find(shifted_y>=1 & shifted_y<=imsize(2));
			good_z = find(shifted_z>=1 & shifted_z<=imsize(3));

			good = intersect(intersect(good_x, good_y), good_z);

			if length(good)>0
				rois3d_shifted = sub2ind(imsize, shifted_x(good), shifted_y(good), shifted_z(good));
			else
				rois3d_shifted = [];
			end;

			% step 2: calculate the overlap of the shifted rois3d1 and rois3d2
			intersection = length(intersect(rois3d_shifted,rois3d2));
	%		overlap(count) = intersection / length(rois3d2);
			overlapa(xi,yi,zi) = intersection / length(rois3d1);
			overlapb(xi,yi,zi) = intersection / length(rois3d2);
	%		shifts{1}(xi,yi,zi) = x;
	%		shifts{2}(xi,yi,zi) = y;
	%		shifts{3}(xi,yi,zi) = z;

		end;
	end;
end;

