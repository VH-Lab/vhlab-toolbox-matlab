function r = refl2d(theta)

% vlt.math.refl2d - 2D reflection matrix
%
%   R = vlt.math.refl2d(THETA)
%
%   Returns R = [cos(2*THETA) sin(2*THETA) ; sin(2*THETA) -cos(2*THETA) ];

r = [cos(2*theta) sin(2*theta) ; sin(2*theta) -cos(2*theta) ];
