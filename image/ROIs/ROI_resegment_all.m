function [CC, L] = ROI_resegment_all(CC, L, im, varargin)
% ROI_RESEGMENT_ALL - resegment ROIs from an image (such as with WATERSHED), updating ROIs and labeled image
% 
% [CC, L] = ROI_RESEGMENT_ALL(CC, L, IM, ...)
%
% Returns a modified set of ROIs given a labeled image L, a list of ROIs returned from BWCONNCOMP (CC)
% and the original image IM. 
% 
% This function takes parameters as name/value pairs that modify its behavior:
% Parameter (default)                 | Description
% ------------------------------------------------------------------------------
% resegment_namevaluepairs ({})       | Name/value pairs to pass to ROI_resegment
%                                     |   (see HELP ROI_RESEGMENT)
% rois_to_update ([1:CC.NumObjects])  | Index values of ROIs to update (can be a subset)
%
%
% Example:
%     myimg = ROI_imageexample;
%     imagedisplay(myimg);
%     BW = myimg>1e-3;
%     CC_orig = bwconncomp(BW);
%     L_orig = labelmatrix(CC_orig);
%     figure, imshow(label2rgb(L_orig));
%     [CC_new,L_new] = ROI_resegment_all(CC_orig, L_orig, myimg);
%     figure, imshow(label2rgb(L_new));

resegment_namevaluepairs = {};
rois_to_update = 1:CC.NumObjects;

assign(varargin{:});

for i=1:numel(rois_to_update),
	CCnew = ROI_resegment(im, CC.PixelIdxList{rois_to_update(i)}, resegment_namevaluepairs{:});
	if CCnew.NumObjects > 1, % we have to add some ROIs
		L(CC.PixelIdxList{rois_to_update(i)}) = 0; % remove existing label label
		CC.PixelIdxList{rois_to_update(i)} = CCnew.PixelIdxList{1}; % update the indexes
		L(CC.PixelIdxList{rois_to_update(i)}) = rois_to_update(i);  % update the labeled image
		for j=2:CCnew.NumObjects,
			CC.NumObjects = CC.NumObjects + 1;
			CC.PixelIdxList{end+1} = CCnew.PixelIdxList{j};
			L(CC.PixelIdxList{end}) = numel(CC.PixelIdxList); % update labeled image
		end
	end
end

