function r = rot3d(theta, ax)
% ROT3D - Rotation in 3d space
%   R = vlt.math.rot3d(THETA, AXIS)
%
%  Performs a 3d rotation about one of the 3-dimensional axes or an arbitrary axis.
%  If AXIS == 1, the rotation is performed about the X axis (dimension 1).
%  If AXIS == 2, the rotation is performed about the Y axis (dimension 2).
%  If AXIS == 3, the rotation is performed about the Z axis (dimension 3).
%  If AXIS is a vector of 3, then the rotation is performed about that
%  vector. The vector is first normalized.
%
%  Examples:
%    x_unit = [1;0;0];
%    y_unit = [0;1;0];
%    z_unit = [0;0;1];
%    R = vlt.math.rot3d(pi/2,1)
%    R * x_unit % 45 degree rotation about x axis, no change in x_unit
%    R = vlt.math.rot3d(pi/2,x_unit) % should be the same rotation as above
%    % now rotate the y_unit about the x axis
%    R * y_unit % moves from [0;1;0] to [0;0;1]
%  
%  See also: vlt.math.rot2d

if size(ax)==1,

    rr = vlt.math.rot2d(theta);

    if ax==1,
	    r = [1 0 0; [0;0] rr];
    elseif ax==2,
	    r = [ rr(2,2) 0 rr(2,1); 0 1 0; rr(1,2) 0 rr(1,1) ];
    elseif ax==3,
	    r = [rr [0;0]; 0 0 1;];
    end;

else, % we are rotating about an arbitrary axis
    v = ax(1:3)/norm(ax(1:3)); % normalize
    ct = cos(theta);
    st = sin(theta);
    ct_ = 1-cos(theta);

    r = [ ct+(v(1)^2)*ct_         v(1)*v(2)*ct_-v(3)*st    v(1)*v(3)*ct_+v(2)*st ; 
          v(2)*v(1)*ct_+v(3)*st   ct+v(2)^2*ct_            v(2)*v(3)*ct_-v(1)*st ;
          v(3)*v(1)*ct_-v(2)*st   v(3)*v(2)*ct_+v(1)*st    ct+v(3)^2*ct_ ];
end;


