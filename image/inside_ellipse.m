function z = inside_ellipse(X, Y, x_ctr, y_ctr, a, b, theta)
% INSIDE_ELLIPSE - Return 1 when a point is inside of an ellipse
%
%  Z = INSIDE_ELLIPSE(X, Y, X_CTR, Y_CTR, A, B, THETA)
%
%  Returns 1 when the point X(i), Y(i) is inside the ellipse
%  with center at X_CTR, Y_CTR, with X axis vertex A and
%  Y axis vertex B, rotated at an angle THETA (in radians), where
%  angles increase according to a compass reference
%
%  See also: INPOLYGON, CARTESIAN2COMPASS, COMPASS2CARTESIAN, DEG2RAD
%

x = X - x_ctr;
y = Y - y_ctr;

z = ( ((x*cos(theta)+y*sin(theta)).^2)./a^2 + ((x*sin(theta)-y*cos(theta)).^2)./b^2  ) <= 1;
