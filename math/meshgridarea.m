function area = meshgridarea(xmesh, ymesh)
% AREA = MESHGRIDAREA - Compute the area of each element of a meshgrid
%
%   AREA = MESHGRIDAREA(XMESH, YMESH)
%
% Computes the area for a mesh grid with points XMESH YMESH.
%
% This function assumes that the 'area' for each MESH pixel i,j
% is equal to (XMESH(i)-XMESH(i-1)) * (YMESH(j)-YMESH(j-1)) and
% that the area of the first row and column are equal to the second
% row and column, respectively.
%   

dX = [ xmesh(:,2)-xmesh(:,1) diff(xmesh,[],2)];
dY = [ ymesh(2,:)-ymesh(1,:) ; diff(ymesh,[],1)];

area = dX.*dY;
