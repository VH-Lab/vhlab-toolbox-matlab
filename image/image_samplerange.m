function [range, imfileinfo] = image_samplerange(imagefile, varargin)
% IMAGE_SAMPLERANGE - return the range of values in an image file
%
%  [RANGE, IMSIZE, IMFILEINFO] = IMAGE_SAMPLERANGE(IMAGEFILE, ...)
%
%  Reads in the image in IMAGEFILE and returns the range of sample values.
%  RANGE is an Nx2 vector that contains the range of values (column 1 is minimum,
%  column 2 is maximum) for each dimension of the image (e.g., 3 for an RGB image, 1
%  for a gray scale image). If IMAGEFILE describes an image with multiple frames, all
%  frames are read to find the maximum and minimum values.
%
%  IMFILEINFO is the information returned from IMFINFO.
%
%  This function can also be modified by name/value pairs:
%  Parameter (default value)   | Description
%  ------------------------------------------------------------------
%  UseRawData (1)              | Find the minimum and maximum from
%                              |   the raw data of the image.
%                              |   If this is 0, then the minimum and maximum
%                              |   are derived from the format of the data.
%                              |   (For example, for uint16, min is 0 and max is
%                              |    2^15-1.)
%  imfileinfo ([])             | Optionally, one can pass the output
%                              |   of the Matlab function IMFINFO 
%                              |   if that data has already been read; 
%                              |   this will save the time of re-reading it 
%  
%
%  See also: IMAGE, IMFINFO, NAMEVALUEPAIR
%

UseRawData = 1;
imfileinfo = [];

assign(varargin{:});

if isempty(imfileinfo),
	imfileinfo = imfinfo(imagefile);
end

n = 1;
im = imread(imagefile,'info',imfileinfo,'index',n);

range = [Inf*ones(size(im,3),1)  -Inf*ones(size(im,3),1)];

if UseRawData,
	while n<=numel(imfileinfo)
		for d=1:size(im,3),
			range(d,1) = min(min(min(im(:,:,d))),range(d,1));
			range(d,2) = max(max(max(im(:,:,d))),range(d,2));
		end
		
		n = n + 1;
		if n<=numel(imfileinfo),
			im = imread(imagefile,'info',imfileinfo,'index',n);
		end
	end
else,
	if size(im,3)>1,
		range = [zeros(size(im,3),1) ones(size(im,3),1)];
	else,
		classname = class(im);
		if ~isempty(strfind(classname,'int'))
			range = [intmin(classname) intmax(classname)];
		else,
			range = [realmin(classname) realmax(classname)];
		end;
	end
end

range = double(range);
