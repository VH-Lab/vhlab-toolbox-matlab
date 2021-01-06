function L_out = ROI_assignneighbors(L, im, indexes_to_search)
% ROI_3D_ASSIGNNEIGHBORS - assign neighbors to adjacent ROIs
%
% L_OUT = ROI_ASSIGNNEIGHBORS(L, IM, INDEXES_TO_SEARCH)
%
% Searches the labeled ROI matrix L for unlabeled pixels (in 
% INDEXES_TO_SEARCH), and assigns these pixels be part of an immediately
% neighboring ROI. The brightest neighboring pixel in IM is used to determine
% which ROI will be assigned. 
%
% This function is useful after WATERSHED resegmentation, which leaves a 1 pixel
% boundary between the resegmented ROIs.
% 
% Example:
%   A = zeros(6,6);
%   A(3,2) = 2;
%   A(3,3) = 1;
%   A(3,4) = 3;
%   L = bwlabel(A)
%   indexes_to_search = find(L);
%   L2 = L;
%   L2(3,3) = 0;
%   L2(3,2) = 2  % segment the initial ROI into 2 with a 1 pixel border
%                % might mimic output of WATERSHED
%   L_out = ROI_assignneighbors(L2, A, indexes_to_search)
%

L_out = L;

 % Where do we need to search? Only the indexes to search that are unassigned
labeled_values =  L(indexes_to_search);
indexes_zero = indexes_to_search(find(labeled_values==0));

for i=1:numel(indexes_zero),
	% find all neighbors
	I = neighborindexes(size(L), indexes_zero(i));
	% now examine only neighbors that are already assigned to an ROI
	assigned_neighbor_indexes = I(find(L(I)>0));
	if ~isempty(assigned_neighbor_indexes),
		pixel_values = im(assigned_neighbor_indexes);
		[mx,index] = max(pixel_values);
		L_out(indexes_zero(i)) = L(assigned_neighbor_indexes(index));
	end;
end;

