function r = rot2d(theta)

% vlt.math.rot2d(THETA) 2D rotation matrix
%
%  Returns the 2D rotation matrix:
%
%    R  = [cos(theta) -sin(theta) ; sin(theta) cos(theta) ]
%

r = [cos(theta) -sin(theta) ; sin(theta) cos(theta) ];
