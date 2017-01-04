function pnew = polyflare(p, N)
% POLYFLARE - Flare out a polygon by N units
%
%   PNEW = POLYFLARE(P,N)
%
%   This function enlarges a polygon by a fixed unit on all
%   vertices. At each point, the polygon is stretched in both
%   X and Y directions by N. The directions that causes the area to increase
%   are chosen for the new polygon.
%
%   Example:
%        x = [63 186 54 190 63]';
%        y = [60 60 209 204 60]';
%        figure;
%        plot(x,y,'o');
%        polynew = polyflare([x y],0.5);
%        hold on;
%        plot(polynew(:,1),polynew(:,2),'go'); 
%
%
%   See also: INSIDE, ROIPOLY, POLYAREA

if ~eqlen(p(end,:),p(1,:)),
	p(end+1) = p(1,:); % make sure we have a closed loop 
end;

pnew = p;

X = [ -1  1 -1 1  0 0 -1 1 0];
Y = [ -1 -1  1 1 -1 1  0 0 0];

for i=1:size(pnew,1)-1,
	mx = -Inf;
	goodj = 0;
	for j=1:9,
		pnew_{j} = pnew;
		pnew_{j}(i,1) = pnew(i,1)+X(j)*N;
		pnew_{j}(i,2) = pnew(i,2)+Y(j)*N;
		if i==1, % make sure to move last point in same way, too
			pnew_{j}(end,1) = pnew(end,1)+X(j)*N;
			pnew_{j}(end,2) = pnew(end,2)+Y(j)*N;
		end;
		A_ = polyarea(pnew_{j}(:,1),pnew_{j}(:,2));
		if A_>mx,
			mx = A_;
			goodj = j;
		end;
	end;
	pnew = pnew_{goodj};
end;
