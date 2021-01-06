function [indexes2d, perimeter2d] = roi_3d2dprojection(indexes3d, imagesize, zdim)
% ROI_3D2DPROJECTION - Project a 3D ROI onto a 2D projection
%   
%    [INDEXES2D, PERIMETER2D] = ROI3D2DPROJECTION(INDEXES3D, ...
%                             IMAGESIZE, ZDIM)
%
%  Identifies the 2D projection of a 3-dimensional ROI with
%  index values in 3D space called INDEXES3D. The INDEXES3D describe
%  the values within a 3D image of size IMAGESIZE = [NX NY NZ].
%  
%  The projection is made onto the Z dimension ZDIM, which can vary
%  from 1 to NZ.
%
%  PERIMETER2D is a list of perimeter values around all pieces of the
%  3d ROI in the 2d representation.  It is a a cell list because the
%  object can exist in multiple distinct pieces within the 2d view.
%

NX = imagesize(1);
NY = imagesize(2);
NZ = imagesize(3);

[roi2d] = indexes3d - (zdim-1)*(NX * NY);
[indexes2d] = roi2d(find(roi2d >= 1 & roi2d <= (NX * NY)));
perimeter2d = {};

if nargout>=2 & ~isempty(indexes2d),

	[x_values, y_values] = ind2sub([NX NY],indexes2d);
	xmin = min(x_values);
	xmax = max(x_values);
	ymin = min(y_values);
	ymax = max(y_values);
	shifted_indexes2d = sub2ind([xmax-xmin+1 ymax-ymin+1],1+x_values-xmin,1+y_values-ymin);

	imblank = logical(zeros(xmax-xmin+1,ymax-ymin+1));
	imblank(shifted_indexes2d) = logical(1);
	perimeter2d = bwboundaries(imblank,'noholes');
	if isempty(perimeter2d),
		perimeter2d = {};
	else,
		% need to shift by xmin/ymin
		for i=1:numel(perimeter2d),
			perimeter2d{i}(:,1) = perimeter2d{i}(:,1) + (xmin-1);
			perimeter2d{i}(:,2) = perimeter2d{i}(:,2) + (ymin-1);
		end
	end;

	
	%imblank = logical(zeros(NX,NY));
	%imblank(indexes2d) = logical(1);
	%perimeter2d = bwboundaries(imblank,'noholes'); % must be a faster way
	%if isempty(perimeter2d), perimeter2d = {}; end;

	% this doesn't do it, this computes the length of the perimeter
	%	CC = struct('Connectivity',6,'ImageSize',[NX NY],'NumObjects',1);
	%	CC.PixelIdxList = {indexes2d};
	%	perimeter2d = regionprops(CC,'Perimeter');
end;


