function [im_out] = circular_filter(im,useGaussian, radius, filtersize)
% vlt.image.circular_filter - applies a circular filter around a pixel that blurs.
%
% IM_OUT = vlt.image.circular_filter(IM, USEGAUSSIAN, RADIUS, FILTERSIZE)
%
% Applies a circular convolutional filter to an image IM. If USEGAUSSIAN is 1,
% then the filter is a gaussian with sigma equal to RADIUS. If USEGAUSSIAN is 0,
% then the filter is a circle with RADIUS. The filter is normalized to sum to 1.
% FILTERSIZE is the size of the filter; it is recommended that FILTERSIZE be a few times
% larger than RADIUS for Gaussian filters and a little more than twice the RADIUS for
% circular filters.
%
% The image that is returned will be a double.
%
% Written by Sam Greene and Steve.
%
% Example:
%    im = imread('coins.png');
%    im_out = vlt.image.circular_filter(im,1,10,100);
%    vlt.plot.imagedisplay(im);
%    vlt.plot.imagedisplay(im_out);
%
  
[X,Y] = meshgrid([-filtersize:filtersize], [-filtersize:filtersize]);   
                                        % Creates a grid with variables X and Y on which we can do math. 
                                        % Goes from -filtersize to +filtersize in steps of integer 1. 
                                        % filtersize is set through an input value


 % Create the filter. 
                                        
if useGaussian == 1,                    % If 1 is used, than the else condition will be bypassed.
    
	F=exp(-(X.^2+Y.^2)/(2*radius^2));   % Standard formula for Guassian dist with std dev of 'radius' units. 
                                        
else,                                   % If above criteria is not satisfied, will resort to the 'else' condition.  
    
	F=(X.^2+Y.^2) <= (radius^2);    % Creates circular filter with falloff of 'radius'.

end

F = F./sum(F(:));                       % Must normalize F so filter is closer to 1. 
                                        % Restricts image from getting brighter. 

im_out = conv2(double(im),F,'same');    % 2D convolution converting the image into a double. Apply the filter 
                                        % and argument 'same' so that filter and image have the same size. 

