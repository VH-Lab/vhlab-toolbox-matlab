function [overlap_ab, overlap_ba] = roi_3d_all_overlaps(rois3d_a, La, rois3d_b, Lb, xrange, yrange, zrange, varargin)
% ROIS_3D_ALL_OVERLAPS - Compute overlaps between sets of 3D ROIs
%
%  [OVERLAP_AB, OVERLAP_BA] = ROI_3D_ALL_OVERLAPS(ROIS3D_A, LA, ...
%           ROIS3D_B, LB, XRANGE, YRANGE, ZRANGE, ...);
%
%  For 2 sets of ROIS, calculate the overlap of each ROI in A onto each ROI in B,
%  and vice-versa.
%
%  Inputs: 
%     ROIS3D_A and ROIS3D_B are structures returned from a function
%       like BWBOUNDARIES with fields 
%       'ImageSize'    [1x3]   : the dimensions of the original image
%       'NumObjects'   [1x1]   : the number of objects N
%       'PixelIdxList' {1xN}   : a cell array of index values for each ROI
%     LA and LB are labeled image matrixes, the same size as the original
%       image. Each pixel should be labeled with a '0' if it contains no ROI, 
%        or i if it is part of the ith ROI. See also BWLABEL
%     XRANGE, YRANGE, ZRANGE: calculate the overlap over
%          shifts of the ROIs in X, Y, and Z. e.g., XRANGE = [ -5 : 1 : 5]
%          YRANGE = [ -5 : 1 : 5], ZRANGE = [ -5 : 1 5] computes the
%          overlap for all shifts in X, Y, and Z of 5 pixels (in all
%          directions).
%   
%   Outputs: 
%     OVERLAP_AB: The maximum percentage overlap of each ROI in A onto B. OVERLAP_AB(i,j)
%       is the maximum amount of the ith ROI in A that overlaps the jth ROI in B, for
%       all XRANGE, YRANGE, and ZRANGE shifts.
%     OVERLAP_BA: The maximum percentage overlap of each ROI in B onto A. OVERLAP_BA(i,j)
%       is the maximum amount of the ith ROI in B that overlaps the jth ROI in A, for
%       all XRANGE, YRANGE, and ZRANGE shifts.
%
%   This function also accepts extra name/value pairs that modify the default
%   behavior of the function:
%
%   Parameter name (default)   : Description
%   ---------------------------------------------------------------
%   ShowGraphicalProgress (1)  : 0/1 Should we show a progress bar?
%   Flare MAX(MAX(ABS(XRANGE)),: Integer  How much should we flare out each
%      MAX(MAX(ABS(YRANGE)),   :  ROI in A to check for overlaps in B?
%        MAX(ABS(ZRANGE)) ))   : (The flare expands the ROI in all directions
%                              :  to allow us to look for overlapping ROIs.)
%

 % Step 1: setup
ShowGraphicalProgress = 1;
Flare = max( max(max(abs(xrange)), max(abs(yrange))), max(abs(zrange)) );

assign(varargin{:});

   % the below is too data intensive; better to convert to format that doesn't save all this data
   % maybe a cell list of the max overlap for all non-zero overlaps?
   % also maybe need to calculate pixels

overlap_ab = sparse(rois3d_a.NumObjects, rois3d_b.NumObjects);
overlap_ba = sparse(rois3d_b.NumObjects, rois3d_a.NumObjects);

 % Step 2: check for overlaps

progressbar('ROI overlap calculation');

for i=1:rois3d_a.NumObjects,

	% first, identify all of the potential overlaps in the labeled image
        % of all the ROIs in Lb. To save massive computing time, we'll only
        % examine overlaps from the ith roi in A to this list in B.

	ind_flared = ROI_flare_indexes(rois3d_a.PixelIdxList{i}, rois3d_a.ImageSize, ...
		Flare);
	potential_overlaps = setdiff(unique(Lb(ind_flared)),0);

	for j=1:length(potential_overlaps),
		J = potential_overlaps(j);
		[ov_ab, ov_ba] = ...
			ROI_3d_overlap(rois3d_a.PixelIdxList{i},...
			rois3d_b.PixelIdxList{potential_overlaps(j)}, xrange, yrange, zrange, ...
			rois3d_a.ImageSize);
		overlap_ab(i,J) = max(ov_ab(:));
		overlap_ba(J,i) = max(ov_ba(:));
	end;

	progressbar(i/rois3d_a.NumObjects); % update progress bar
end

