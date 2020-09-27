function r = rot3d(theta, ax)
% ROT3D - Rotation in 3d space
%   R = vlt.math.rot3d(THETA, AXIS)
%
%  Performs a 3d rotation about one of the 3-dimensional axes.
%  If AXIS == 1, the rotation is performed about the X axis (dimension 1).
%  If AXIS == 2, the rotation is performed about the Y axis (dimension 2).
%  If AXIS == 3, the rotation is performed about the Z axis (dimension 3).
%
%  Example 1:
%
%  
%
%  See also: vlt.math.rot2d

rr = vlt.math.rot2d(theta);

if ax==1,
	r = [1 0 0; [0;0] rr];
elseif ax==2,
	r = [ rr(2,2) 0 rr(2,1); 0 1 0; rr(1,2) 0 rr(1,1) ];
elseif ax==3,
	r = [rr [0;0]; 0 0 1;];
end;


