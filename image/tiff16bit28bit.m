function [img1,img2] = tiff16bit28bit(filename, writeit)
% TIFF16BIT28BIT Convert 16bit TIFF to 8-bit
%
%   [IMG1,IMG2] = TIFF16BIT28BIT(FILENAME)
%    or
%   [IMG1,IMG2] = TIFF16BIT28BIT(FILENAME, WRITEIT)
%  
%   Opens the TIFF file with name FILENAME.  The file is assumed to
%   be grayscale.  The original image is returned in IMG1.  The image is
%   then scaled between 0 and 255 and returned as IMG2.  If 'WRITEIT' is
%   provided, then the image is saved as FILENAME_8bit.TIFF.
%
%   If the file is not a grayscale image then an error is generated.

wr = 0; % do we write our result?
if nargin>1,
	wr = writeit;
end;

img1 = imread(filename);

if size(img1,3)>1, error(['File ' filename ' is not a grayscale image.']); end;

img2 = uint8( rescale(double(img1),...
	[min(double(img1(:))) max(double(img1(:)))],...
	[0 255]));

if wr,
	[pathname,fname,extension] = fileparts(filename);
	newname = fullfile(pathname,[fname '-8bit' extension]);
	imwrite(img2,newname);
end;
