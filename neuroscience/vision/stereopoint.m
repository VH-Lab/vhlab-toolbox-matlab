function [leftOffset,rightOffset]=stereopoint(ViewDist,EyeDist,XOffset,DOffset)

% STEREOPOINT - Compute shifts for a point in space for making a stereograph
%
%   [LEFTOFFSET,RIGHTOFFSET]=STEREOPOINT(VIEWDIST,EYEDIST,XOFFSET,DOFFSET)
%
%
%   Computes projections onto the two eyes for a point in 3D space.
%
%   VIEWDIST is the distance to the focal point (or the screen).
%   EYEDIST is the distance between the eyes (same units as VIEWDIST).
%
%   XOFFSET is the X offset between the focal point and the point in 3 space
%     for which to compute shifts. Positive values are to the right, use 
%     same units as VIEWDIST.
%
%   DOFFSET is the depth offset between the focal point and the point for which
%     to compute shifts.
%

doflip = 0;
flip = 0;

if doflip,
    if DOffset<0, flip = 1; DOffset = -DOffset; end;
end;

Vo = sqrt( (EyeDist/2).^2+ViewDist.^2);

thetaL = atan2(ViewDist,EyeDist/2) - atan2(ViewDist+DOffset,XOffset+EyeDist/2);
thetaR = atan2(ViewDist,EyeDist/2) - atan2(ViewDist+DOffset,-XOffset+EyeDist/2);

leftOffset = Vo*tan(thetaL);
rightOffset = -Vo*tan(thetaR);

if flip, t=leftOffset; leftOffset = rightOffset; rightOffset = t; end;