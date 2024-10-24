function rgb_img = rescale2rgb(imagematrix, scalelow, scalehigh, colormap)
% RESCALE2RGB - create a false-color RGB image from an image matrix
% 
% RGB_IMG = RESCALE2RGB(IMAGEMATRIX, SCALELOW, SCALEHIGH, COLORMAP)
%
% Creates an RGB image out of an IMAGEMATRIX (NxM) by scaling all values in
% the range [SCALELOW(1), SCALELOW(2)] to [SCALEHIGH(1) SCALEHIGH(2)] and
% then converting the image to an RGB image using the COLORMAP.
%
% See also: vlt.math.rescale, ind2rgb
%

img = round(vlt.math.rescale(imagematrix,scalelow,scalehigh));
rgb_img = ind2rgb(img,colormap);

