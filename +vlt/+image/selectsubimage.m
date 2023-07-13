function [im_sub] = selectsubimage(im, top, left, bottom, right, pad)
% SELECTSUBIMAGE - select a rectangle from an image, padding out-of-bounds pixels
%
% [IM_SUB] = SELECTSUBIMAGE(IM, TOP, LEFT, BOTTOM, RIGHT, [PAD])
% 
% Inputs: IM a YxX image
%         TOP the top pixel location in Y direction to select. The first index
%            in the image starts at 1. TOP can be negative, and out-of-bounds
%            values will be filled with PAD.
%         LEFT the left pixel location to select in X. The first pixel is 1. 
%            LEFT can be less than 1, and out-of-bounds values will be filled
%            with PAD.
%         BOTTOM the bottom pixel location in Y. Can exceed the number of Y
%            pixels, and out-of-bounds values will be filled with PAD.
%         RIGHT the right-ost pixel to select in X. Can exceed the number of X
%            pixels, and out-of-bounds values will be filled with PAD.
%         PAD the padding value; if not provided, it will be NaN
%
% OUTPUT: IM_SUB, the selected portion of the image.

if nargin<6,
	pad = NaN;
end;

y_select = bottom - top + 1;
x_select = right - left + 1;

[Y,X] = size(im);

top_pad = max(0,-(top-1));




 
