function [pts,imagesize] = image_samplepoints(imagefile, N, method,varargin)
% IMAGE_SAMPLEPOINTS - Sample points from an image file
%
%  [PTS, IMAGESIZE] = IMAGE_SAMPLEPOINTS(IMAGEFILE, N, METHOD)
%
%  This function samples N values from the image file in
%  IMAGEFILE. METHOD can be 'random' or 'sequential'.
%  The image size is returned in IMAGESIZE. Note that IMAGESIZE corresponds
%  to the number of samples [HEIGHT WIDTH NUMBER_OF_IMAGES], regardless of 
%  whether the samples are singles, triples (RGB), quads (e.g., CMYK).
%
%  The N samples are drawn with replacement; it is possible the same value is
%  drawn more than once.
%
%  PTS is an NxDIM matrix of samples from the image. If the image is
%  grayscale (single channel), then DIM is 1. If it is RGB, then DIM is 3, etc.
%
%  This function accepts additional parameters as name/value pairs:
%  Parameter (default)   | Description
%  ----------------------------------------------------------------
%  info ([])             | Optionally, one can pass the output of
%                        |   imfinfo as info; it saves time beause
%                        |   IMAGE_SAMPLEPOINTS doesn't need to read it
% 

info = [];

assign(varargin{:});

if isempty(info),
    info = imfinfo(imagefile);
end;

imagesize = [info(1).Height info(1).Width length(info)];

dim_per_sample = length(info(1).BitsPerSample);
singleimagesize = [imagesize(1) imagesize(2) dim_per_sample];

num_samples = prod(imagesize);

switch method,
	case 'random',
		sample_numbers = ceil(rand(N,1)*num_samples);
		sample_numbers(find(sample_numbers==0)) = 1; % just in case
	case 'sequential',
		sample_numbers = 1:N; 
end;

[i1,i2,i3] = ind2sub(imagesize, sample_numbers); % find locations in the image

image_indexes = unique(i3); % which image frames do we need to load?

pts = [];

for i=1:length(image_indexes),
	indexes_here = find(i3==image_indexes(i));
	im = imread(imagefile,'index',image_indexes(i),'info',info);
	point_indexes = sub2ind(singleimagesize, ...
		repmat(i1(indexes_here),1,dim_per_sample), ...
		repmat(i2(indexes_here),1,dim_per_sample),...
		repmat(1:dim_per_sample,length(indexes_here),1));
	pts=[pts; reshape(im(point_indexes),length(indexes_here),dim_per_sample)];
end;

