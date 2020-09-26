function [m,b] = pts2line(x1y1,x2y2)
% PTS2LINE - Create a 2D line from 2 points
%
% [M,B] = PTS2LINE(X1Y1, X2Y2)
%
% Returns slope (M) and offset (B) of a line through 2 2-d points.
%
% See also: PTONTOLINE


m = (x1y1(2)-x2y2(2))./(x1y1(1)-x2y2(1));

if ~isinf(m),
	b = x1y1(2) - m*x1y1(1);
else,
	b = x1y1(1);
end;
