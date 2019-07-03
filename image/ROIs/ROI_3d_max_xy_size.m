function max_xy_size = ROI_3d_max_xy_size(CC)
% ROI_3D_MAX_XY_SIZE - compute the maximum X/Y size of a 3-d ROI
%
% MAX_XY_SIZE = ROI_3D_MAX_XY_SIZE(CC)
%
% Given a structure of regions-of-interest such as that returned by
% BWCONNCOMP, with fields 'ImageSize' and 'PixelIdxList', this function
% examines all Z planes and computes the area (in pixels) of each
% ROI in X and Y (dimensions 1 and 2). The maximum such value is returned
% in MAX_XY_SIZE(i), for each ROI in CC (i goes from 1 .. numel(CC.PixelIdxList)).
%
% Example:
%     % make a simple image
%     A = zeros(3,11);
%     A(1,:) = 1;
%     A(2,1) = 1; 
%     A(:,:,2) = 0*A(:,:,1);
%     A(1,1,2) = 1;
%     A, % view A
%     CC = bwconncomp(A);
%     max_xy_size = ROI_3d_max_xy_size(CC)
%

max_xy_size = -Inf * ones(1,numel(CC.PixelIdxList));

for z=1:CC.ImageSize(3),
	for j=1:numel(CC.PixelIdxList),
		indexes_here = ROI_3d2dprojection(CC.PixelIdxList{j}, CC.ImageSize, z);
		max_xy_size(j) = max( max_xy_size(j), numel(indexes_here) );
	end;
end;


