# vlt.signal.dual_led_filters

```
  LED2FILTERS - Design filters for detecting dual LEDs
 
   [FILTERS,X,Y] = vlt.signal.dual_led_filters(DA, SEP, RAD)
 
   Designs a pair of circular filters, at a range of orientations, for detecting a pair of
   bright LEDs in an image.
 
   Input arguments: 
   DA - The separation between different filters in orientation (e.g., 22.5)
   SEP - The physical separation between the the circles, in pixels (e.g., 85)
   RAD - The radius of each circle (e.g., 15)
 
   Outputs:
   Filters - the output filters, as a 3d stack of filters. Each 2d element of the 2d
   stack contains the filter for one possible orientation of the dual LEDs.
   X - An X coordinate mesh for the filters
   Y - A Y coordinate mesh for the filters
   
   Example:  Create a family of filters and display them
    [filters,x,y] = vlt.signal.dual_led_filters(22.5,85,15);
    figure;
    colormap(gray(256));
    for i=1:size(filters,3),
        image(x(:),y(:),255*filters(:,:,i));
        pause(1);
    end;

```
