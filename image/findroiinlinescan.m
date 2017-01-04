function [indexes,ONs,OFFs] = findroiinlinescan(rasterimagesize, linescanimagesize, linescanpoints, impixinds, dr)
% FINDROIINLINESCAN - Find a ROI defined in a raster image in a linescan
%
%  [LSINDEXES,ONs,OFFs] = FINDROIINLINESCAN(RASTERIMAGESIZE, LINESCANIMAGESIZE, LINESCANPOINTS,...
%                   ROIRASTERINDEXES, [DRIFT])
%
%  Given a list of index values of regions of interest (a cell list ROIRASTERINDEXES) that were defined
%  within a raster image of size RASTERIMAGESIZE, this function determines the corresponding
%  index values LSINDEXES where those pixels were scanned in the linescan LINESCANPOINTS (y, x)
%  with image of size LINESCANIMAGESIZE.

linesperframe = linescanimagesize(1);
N = size(linescanpoints,1); % number of points in the line scan

if isempty(dr),
	xpixels = round(repmat(linescanpoints(:,2)',linesperframe,1));
	ypixels = round(repmat(linescanpoints(:,1)',linesperframe,1));
else,
	xpixels = round(repmat(linescanpoints(:,2)',linesperframe,1) - repmat(dr(:,1),1,N));
	ypixels = round(repmat(linescanpoints(:,1)',linesperframe,1) - repmat(dr(:,2),1,N));
end;

xpixels(find(xpixels<1))=NaN;
ypixels(find(ypixels<1))=NaN;
xpixels(find(xpixels>rasterimagesize(1)))=NaN;
ypixels(find(ypixels>rasterimagesize(2)))=NaN;

inds = uint32(sub2ind(rasterimagesize, xpixels, ypixels));
lspixinds = reshape(1:size(xpixels,1)*N,size(xpixels,1),N);

for i=1:length(impixinds),
	D = zeros(size(inds));
	for jjj=1:length(impixinds{i}), % this is too slow but it's all we got right now
		D(find((impixinds{i}(jjj)==inds)))=1;
	end;
	indexes{i} = {};
	ONs{i} = {};
	OFFs{i} = {};

	if any(D(:)), % weed out cases with no overlap
		for z = 1:size(D,1),
			df = diff([0 D(z,:) 0]);
			ons = find(1==df); % ons, offs should be same lengths
			offs = find(-1==df)-1;
			ONs{i}{end+1} = ons;
			OFFs{i}{end+1} = offs;
			for j=1:length(ons),
				indexes{i}{end+1} = lspixinds(z,ons(j):offs(j));
			end;
		end;
	end;
end;


