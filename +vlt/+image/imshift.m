function im_out = imshift(im, shift, varargin)
% IMSHIFT - Shift an image, maintaining image size
%
%  IM_OUT = IMSHIFT(IM, SHIFT)
%
%  Shifts a 2-dimensional image IM by SHIFT pixels
%  SHIFT should be a vector with elements [SHIFT_ROWS SHIFT_COLUMNS]
%  SHIFT_COLUMNS is the number of pixels to shift the pixels to the
%  right (can be negative to shift left); SHIFT_ROWS is the number
%  of pixels to shift down (can be negative to shift up).
%
%  Note that with images, the 'X' axis typically corresponds to
%  columns, and the 'Y' axis typically corresponds to rows, so
%  consider the order of the shift parameters for your application.
%  
%  One can pass additional arguments as name/value pairs:
%  Name (default value): | Description:  
%  ---------------------------------------------------------
%  'PadValue' (0)        | Value for pixels used to pad the
%                        |   edges of the shifted image so as
%                        |   to maintain the original image size.
%

  % default values:
PadValue = 0;
assign(varargin{:});

im_sz = size(im);

im_start = [];
for i=1:length(shift),
	if shift(i)>=0,
		im_start(i) = 1;
		im_stop(i) = size(im,i) - shift(i);
	else,
		im_start(i) = -shift(i) + 1;
		im_stop(i) = size(im,i);
	end;
end;

A = repmat(PadValue,im_sz(1),shift(2));
IMC = im(im_start(1):im_stop(1),im_start(2):im_stop(2));
B = repmat(PadValue,im_sz(1),-shift(2));
D = repmat(PadValue, shift(1), im_stop(2)-im_start(2)+1);
F = repmat(PadValue,-shift(1), im_stop(2)-im_start(2)+1);

im_out = [ A [D;IMC;F] B];

