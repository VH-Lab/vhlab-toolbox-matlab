function b = inside_rect(rect, point)
% INSIDE_RECT - is a point (or set of points) inside a rectangle?
%
% B = INSIDE_RECT(RECT, POINT)
%
% Given a RECT = [ TOP LEFT BOTTOM RIGHT], return a 1 if POINT = [PX PY] is 
% inside the rectangle and 0 otherwise. 
%
% POINT can be a single row vector or a matrix of row vectors Nx2. If POINT
% is a row vector, then B will be a vector with 0/1 for each entry in POINT.
%

b = [];

for j=1:size(point,1),
	is_inside = point(j,2)>=rect(1)&point(j,2)<=rect(3) & point(j,1)>=rect(2) & point(j,1)<=rect(4);
	b(j) = is_inside;
end;


