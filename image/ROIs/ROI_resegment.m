function [CC] = ROI_resegment(im, indexesnd, varargin)
% ROI_RESEGMENT - resegment an ROI using an algorithm like WATERSHED
%
% [CC] = ROI_RESEGMENT(IM, INDEXESND, ...)
%
% Given pixel index values of an ROI in an image IM, ROI_RESEGMENT re-evalutes 
% the ROI using a segmenting function like WATERSHED. It returns a structure of new
% ROIs CC with fields as follows:
% Field                                | Description
% --------------------------------------------------------------
% 'Connectivity'                       | The connectivity used (see name/value pairs)
% 'ImageSize'                          | size(IM)
% 'NumObjects'                         | The number of resegmented ROIs found
% 'PixelIdxList'                       | A cell array of pixel index values of the resegmented ROIs
%
% This function also takes name/value pairs that modify its operation:
% Parameter (default)                  | Description
% -------------------------------------------------------------------
% 'resegment_algorithm' ('watershed')  | Function that is called to resegment.
% 'values_outside_roi' (0)             | What should values outside INDEXESND be set to?
%                                      |   Use NaN to use the values from IM (even though
%                                      |   they are outside ROI)
% 'use_bwdist' (0)                     | Should we use the binary distance transform for
%                                      |   the ROI data (1), or the raw data from IM (0)?
% 'connectivity'                       | The connectivity to use with the resegment algorithm.
%   (CONNDEF(NDIMS(IM),'maximal'))     |   (See HELP WATERSHED). If 0 is given, default is used.
% 'invert' (1)                         | If using raw data, multiply the image by -1
%

resegment_algorithm = 'watershed';
values_outside_roi = 0;
use_bwdist = 0;
connectivity = conndef(ndims(im),'maximal');
invert = 1;

assign(varargin{:});

if connectivity == 0,
	connectivity = conndef(ndims(im),'maximal');
end

 % copy the ROI into a small piece of memory and get the mapping between our cube and the original ROI

[cubeindexes, cubeindexes_in_roi] = ROI_isolate(size(im), indexesnd);

if use_bwdist,
	cube = bwdist(~cubeindexes_in_roi);
	cube = -cube;
	cube(~cubeindexes_in_roi) = Inf;
else,
	cube = im(cubeindexes);
	if ~isnan(values_outside_roi),
		cube(~cubeindexes_in_roi) = values_outside_roi;
	end;
	if invert,
		cube = -cube;
	end;
end;

 % resegment

eval(['L = ' resegment_algorithm '(cube);']);

CC.Connectivity = connectivity;
CC.ImageSize = size(im);
stats = regionprops('struct',L,'PixelIdxList');
CC.NumObjects = numel(stats);
CC.PixelIdxList = {stats.PixelIdxList};

 % now need to convert back to index values in the original image, and set any out-of-ROI pixels so they
 % aren't part of the resegmented ROI

for i=1:numel(CC.PixelIdxList),
	CC.PixelIdxList{i} = intersect(cubeindexes(CC.PixelIdxList{i}),cubeindexes(cubeindexes_in_roi));
end


