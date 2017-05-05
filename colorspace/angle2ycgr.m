function [ctab, value, rgb] = angle2ycgr(angle)
% ANGLE2YBRG - Determine color by angle 0-360 degrees
%
% [CTAB, VALUE, RGB] = ANGLE2YCGR([ANGLE])
%
% Returns a color table for angle values 0:1:359. If a specific 
% ANGLE is given as an input argument, the function will also return
% the (interpolated) value of the ANGLE in the space of the color table CTAB,
% and the interpolated RGB value.
%
% The color space ranges from yellow ([1 1 0]) at 0 degrees, to green at
% 90 degrees ([0 1 0]), to cyan at 180 degrees ([0 1 1]), to red ([1 0 0]) 
% at 270 degrees, and back to yellow at 360 degrees/0 degrees.
%
% See also: ANGLE2YBGR
% 
% Examples:
%   ctab = angle2ycgr; % (can serve as a color map for angle data)
%
%   angle = 5.5;
%   [ctab, value, rgb] = angle2ycgr(angle);
%   


x1 = [0;90;180;270;360];
y1 = [ [1 1 0]; [0 1 0]; [0 0 1]; [1 0 0]; [1 1 0] ];

x = 0:359;
ctab = interp1(x1,y1,x,'linear');

if nargin<1,
	value = [];
	rgb = [];
else,
	angle = mod(angle, 360);
	value = interp1([0;360], [0;1]*size(ctab,2), angle, 'linear');
	rgb= interp1(x1, y1, angle, 'linear');
end;

