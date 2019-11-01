function r = refl2d(theta)

% REFL2D - 2D reflection matrix
%
%   R = REFL2D(THETA)
%
%   Returns R = [cos(2*THETA) sin(2*THETA) ; sin(2*THETA) -cos(2*THETA) ];

r = [cos(2*theta) sin(2*theta) ; sin(2*theta) -cos(2*theta) ];
