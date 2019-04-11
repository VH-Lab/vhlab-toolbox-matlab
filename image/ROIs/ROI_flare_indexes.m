function [indexesflared] = ROI_flare_indexes(indexes, imsize, n)
% ROI_FLARE_INDEXES - flare a given ROI specified by indexes in an image
%
%  INDEXESFLARED = ROI_FLARE_INDEXES(INDEXES, IMSIZE, N)
%
%  For an ROI specified by the INDEXES in image of size IMSIZE, return the
%  indexes of the ROI flared out by N pixels in INDEXESFLARED.
%
%  See also: IND2SUB, SUB2IND

indexesflared = indexes(:);

[i, j, k] = ind2sub(imsize,indexes(:));

xrange = [-n:n];
yrange = [-n:n];
zrange = [-n:n];

for xi=1:length(xrange),
	x=xrange(xi);
	for yi=1:length(yrange),
		y=yrange(yi);
		for zi=1:length(zrange),
			z=zrange(zi);

			shifted_x = i+x;
			shifted_y = j+y;
			shifted_z = k+z;

			good_x = find(shifted_x>1 & shifted_x<=imsize(1));
			good_y = find(shifted_y>1 & shifted_y<=imsize(2));
			good_z = find(shifted_z>1 & shifted_z<=imsize(3));

			good = intersect(intersect(good_x,good_y),good_z);

			if length(good)>0,
				indexesflared = cat(1,indexesflared(:),...
					sub2ind(imsize,shifted_x(good),shifted_y(good),shifted_z(good)) );
			end;
		end;
	end;
end;

indexesflared = unique(indexesflared);
