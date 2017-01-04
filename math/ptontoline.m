function [xlyl,bs] = ptontoline(xy,m,b)

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
