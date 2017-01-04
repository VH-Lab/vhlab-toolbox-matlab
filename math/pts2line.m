function [m,b] = pts2line(x1y1,x2y2)

m = (x1y1(2)-x2y2(2))./(x1y1(1)-x2y2(1));

if ~isinf(m),
	b = x1y1(2) - m*x1y1(1);
else,
	b = x1y1(1);
end;
