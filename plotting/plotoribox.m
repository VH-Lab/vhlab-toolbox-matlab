function h=plotoribox(x,y,ori,width,height,revy,varargin)
% PLOTORIBOX - Plot an oriented box (as a patch) on a graph 
% 
%   H = PLOTORIBOX(X,Y,ORI,WIDTH,HEIGHT,REVY)
%
%   Plots an oriented bar centered on the position X, Y with
%   orientation ORI (in degrees, in compass coordinates; that is,
%   0 degrees is a horizontal bar, and the bar tilts in a clockwise
%   manner with increasing angle). The bar has the width WIDTH and
%   height HEIGHT.  If REVY is 1, then we assume that the Y axis direction
%   is reversed, and the orientated bar is mirror-reversed in Y.
%
%   This function can also take extra parameters as NAME/VALUE pairs.
%   PARAMETER (default):     |  DESCRIPTION:
%   ---------------------------------------------------------
%   col ([0 0 0])            |  Fill color of the bar (default is
%                            |    black [0 0 0]; white would be
%                            |    [1 1 1]
%   

theta = (180-ori) * pi/180;

trans = [cos(theta) sin(theta) ; -sin(theta) cos(theta)];

coords = [ -height -width; height -width ; height width; -height width; -height -width]*trans/2;

if revy, coords(:,2) = -coords(:,2); end;

col = [ 0 0 0 ];
assign(varargin{:});

%h=plot(coords(:,1)+x,coords(:,2)+y,varargin{:});
h=patch(coords(:,1)+x,coords(:,2)+y,col);
