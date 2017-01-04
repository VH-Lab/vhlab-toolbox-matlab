function newimage = drawbarinimage(image, color,center, siz, thickness, orientation)

% DRAWBARINIMAGE - Draw bar in image
%
%  Draws a bar of a particular orientation and size in
%  an image at the location specified.
%
%  NEWIMAGE=DRAWBARINIMAGE(IMAGE,COLOR,CENTER,...
%      SIZE,THICKNESS, ORIENTATION)
%
%  Draws a bar of color COLOR in an image IMAGE.  The bar will
%  have LENGTH, THICKNESS and ORIENTATION (in degrees).
%  The bar will be centered at CENTER = [ X Y ]
%

sz = size(image);
if length(sz)==2,
    image = cat(3,image,image,image);
    if max(max(image))>1|min(min(image))<0, error(['Image values must be in 0..1.']); end;
end;
[blank_x,blank_y] = meshgrid(1:sz(2),1:sz(1));

theta = (90+90+90-orientation)*pi/180;  % convert to radians 
th =  0.5*thickness/siz;  % thickness
xi_ = []; yi_ = [];
theta_ = theta + pi;  % first points are in negative direction
xi_(end+1)=sin(theta_)+th*sin(theta_+pi/2);yi_(end+1)=cos(theta_)+th*cos(theta_+pi/2);
xi_(end+1)=sin(theta_)-th*sin(theta_+pi/2);yi_(end+1)=cos(theta_)-th*cos(theta_+pi/2);
theta_ = theta;       % next points is in positive direction
xi_(end+1)=sin(theta_)+th*sin(theta_+pi/2);yi_(end+1)=cos(theta_)+th*cos(theta_+pi/2);
xi_(end+1)=sin(theta_)-th*sin(theta_+pi/2);yi_(end+1)=cos(theta_)-th*cos(theta_+pi/2);
theta_ = theta + pi;  % back to original point to complete line
xi_(end+1)=sin(theta_)+th*sin(theta_+pi/2);yi_(end+1)=cos(theta_)+th*cos(theta_+pi/2);
xi=xi_*siz+center(1); yi=yi_*siz+center(2);
inds = inpolygon(blank_x,blank_y,xi,yi);

im1 = image(:,:,1); im2 = image(:,:,2); im3=image(:,:,3);
im1(inds)=color(1); im2(inds)=color(2); im3(inds)=color(3);
newimage = cat(3,im1,im2,im3);