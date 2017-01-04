function [x,y,h] = plotrasterroionlinescan(linescanimage,rasterimsize,roiinds,linescanpoints,dr, varargin)
% PLOTRASTERROIONLINESCAN - Plot an ROI defined in an raster image on a linescan image
%
%  [H] = PLOTRASTERROIONLINESCAN(LINESCANIMAGE,RASTERIMSIZE,ROIINDS,...
%        LINESCANPOINTS,[DR],...);
%
%
%  Inputs:
%      LINESCANIMAGE - An NxM image of a linescan recording, where N is the number of 
%          lines and M is the number of data points per line
%      RASTERIMSIZE - Raster image size NxM
%      ROIINDS - Index values corresponding to the ROI
%      LINESCANPOINTS - the points of the linescan on the raster image
%      DR - any drift that might have occurred over the recording
%
%  Extra arguments can be given as name/value pairs:
%
%   CONTOURS              |  Plot contours around ROIs (default 1)
%   INDEXES               |  Fill index values of ROI (default 0)
%   

contours = 1;
indexes = 0;
usepolyflare = 1;

assign(varargin{:});

[subpixelinds,ONs,OFFs] = findroiinlinescan(rasterimsize, ... % raster size
					size(linescanimage), ... % linescan image size
					linescanpoints, ... % linescan points
					{roiinds}, ... % pixel indexes in raster image
					dr); % drift


h = [];

mx = max(linescanimage(:));
mn = min(linescanimage(:));
lsimg = rescale(linescanimage,[mn mx],[0 254]);
image(lsimg);
colormap([gray(255);[1 0 0]]);


if contours,
	cols = get(gca,'ColorOrder');
	z = zeros(size(linescanimage));
	z([subpixelinds{:}{:}]) = 1;
	[BW] = bwboundaries(z,4);
	hold on;
	for i=1:length(BW),
		if length(BW{i}(:,2))==1, % if it is a single point, flare it out
			BW{i} = BW{i} + [-0.5 -0.5 0.5 0.5];
		else, % flare it out using polyflare
			if usepolyflare,
				BW{i} = polyflare(BW{i},0.5);
			end;
		end;
		h(end+1) = plot(BW{i}(:,2),BW{i}(:,1),'-','color',cols(1+mod(i,size(cols,1)),:));
	end;
end;

if indexes,


end;
