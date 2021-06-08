function [bc,best_distance] = ROI_bestcolocalization(overlaps_ba, overlap_threshold, property_a, property_b)
% ROI_BESTCOLALIZATION - find the best colocalization match for an ROI
%
% BC = ROI_BESTCOLOCALIZATION(OVERLAPS_BA, OVERLAP_THRESHOLD, ...
%    [PROPERTY_A, PROPERTY_B])
%
% Identifies the best localization match for each ROI in set B onto set
% A, assuming the overlap exceeds a threshold.
%
% The "best match" is determined by the largest OVERLAP, unless an array of properties for
% ROI set A PROPERTY_A and ROI set B PROPERTY_B, in which case the closest match
% (smallest difference).
%

bc = nan(size(overlaps_ba,2),1);
best_distance = inf * ones(size(overlaps_ba,2),1);

if nargin<3,
	property_mode = 0;
elseif nargin==3,
	error(['Property list for ROI set A and B must be given if one is given.']);
else,
	property_mode = 1;
end;

[possible_matches_in_A, rois_B_with_overlaps] = find(overlaps_ba>=overlap_threshold);

for i=1:numel(rois_B_with_overlaps),
	if ~property_mode,
		dist = -overlaps_ba(possible_matches_in_A(i),rois_B_with_overlaps(i));
	else,
		dist = abs (property_b(rois_B_with_overlaps(i)) - property_a(possible_matches_in_A(i))); 
	end;
	if dist<best_distance(rois_B_with_overlaps(i)),
		% new winner
		bc(rois_B_with_overlaps(i)) = possible_matches_in_A(i);
		best_distance(rois_B_with_overlaps(i)) = dist;
	end;
end;


