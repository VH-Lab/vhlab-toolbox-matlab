function [xlyl,bs] = ptontoline(xy,m,b)
% PTONTOLINE - calculate distance of point onto nearest point on line (2D)
%
% [XLYL, BS] = PTONTOLINE(XY, M, B)
%
% XLYL is the distance in X and Y. BS of offset of the line that joins the point to
% the specified line M and B.
% 
% See also: PTS2LINE 

if isinf(m),
	xlyl = [b*ones(size(xy,1),1) xy(:,2)];
elseif m==0,
	xlyl = [xy(:,1) b*ones(size(xy,2),1)];
else,
	m2 = -1/m;
	bs = -m2*xy(:,1)+xy(:,2);
	xlyl = (bs-b)./(m-m2);
	xlyl(:,2) = m.*xlyl(:,1)+b;
end;
