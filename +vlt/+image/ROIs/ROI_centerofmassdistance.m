function [comd,Is,Js,Vs] = roi_centerofmassdistance(roi_com_a, La, roi_com_b, Lb, distance_max, distance_min, varargin)
% ROI_CENTEROFMASSDISTANCE - Compute center-of-mass distances between sets of ROIs
%
% [COMD] = ROI_CENTEROFMASSDISTANCE(ROI_COM_A, LA, ROI_COM_B, LB, ...
%             DISTANCE_MAX, DISTANCE_MIN, ...);
%
% For 2 sets of ROIS, calculate the center-of-mass distances for all ROIs closer than
% DISTANCE_MAX.
%
%  Inputs: 
%     ROI_COM_A and ROI_COM_B are NUM_ROIS x DIM_ROI matrixes with the center of mass
%       coordinates in each row. 
%     LA and LB are labeled image matrixes, the same size as the original
%       image. Each pixel should be labeled with a '0' if it contains no ROI, 
%        or i if it is part of the ith ROI. See also BWLABEL
%     DISTANCE_MAX the maximum distance over which to search for center-of-mass distance.
%        This is important because if the number of ROIs in A and B are large, then a full
%        matrix describing ROI overlaps would require several hundred GB of memory and is usually
%        not worth counting.
%     DISTANCE_MIN If any distance is 0, it will be set to DISTANCE_MIN. 0 is reserved for 
%        too-long distances beyond DISTANCE_MAX so that COMD can be sparse (mostly 0s).

%   Outputs: 
%     COMD: The center-of-mass distances. COMD(i,j) is the center-of-mass distance between
%         ROI i of group A and ROI j of group B. Only ROIs that have distances less than
%         DISTANCE_MAX will be have non-zero values, and any distance that is exactly zero will
%         instead have the value DISTANCE_MIN.
%
%   This function also accepts extra name/value pairs that modify the default
%   behavior of the function:
%
%   Parameter name (default)     | Description
%   ---------------------------------------------------------------
%   ShowGraphicalProgress (1)    | 0/1 Should we show a progress bar?
%   GraphicalProgressUpdate(100) | Show updates after this many ROIs in A examined
%

 % Step 1: setup
ShowGraphicalProgress = 1;
GraphicalProgressUpdate = 100;

assign(varargin{:});


Is = [];
Js = [];
Vs = [];

 % Step 2: check for overlaps

if ShowGraphicalProgress,
	progressbar('ROI overlap calculation');
end;

distance_max_int = round(distance_max);

[num_A,dim_A] = size(roi_com_a);

for i=1:num_A,
	value = round(roi_com_a(i,:)); 
	values_cell = {};

	for j=1:dim_A, % make sure in bounds; probably unnecessary
		if j==1, % b/c images are X/Y transposed
			actualj = 2;
		elseif j==2,
			actualj = 1;
		else,
			actualj = j;
		end;
		values_cell{j} = max([value(actualj)-distance_max_int:value(actualj)+distance_max_int; ones(1,2*distance_max_int+1)]);
		values_cell{j} = min([values_cell{j}; repmat(size(La,actualj),1,2*distance_max_int+1) ]);
	end;

	if dim_A>3,
		error(['I do not know how to deal with dimensions greater than 3 at this time.']); 
	end;

	[v1,v2,v3]=meshgrid(values_cell{:});

	index = sub2ind(size(La),v1,v2,v3);
	potential_overlaps = setdiff(unique(Lb(index)),0);

	distances_here = distance_min+sqrt(sum((repmat(roi_com_a(i,:)',1,numel(potential_overlaps)) ...
		- roi_com_b(potential_overlaps,:)').^2));
	justright = find(distances_here<distance_max);

	Is = [Is; repmat(i,numel(justright),1)];
	Js = [Js; colvec(potential_overlaps(justright))];
	Vs = [Vs; colvec(distances_here(justright))];

	if mod(i,GraphicalProgressUpdate)==0,
		if ShowGraphicalProgress,
			progressbar(double(i)/double(num_A));
		end;
	end;

	 % update progress bar
end


if ShowGraphicalProgress,
	progressbar(1);
end;

Is = double(Is);
Js = double(Js);

comd = sparse(Is,Js,Vs); 

