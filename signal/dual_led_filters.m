function [filters,X,Y] = dual_led_filters(da, sep, rad); 
% LED2FILTERS - Design filters for detecting dual LEDs
%
%  [FILTERS,X,Y] = DUAL_LED_FILTERS(DA, SEP, RAD)
%
%  Designs a pair of circular filters, at a range of orientations, for detecting a pair of
%  bright LEDs in an image.
%
%  Input arguments: 
%  DA - The separation between different filters in orientation (e.g., 22.5)
%  SEP - The physical separation between the the circles, in pixels (e.g., 85)
%  RAD - The radius of each circle (e.g., 15)
%
%  Outputs:
%  Filters - the output filters, as a 3d stack of filters. Each 2d element of the 2d
%  stack contains the filter for one possible orientation of the dual LEDs.
%  X - An X coordinate mesh for the filters
%  Y - A Y coordinate mesh for the filters
%  
%  Example:  Create a family of filters and display them
%   [filters,x,y] = dual_led_filters(22.5,85,15);
%   figure;
%   colormap(gray(256));
%   for i=1:size(filters,3),
%       image(x(:),y(:),255*filters(:,:,i));
%       pause(1);
%   end;
% 

angles = 0:da:180-da;
sz = sep + 2*rad; % size of filter

[X,Y]=meshgrid(-sz:sz,-sz:sz);
xy = [ 1 0]; % say 0 orientation is on the x axis

filters = [];

for i=1:length(angles) 
    ctr = (sep/2) * xy * rot2d((pi/180)*angles(i));
    myfilter = zeros(size(X));
    inds_1 = find(inside_ellipse(X,Y,ctr(1),ctr(2),rad,rad,0)); % first LED
    inds_2 = find(inside_ellipse(X,Y,-ctr(1),-ctr(2),rad,rad,0)); % second LED
    myfilter(inds_1) = 1; 
    myfilter(inds_2) = 1;

    filters = cat(3, filters, myfilter);
end;

