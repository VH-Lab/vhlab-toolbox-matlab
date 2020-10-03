function h=arrowplot(x,y, theta, scale, varargin)
% ARROWPLOT - Make a plot of arrow shapes, like quiver
%
%  H=vlt.plot.arrowplot(X,Y,THETA,SCALE, ...)
%
%  Plots arrows at positions X and Y with directions
%  THETA (in DEGREES) and scale SCALE, according to the
%  properties below, which can be modified by providing
%  additional name/value pairs.  The arrow will be rotated to
%  point in THETA (in degrees, cartesian form, so
%  0 is rightward and angle proceeds counterclockwise).
%
%  The arrow length and arrowhead length will be scaled by
%  values in SCALE.
%
%  The name/value pairs that can be specified:
%  Property (default)       : Description
%  -------------------------------------------------------
%  length (1)               : Line length
%  linethickness (2)        : Line thickness
%  linecolor ([0 0 0])      : Line color (black by default)
%  headangle (30)           : Angle of arrowhead sweep back
%  headlength (0.5)         : Size of arrowhead length
%  
%  See also: vlt.plot.drawshape
%


shape = 'arrow';
length = 1;
linethickness = 2;
linecolor = [0 0 0];
headangle = 30;
headlength = 0.5;

vlt.data.assign(varargin{:});

h = [];

tshape.shape = shape;
tshape.length = length;
tshape.linethickness = linethickness;
tshape.linecolor = linecolor;
tshape.headangle = headangle;
tshape.headlength = headlength;

 % some quick error checking

if ~vlt.data.eqlen(size(x),size(y)),
	error(['X and Y must have identical sizes']);
elseif ~vlt.data.eqlen(size(x),size(theta)),
	error(['X and Y and THETA must have identical sizes']);
elseif ~vlt.data.eqlen(size(x),size(scale)),
	size(theta), size(x), size(scale),
	error(['X and Y and THETA and SCALE must have identical sizes']);
end;

hold_state = ishold; % get hold state

for i=1:numel(x),
	myshape = tshape;
	myshape.posxy = [x(i) y(i)];
	myshape.length = myshape.length * scale(i);
	myshape.headlength = myshape.headlength * scale(i);
	myshape.direction = theta(i);

	h = cat(2,h,vlt.plot.drawshape(myshape));

	hold on; % make sure we hold on to plot multiple arrows
end;

if ~hold_state,  % leave the hold state the way the user had it
	hold off;
else,
	hold on;
end;
