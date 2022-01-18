function max_xy_size = ROI_3d_max_xy_size(CC, varargin)
% ROI_3D_MAX_XY_SIZE - compute the maximum X/Y size of a 3-d ROI
%
% MAX_XY_SIZE = ROI_3D_MAX_XY_SIZE(CC, ...)
%
% Given a structure of regions-of-interest such as that returned by
% BWCONNCOMP, with fields 'ImageSize' and 'PixelIdxList', this function
% examines all Z planes and computes the area (in pixels) of each
% ROI in X and Y (dimensions 1 and 2). The maximum such value is returned
% in MAX_XY_SIZE(i), for each ROI in CC (i goes from 1 .. numel(CC.PixelIdxList)).
%
% This function also takes NAME/VALUE pairs that modify the behavior:
% Parameter (default)           | Description
% --------------------------------------------------------------------
% UseProgressBar (1)            | Should we use a progress bar? (0/1)
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

UseProgressBar = 1;

assign(varargin{:});

max_xy_size = -Inf * ones(1,numel(CC.PixelIdxList));

if UseProgressBar,
	progressbar('Max XY calculation progress');
end;

if numel(CC.ImageSize)>=3,
    IMS3 = CC.ImageSize(3);
else,
    IMS3 = 1;
end;

for z=1:IMS3,
	for j=1:numel(CC.PixelIdxList),
		indexes_here = ROI_3d2dprojection(CC.PixelIdxList{j}, CC.ImageSize, z);
		max_xy_size(j) = max( max_xy_size(j), numel(indexes_here) );
		if UseProgressBar & ( (j==1) | mod(j,100)==0 ) ,
			progressbar( (j+(z-1)*numel(CC.PixelIdxList))/(numel(CC.PixelIdxList)*CC.ImageSize(3)) );
		end;
	end;
end;

if UseProgressBar,
	progressbar(1); % ensure it is closed 
end;

