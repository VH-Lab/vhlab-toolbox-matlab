function bin = doublethreshold(im, t1, t2, connectivity)
% DOUBLETHRESHOLD - apply a double threshold to an image
% 
% BIN = DOUBLETHRESHOLD(IM, T1, T2, CONNECTIVITY)
%
% Calculate a binary image based on 2 thresholds. First, binary images are
% calculated based on each threshold. Second, ROIs are discovered from each 
% binary image using BWCONNCOMP. Then, ROIs generated from the lower threshold
% are examined to see if they overlap any part of an ROI from the higher
% threshold. Only objects that overlap the higher threshold will be retained.
% 
% Finally, a binary image is created from the ROIs that remain and is
% returned in BIN.
%

t_high = max(t1,t2);
t_low = min(t1,t2);

Lhigh = bwlabel(logical(im>=t_high), connectivity);
CClow  = bwconncomp(logical(im>=t_low),  connectivity);

retain = [];

for i=1:numel(CClow.NumObjects),
	if any(Lhigh(CClow.PixelIdxList{i})),
		retain(end+1) = i;
	end;
end;

CClow.NumObjects = numel(retain);
CClow.PixelIdxList = CClow.PixelIdxList(retain);

bin = logical(labelmatrix(CClow));
