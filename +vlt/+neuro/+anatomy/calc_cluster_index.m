function [CI,ncells] = calc_cluster_index(cell_pts, roi_pts, scale, inj_size, windsize, windstep, area_thresh, fract_cells,indexvalues,difffunc, randfunc )

% vlt.neuro.anatomy.calc_cluster_index - Calculate cluster index from Ruthazer and Stryker
%
%   CI = vlt.neuro.anatomy.calc_cluster_index(CELL_PTS, ROI_PTS, SCALE, INJ_SIZE, WINDSIZE,
%           WINDSTEP, AREA_THRESH, FRACT_CELLS, [INDEXVALUES FUNC RANDFUNC])
%
%  Calculates the cluster index as described by Ruthazer and Stryker
%  JNeurosci 1996 16:7253-7269.
%
%  Computes the cluster index over a region of interest drawn tightly
%  around the data set excluding the injection site of size INJ_SIZE.  Square
%  windows of side size WINDSIZE are slid over the region of interest in
%  steps of WINDSTEP.  If the overlap of the window and the region of interest
%  is at least AREA_THRESH (a fraction of the total), then the cluster index
%  is computed in that window.
%  ROI_PTS and INJ_SIZE can be empty, in which case no points will be excluded,
%  the ROI will be taken to be a rectangle containing all points, the first
%  point in the cell list is assumed to be a cell and not the injection 
%  location.
%
%  The cluster index is computed by comparing nearest neighbor differences
%  of all cells in the data set to a random point.  Only FRACT_CELLS are used
%  in the calculation.  See the paper for a more complete description.
%
%  The cells are specified as a list of X-Y pairs.  It is assumed that the first
%  entry in the list is actually the injection location, not a cell.
%  The region of interest is also specified by a list of X-Y pairs that
%  define a polygon around the region of interest.  The points will be scaled
%  by SCALE, which indicates the number of point units per unit.
%
%  If the last three optional arguments are provided, then the cluster index is not 
%  computed based on physical distance between cells but rather the difference between
%  index values in INDEXVALUES, a vector w/ as many entries as there are cell points.
%  FUNC should be a string describing how to take the difference between x1 and x2,
%  INDEX values from two cells.  For example, 'min(abs([x1-x2;x1-x2-360;x1-x2+360]))'
%  or 'abs(x1-x2)'.  RANDFUNC is a function that describes how to randomly generate
%  an index value.  For example, RANDFUNC = 'rand*360' picks a value between 0 and
%  360 psuedorandomly.
%  

if nargin<9, usedistance = 1; else, usedistance = 0; end;

userand = 1;  % use random method for picking W cells
cell_pts = cell_pts / scale;
if ~isempty(roi_pts),
	dummyroi = 0;
	roi_pts = roi_pts / scale;
	mins = min(roi_pts); maxs = max(roi_pts); 
else,
	dummyroi = 1;
	mins = min(cell_pts); maxs = max(cell_pts); 
end;

xmin=mins(1); ymin=mins(2); xmax=maxs(1); ymax=maxs(2);

if isempty(roi_pts),
	roi_pts = [xmin ymin; xmin ymax; xmax ymax; xmax ymin; xmin ymin];
end;

CI = []; ncells = [];

roi_pts_ = roi_pts(:,1)+roi_pts(:,2)*sqrt(-1);
cell_pts_ = cell_pts(:,1)+cell_pts(:,2)*sqrt(-1);

if isempty(inj_size),
	injpts_ = [];
	firstpt = 1;
else,
	injvec = -1:1/50:1;
	injpts_ = inj_size*(sin(2*pi*injvec)+sqrt(-1)*cos(2*pi*injvec))+cell_pts_(1);
	firstpt = 2;
end;

cellinds = vlt.math.inside(cell_pts_(firstpt:end),roi_pts_);
cell_pts_ = cell_pts_(cellinds+firstpt-1);  % exclude pts not in roi & injection site
if ~isempty(injpts_),
	injpts = vlt.math.inside(cell_pts_,transpose(injpts_));
	cell_pts_ = cell_pts_(setdiff(1:length(cell_pts_),injpts));
else, injpts = [];
end;

sqvec = 0:windsize/50:windsize;
[XX,YY] = meshgrid(sqvec,sqvec);
sqpts_ = reshape(XX+sqrt(-1)*YY,1,length(XX)*length(YY));

%  keyboard;  if threshold is lower, Ci goes up for tree shrew

for x=xmin:windstep:xmax-windsize,
	x,
	for y=ymin:windstep:ymax-windsize,
		% test to see if area overlap exceeds threshold for inclusion
		windowpts_ = sqpts_+[x+y*sqrt(-1)];
		if dummyroi, k1 = windowpts_;
		else, k1 = vlt.math.inside(transpose(windowpts_),roi_pts_);
		end;
		if isempty(injpts), k2=[];
		else, k2 = vlt.math.inside(transpose(windowpts_),transpose(injpts_));
		end;
		%[x y], length(setdiff(k1,k2))/length(sqpts_),
		if length(setdiff(k1,k2))/length(sqpts_)>=area_thresh,
			% if exceeds area threshold, we may continue
			%[x y], % print x and y for debugging
			windowbounds_ = [x+y*sqrt(-1) x+windsize+y*sqrt(-1) ...
				x+windsize+(y+windsize)*sqrt(-1) x+(y+windsize)*sqrt(-1)];
			windcellpts = vlt.math.inside(cell_pts_,transpose(windowbounds_));

			if length(windcellpts)>1,
			ncells(end+1) = length(windcellpts);
			CIavg = [];
			for z=1:10, % must repeat ten times and average
			randptlist_ = []; % make a list of random points in window
			while (length(randptlist_)<round(length(windcellpts)*fract_cells)),
				newrndpt_ = [rand+sqrt(-1)*rand]*windsize+[x+sqrt(-1)*y];
				% this point must be out of the injection site if there is one defined
				crit1 = isempty(injpts_);
				if ~crit1, crit1 = isempty(vlt.math.inside(newrndpt_,transpose(injpts_))); end;
				crit2 = dummyroi;
				if ~crit2, crit2 = ~isempty(vlt.math.inside(newrndpt_,roi_pts_)); end;
				if crit1&crit2,
					randptlist_(end+1) = newrndpt_;
				end;
			end;
			% now compute CI using random points
			Xi = []; Wi = [];
			for r=1:length(randptlist_),
				[myXi,ind]=near_neighbor_dist(randptlist_(r),...
					cell_pts_(windcellpts));
				if userand, myrefcell = 1+fix(rand*ncells(end)); else, myrefcell = ind(1); end;
				[myWi,ind2]=near_neighbor_dist(cell_pts_(windcellpts(myrefcell)),cell_pts_(windcellpts));
				if ~usedistance, 
					x1 = indexvalues(windcellpts(ind(1))); x2 = eval(randfunc);
					myXi = eval(difffunc);
					x1 = indexvalues(windcellpts(myrefcell)); x2 = indexvalues(windcellpts(ind2(1)));
					myWi = eval(difffunc);
				end;
				Xi(end+1) = myXi; Wi(end+1) = myWi;
			end;
			CIavg(end+1) = log(sum(Xi.*Xi)/sum(Wi.*Wi));
			end;  % 10 repeats over z
			CI(end+1) = nanmean(CIavg);
			end; % if length(windcellpts)>1
		end;
	end;
end;

function [d,ind] = near_neighbor_dist(pt, ptlist)
h = find(ptlist~=pt);
[d,mind] = min(abs(ptlist(h)-pt));
ind = h(mind);
