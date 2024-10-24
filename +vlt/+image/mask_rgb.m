function masked_rgb = mask_rgb(rgb_image, mask, mask_color)
% MASK_RGB - mask an RGB image
%
% MASKED_RGB = MASK_RGB(RGB_IMAGE, MASK, MASK_COLOR)
%
% Given an RGB_IMAGE of size NxMx3, sets all pixels indicated in the
% MASK to the 1x3 color MASK_COLOR.
% 
% MASK can either be a matrix of logical values indicating masked
% pixels, or can be the index values of the masked pixels in an NxM matrix.
% 

masked_rgb = rgb_image;

for i=1:size(masked_rgb,3),
	img_here = rgb_image(:,:,i);
	img_here(mask) = mask_color(i);
	masked_rgb(:,:,i) = img_here;
end;

