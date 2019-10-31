function dr = driftcheck(im1,im2,searchX, searchY, varargin)

% DRIFTCHECK - Checks for drift in image pair by correlation
%
%   DR = DRIFTCHECK(IM1,IM2,SEARCHX,SEARCHY,...)
%
%  Checks for drift over the specific offset ranges
%  SEARCHX = [x1 x2 x3] and SEARCHY = [y1 y2 y3].
%  Positive shifts are rightward and upward with respect to
%  the original.
%
%  This function accepts additional parameter as name/value pairs.
%  Parameter (default value) | Description
%  -----------------------------------------------------------------
%  subtractmean (0)          | (0/1) If 1, subtract the mean of each image
%                            |    before correcting
%  brightnessartifact (100)  | (0-100) Set all pixels above this percentile of
%                            |    brightness to the mean of the image (100 means
%                            |    no change)
%  darknessartifact (0)      | (0-100) Set all pixels below this percentile of
%                            |    brightness to the mean of the image (0 means
%                            |    no change)
%  brightnesscorrect (1)     | (0/1) If 1, images are normalized
%                            |    by their standard deviation before
%                            |    correlating. This allows accurate correlation
%                            |    where total image brightness has changed.
%  roicorrect (1)            |  (0/1) If 1, only the pixels above the 'mn' 
%                            |    are considered in the correlation.
%  
%
%  The best offset, as determined by correlation, is returned
%  in DR = [OFFSET_X OFFSET_Y].
%
%  This function calls the xcorr2dlag MEX file; this function
%  will produce an error if this function is not compiled for
%  your platform.
%
%

subtractmean = 0;
brightnessartifact = 100;
darknessartifact = 25;
brightnesscorrect = 1;
roicorrect = 1;

assign(varargin{:});

bestavgcorr = [-Inf];
dr = [NaN NaN];

if subtractmean,
	im1 = im1 - nanmean(im1(:));
	im2 = im2 - nanmean(im2(:));
end;

if brightnessartifact<100,
	m1 = median(im1(:));
	m2 = median(im2(:));
	p1 = prctile(im1(:),brightnessartifact);
	p2 = prctile(im2(:),brightnessartifact);
end;

if darknessartifact>0,
	if brightnessartifact>=100,
		m1 = median(im1(:));
		m2 = median(im2(:));
	end;
	d1 = prctile(im1(:),darknessartifact);
	im1(find(im1<=d1)) = m1;
	d2 = prctile(im2(:),darknessartifact);
	im2(find(im2<=d2)) = m2;
end;

if brightnessartifact<100,
	im1(find(im1>=p1)) = m1;
	im2(find(im2>=p2)) = m2;
end;


if roicorrect,
	mn1 = nanmean(im1(:)); mn2 = nanmean(im2(:));
	im1mask = im1>mn1; im2mask = im2>mn2;
	try,
		im1mask = conv2(single(im1mask),[1 1; 1 1],'same');
		im2mask = conv2(single(im2mask),[1 1; 1 1],'same'); % take pixel if any bordering pixel is above mean
	catch,
		error(['Cold not blur bright (image above mean) pixel image.']);
	end;
	im1(im1mask==0) = 0;
	im2(im2mask==0) = 0;
end;

if brightnesscorrect,
	mn1 = nanmedian(im1(:));
	mn2 = nanmedian(im2(:));
	im1 = rescale(im1,mn1+2*nanstd(im1(:))*[-1 1],[-1 1]);
	im2 = rescale(im2,mn2+2*nanstd(im2(:))*[-1 1],[-1 1]);
end;

%im1 = im1(100:700,1:300);
%im2 = im2(100:700,1:300);

sz = size(im1);

% new method with mex file
norm = repmat(sz(1)-abs(searchY)',1,length(searchX)).* ...
	repmat(sz(2)-abs(searchX),length(searchY),1);

avgcorr = xcorr2dlag(im1,im2,searchX,searchY)./norm;
[y]=max(max(avgcorr));
[i,j] = ind2sub(size(avgcorr),find(avgcorr==y));
dr = [searchX(j(1)) searchY(i(1))];

return;

% old method

for x=searchX,
	for y=searchY,
		if x>=0, start1x = 1+x; end1x = sz(2); start2x = 1; end2x = sz(2)-x;
		else, start1x = 1; end1x = sz(2)+x; start2x = 1-x; end2x = sz(2);
		end;
		if y>=0, start1y = 1+y; end1y = sz(1); start2y = 1; end2y = sz(1)-y;
		else, start1y = 1; end1y = sz(2)+y; start2y = 1-y; end2y = sz(1);
		end;
		avgcorr=nansum(nansum(im1(start1y:end1y,start1x:end1x).*(im2(start2y:end2y,start2x:end2x))))./((sz(1)-abs(x))*(sz(2)-abs(y)));
		if avgcorr>bestavgcorr,
			bestavgcorr = avgcorr;
			dr = [x y];
		end;
	end;
end;
